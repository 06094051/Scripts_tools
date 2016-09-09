#!/bin/sh

echo "Begin Push..."

 ftpsync /FTP/Sync  ftp://arg:H3carg-ftp@60.12.237.210/Sync

if [ $? -eq 0 ]
then
   #Dest Dir
   CURRENT_DATE=$(date +"%Y-%m-%d")

   #  rm  -rf /FTP/Sync/${CURRENT_DATE}
   echo "ftp push  git backup Finish!"
else
   echo "ftp push git backup  fail"
fi

