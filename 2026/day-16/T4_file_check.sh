#!/bin/bash

read -p "enter file name: " filename

if [ -f $filename ];then
	echo "$filename exist"
else
	echo "$filename doen't exist, please check path"


fi



