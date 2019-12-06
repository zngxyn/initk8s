
# 2017 10 09 优化docker 运行产生的日志
path=/var/lib/docker/containers/

cd $path
for file in $(ls)
do
    #[ -d $file ] && echo $file 
    if [ -d $file ];then
        echo $file
        cat /dev/null > $file/$file-json.log
	else
        echo 0  
    fi
done