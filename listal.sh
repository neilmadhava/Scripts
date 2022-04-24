#!/bin/bash

echo -n "Enter link: "
read link
echo -n "Enter number of pages: "
read pages

for i in $(seq 1 $pages); do 
	req_link="$link/$i"
	results=`curl -s -i $req_link -A 'Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0' -H 'Cookie: s=abbde6ca83b00b366df00e5333e4dd7a; t=703e2206eb3c09d8fdd60bad923a05bd;ls=um582knel3mube4guq9t16mhvg' | grep -Po 'https://www.listal.com/viewimage/\K[^"\x27]+'`
	num_result=`echo "$results" | wc -l`

	echo "Downloading page $i: $num_result images"	
	if [ $num_result != 1 ]; then
		echo "$results" | while read line; do
			img_link="https://ilarge.lisimg.com/image/$line/1080full-amy-aela.jpg"
			if [ $img_link != "https://ilarge.lisimg.com/image/0/1080full-amy-aela.jpg" ]; then
				wget $img_link -q --show-progress -O "$line.jpg" 
				sleep 1
			fi
		done
	fi
done


