bed=$1
Jhash=$2
paste $bed <(awk '{print $4}' $bed | jellyfish query   -l -i $Jhash)


