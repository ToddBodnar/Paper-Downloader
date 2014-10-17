cat $1 | while read line
do
	bash download.sh $line
done
