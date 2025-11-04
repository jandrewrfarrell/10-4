gen=$1
cores=$2
if [ -e "$1.Jhash" ]
then
	echo "$1.Jhash exists, skipping"
else
	jellyfish count -L 2 -m 25 -s 4G --disk -t $cores -C  -g $1 -G $cores  -o $1.Jhash 
fi
