#!/bin/bash

read -p "Enter service name to check: " servicename

read -p "Do you want to check status?(y/n): " ans

if [ $ans = y ];then
	systemctl status $servicename

fi

