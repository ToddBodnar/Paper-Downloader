python scholar.py -C $1 --csv | while IFS=\| read  name url other;do echo $name; echo $url; done | grep "pdf" > .tmp_cluster_urls

if [ -s .tmp_cluster_urls ]
then
 	wget -i .tmp_cluster_urls $2
else
	echo "error"	
fi


