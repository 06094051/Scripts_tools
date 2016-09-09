#!/bin/sh
#########################################################################
# File Name: yum-sync.sh
# Author: zhaoyingchao
# Email: 
# Version:
# Created Time:  2015 11-25 11:20:53 AM CST
#########################################################################

if ! which rsync >/dev/null 2>&1;then exit 1;fi

DEST_DIR=/home/sync-yum
YUM_SYNC_DIR=/FTP/Sync/sync-yum


rsyncUrl=( 
	 rsync://rsync.mirrors.ustc.edu.cn/centos/7/cloud/x86_64/openstack-liberty/
         rsync://rsync.mirrors.ustc.edu.cn/centos/7/cloud/x86_64/openstack-mitaka/
)

localDir=(
	 openstack-liberty
         openstack-mitaka
)

rsync_Mirrors() {
    rsync -vai4CH  --safe-links  --numeric-ids --delete --delete-delay --delay-updates $1 $2
}

CURRENT_DATE=$(date +"%Y-%m-%d")

cd $DEST_DIR

for i in `seq 0 ${#localDir[@]}`;do
    if [ -z ${localDir[$i]} ]; then
    continue   
    fi
    [ ! -d ${localDir[$i]} ] && mkdir -p ${localDir[$i]}
    echo " ${rsyncUrl[$i]} ===>  ${localDir[$i]}"
    rsync_Mirrors ${rsyncUrl[$i]} ${localDir[$i]}
    
    #打包
    tar -cvzf ${localDir[$i]}-${CURRENT_DATE}.tar.gz  ${localDir[$i]}/*
   
	
    #["$i"="0"]&& cp -a `dirname ${localDir[7]}` /fancyindex${localDir[0]}
    #["$i"="1"]&& mv ${localDir[1]}/index.html ${localDir[1]}/index.html_backup
    #["$i"="3"]&& mv ${localDir[3]}/index.html ${localDir[3]}/index.html_backup
    #["$i"="6"]&& cp -a `dirname${localDir[7]}`/fancyindex ${localDir[6]}/&&mv${localDir[6]}/index.html${localDir[6]}/index.html_backup
done

    #拷贝至同步目录
    mkdir -p $YUM_SYNC_DIR
    mv *.tar.gz ${YUM_SYNC_DIR}/

cd -
