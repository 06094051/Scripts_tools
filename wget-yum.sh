#!/bin/sh
#########################################################################
# File Name: wget-yum.sh
# Author: zhaoyingchao
# Email:
# Version:
# Created Time:  2015 11-25 11:20:53 AM CST
#########################################################################

if ! which wget >/dev/null 2>&1;then exit 1;fi

DEST_DIR=/home/sync-yum
YUM_SYNC_DIR=/FTP/Sync/sync-yum


remoteUrl=(
         https://repos.fedorapeople.org/repos/openstack/
         http://archive-primary.cloudera.com/cdh5/redhat/6/x86_64/cdh/5.7.0/
	 http://archive-primary.cloudera.com/cm5/redhat/6/x86_64/cm/5.7.0/
)

localDir=(
	  openstack
          cdh5.7.0
	  cm5.7.0
)

wget_Mirrors() {
wget -np -nH –cut-dirs=1 -r -c -L –exclude-directories=repodata –accept=rpm,zip,gz,xml $1 -P $2
}


CURRENT_DATE=$(date +"%Y-%m-%d")
cd $DEST_DIR


for i in `seq 0 ${#localDir[@]}`;do
    if [ -z ${localDir[$i]} ]; then
    continue
    fi
    [ ! -d ${localDir[$i]} ] && mkdir -p ${localDir[$i]}
    echo " ${remoteUrl[$i]} ===>  ${localDir[$i]}"
    wget_Mirrors ${remoteUrl[$i]} ${localDir[$i]i}

    #打包
    cd ${localDir[$i]}
    tar -cvzf ${localDir[$i]}-${CURRENT_DATE}.tar.gz  ./*
     #拷贝至同步目录
     mkdir -p $YUM_SYNC_DIR
    mv *.tar.gz ${YUM_SYNC_DIR}/
    cd -

done

