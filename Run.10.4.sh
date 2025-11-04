#Requirements: 
#	gargs_linux
#	jellyfish
#	bedtools
#	samtools
#	g++


set -e

g++ -o ModelDist ModelDist.cpp Util.cpp -std=gnu++0x

generator=$1
threads=$2

RDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
bash $RDIR/RunJelly.fastq.sh $generator $threads

for i in X Y M {1..22} ; do 
	if [ -e $generator.Jhash.chr"$i".countst ]
	then 
		b="1"
	else
		echo "bash $RDIR/RunSingle.sh $i $generator.Jhash"
	fi
done | gargs_linux '{}' -p 4

#rm $generator.combined.0.1k
#touch $generator.combined.1k
touch $generator.combined.10k
touch $generator.combined.100k
#rm $generator.combined.1k
rm $generator.combined.10k
rm $generator.combined.100k

if [ -e $generator.Jhash.histo ]
then
        echo "Jhash already exists, skipping " 
else
        jellyfish histo -o $generator.Jhash.histo $generator.Jhash
fi

perl -ni -e 's/ /\t/;print' $generator.Jhash.histo

if [ -e $generator.Jhash.histo.7.7.model ]
then
        echo "Model allready run"
else
        $RDIR/ModelDist  $generator.Jhash.histo 25 150 8 > $generator.Jhash.histo.model.out
fi

SC=$(echo "$(grep "Best Model" $generator.Jhash.histo.model.out | awk '{print $6}')  ")
echo "$SC"

for i in {1..22} X Y ; do
        cat $generator.Jhash.chr"$i".counts.100k.bins >> $generator.combined.100k
done
Rscript ~/bin/copynumber/CopyNumber.single.R $generator.combined.100k $SC 50000

for i in {1..22} X Y; do
        cat $generator.Jhash.chr"$i".counts.10k.bins >> $generator.combined.10k
done
Rscript ~/bin/copynumber/CopyNumber.single.R $generator.combined.10k $SC 5000


for i in {1..22} X Y M; do 
        cat $generator.Jhash.chr"$i".counts.1k.bins >> $generator.combined.1k
done
Rscript ~/bin/copynumber/CopyNumber.single.R $generator.combined.1k $SC 500


#for i in {1..22} X Y M; do 
#       #cat $generator.Jhash.chr"$i".counts.0.1k.bins >> $generator.combined.0.1k
#done 
#Rscript ~/bin/copynumber/CopyNumber.single.R $generator.combined.0.1k $SC 50

