#!/bin/bash

echo -n "Enter movie to search for: "
read movie
x="https://1337x.to/search/`echo $movie | tr ' ' '+'`/1/"
echo "Sending request to $x"; echo ""

result=`curl -s -i $x | grep -Po '<a href="/torrent/\K[^"\x27]+' | sort -u`

echo "$result" | while read line; do
	echo "https://1337x.to/torrent/$line"
done
