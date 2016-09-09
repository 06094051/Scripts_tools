#!/bin/sh
GIT_REPO=/root/Workspace
SCRIPT_FILE='/root/Scripts/repo_name'

for line in `cat ${SCRIPT_FILE} `
do
    IFS=","
    arr=($line)

	##GITLab
	GIT=${arr[0]}".git"
	GITLAB_GROUP="open-source"
	GITLAB_GIT="git@service14.h3c.com:${GITLAB_GROUP}/${GIT}"
 
	#GITHub
	GITHUB_ORG=${arr[1]}
	GITHUB_GIT="https://github.com/${GITHUB_ORG}/${GIT}"
 
	echo "/-------------------------------------------------"
	echo "gitlab:${GITLAB_GIT}"
	echo "github:${GITHUB_GIT}"
	echo "begin_time:"`date`
	#Temp Dir
	GIT_DIR=${GIT_REPO}/${GIT}
 
	cd ${GIT_REPO}
	if [ ! -d "$GIT_DIR" ]; then 
		#if file not exits ,clone
		echo ${GIT_DIR}" is not exist."
		echo `git clone --mirror ${GITHUB_GIT}`
		echo "clone result:"$?
		cd ${GIT_DIR}
	else
		cd ${GIT_DIR}
		echo `git fetch`
	fi
	echo "gitlab-address:"${GITLAB_GIT}
	git remote rm h3c
	git remote add h3c  ${GITLAB_GIT}
	git push h3c --all
	git push h3c --tags
	echo "end_time:"`date`
	echo "\-------------------------------------------------"

done

#backup gitlab
gitlab-rake gitlab:backup:create

GIT_BACK_DIR=/var/opt/gitlab/backups

if [ $? -eq 0 ]
then
   #Dest Dir
   CURRENT_DATE=$(date +"%Y-%m-%d")
   echo "backup time : ${CURRENT_DATE}"
   
   cd /FTP/Sync/

   # delete old 
   rm -rf * 

   if [ ! -d "$CURRENT_DATE" ]; then
    mkdir -p  /FTP/Sync/${CURRENT_DATE}
   fi

   mv ${GIT_BACK_DIR}/*  /FTP/Sync/${CURRENT_DATE}/

   cd -
   echo "git backup Finish!"
else
   echo "git backup  fail"
fi

echo "all over!"

