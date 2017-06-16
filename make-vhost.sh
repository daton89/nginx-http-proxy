#!/bin/bash

START=$(date +"%s")
DATE=$(date +"%d-%m-%Y_%H-%M")
TODAY=$(date)

printf "\nNow is $TODAY \n\n"


if [ -n "$1" ]; then
figlet "Yooo Tony!"
else
echo "### --- ### --- vhost name required! Exiting... --- ### --- ###"
exit 1
fi

echo "------------- Building of new vhost: $1 started! --------------"


