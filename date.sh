#!/bin/bash


date_filter=$(date | grep "$1" | awk '{print $3}')
echo "$date_filter" > file2.txt
cat file2.txt

echo "done"

