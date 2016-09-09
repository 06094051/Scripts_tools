for line in `cat '/root/Scripts/repo_name'`
do
	IFS=","
	arr=($line)
	for str in ${arr[@]}
	do
		echo 'ii:'$str
	done
	echo 'jj:'${arr[1]}
done
