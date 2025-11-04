chr=$1
generator=$2
threads=$3
if [ -e "$generator.chr"$chr".counts" ]
then 
	echo "$generator.chr"$chr".counts alredy exists, skipping"; 
else
	paste <(awk '{print $chr "\t" $generator "\t" $3 "\t" $4 "\t" $6 }' ~/Projects/CopyNumber/chr"$chr".k25.bed.singletons.bed) <(awk '{print $4}' ~/Projects/CopyNumber/chr"$chr".k25.bed.singletons.bed | jellyfish query  -i $generator) > $generator.chr"$chr".counts
fi 

#awk '{OFS = "\t"; print $0}' $generator.chr"$chr".counts | ~/bin/copynumber/BinCopynumber 100 > $generator.chr"$chr".counts.0.1k.bins &
for i in 10 100; do 
	if [ -e "$generator.chr"$chr".counts."$i"k.bins" ]
	then 
		echo "$generator.chr"$chr".counts."$i"k.bins already exists, skipping"
	else 
		echo "awk '{OFS = "\t"; print \$0}' $generator.chr"$chr".counts | ~/bin/copynumber/BinCopynumber $(echo "$i*1000" | bc) > $generator.chr"$chr".counts."$i"k.bins" 
	fi 
done | gargs_linux '{}' -p 2

#awk '{OFS = "\t"; print $0}' $generator.chr"$chr".counts | ~/bin/copynumber/BinCopynumber 1000 > $generator.chr"$chr".counts.1k.bins &
#awk '{OFS = "\t"; print $0}' $generator.chr"$chr".counts | ~/bin/copynumber/BinCopynumber 10000 > $generator.chr"$chr".counts.10k.bins &
#awk '{OFS = "\t"; print $0}' $generator.chr"$chr".counts | ~/bin/copynumber/BinCopynumber 100000 > $generator.chr"$chr".counts.100k.bins &
wait
#bedtools nuc -fi ~/references/grch38.fasta -bed $generator.chr"$chr".counts.0.1k.bins > $generator.chr"$chr".counts.0.1k.bins.gc &

for i in 10 100; do
	if [ -e "$generator.chr"$chr".counts."$i"k.bins.gc" ]
	then 
		echo "$generator.chr"$chr".counts."$i"k.bins.gc already run, skipping"
	else 
		echo "bedtools nuc -fi ~/references/grch38.fasta -bed $generator.chr"$chr".counts."$i"k.bins > $generator.chr"$chr".counts."$i"k.bins.gc"
	fi 
done | gargs_linux '{}' -p 2


#bedtools nuc -fi ~/references/grch38.fasta -bed $generator.chr"$chr".counts.10k.bins > $generator.chr"$chr".counts.10k.bins.gc &
#bedtools nuc -fi ~/references/grch38.fasta -bed $generator.chr"$chr".counts.100k.bins > $generator.chr"$chr".counts.100k.bins.gc &
wait
