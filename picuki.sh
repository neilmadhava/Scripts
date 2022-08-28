#!/bin/bash

# Program to download all posts from picuki.com
# First need to load the entire page  
# Manually scroll through all posts and copy html in a text file

echo -n "Enter html file name: "
read html

fname=1
media=`cat "$html" | grep -Po '<a href="https://www.picuki.com/media/\K[^"\x27]+'`

echo "$media" | while read line; do
	req_link="https://www.picuki.com/media/$line"
	echo $req_link
	# checking if media already exists. If it does, skip iteration.
	if [[ -e $line-1.jpg || -e $line-1.mp4 ]]; then
		continue
	fi

	echo -n "requesting server: "
	img_links=`curl -s -i $req_link | grep -Po '<img src="https://cdn1.picuki.com/hosted-by-instagram/\K[^"\x27]+'`
	echo "$img_links" | while read part_link; do
		img_link="https://cdn1.picuki.com/hosted-by-instagram/$part_link"
		if [[ -n $part_link && ! -e $line-$fname.jpg ]]; then
			wget $img_link -O "$line-$fname.jpg" -q --show-progress
			fname=`expr $fname + 1`
			sleep 1
# comment out the next elif section if downloading video is not required
		# elif [[ -n `curl -s -i $req_link | grep -Po '<video'`  && ! -e $line-$fname.mp4 ]]; then
		# 	vid_part=`curl -s -i $req_link | grep -Po 'src="https://cdn2.picuki.com/hosted-by-instagram/\K[^"\x27]+'`
		# 	if [[ -n $vid_part ]]; then
		# 		vid_link="https://cdn2.picuki.com/hosted-by-instagram/$vid_part"
		# 		wget $vid_link -O "$line-$fname.mp4" -q --show-progress
		# 		fname=`expr $fname + 1`
		# 		sleep 1
		# 	fi
		fi
	done
done
