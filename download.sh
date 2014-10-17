mkdir -p data/"$1"

python scholar.py -c 10 -A "$1" --csv-header > data/"$1"/metadata

if [ ! -s data/"$1"/metadata ]
then
	echo "No papers found!! (Rate limited?)"
	exit
fi

python scholar.py -c 10 -A "$1" --citation=format=bt > data/"$1"/library.bib

cat header.html > data/"$1"/nopdfs.html

cat data/"$1"/metadata | tail -n +2 | while IFS=\| read title url year num_citations num_versions cluster_id url_pdf url_citations
do
	echo "Processing $title"

	python scholar.py -C $cluster_id --csv | while IFS=\| read  name url other;do echo $name; echo $url; done | grep "pdf" | head -n1 > .tmp_cluster_urls

	if [ -s .tmp_cluster_urls ]
	then
 		wget -i .tmp_cluster_urls -O "data/$1/$title.pdf" 
	fi

	if [ $? -ne 0 ]	|| [ ! -s .tmp_cluster_urls ]
	then
		echo "<a href = \"$url\" > $title </a><br>" >> data/"$1"/nopdfs.html
	fi
	sleep 10
done


