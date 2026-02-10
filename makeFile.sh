chr="$1"
size="$2"
paste <(seq -f "%.0f" 1 $(echo "$size - 25" | bc)) <(seq -f "%.0f" 26 $size) | awk -v ch=$chr '{print ch "\t" $1 "\t" $2 }'
