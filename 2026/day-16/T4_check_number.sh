#!/bin/bash

read -p 'Enter Number: ' num

if [ "$num" -gt 0 ];then
	echo "Your number $num is positive integer"

elif [ "$num" -lt 0 ]; then
	echo "Your number $num is negative integer"

else 
	echo "Your number $num is zero"

fi
