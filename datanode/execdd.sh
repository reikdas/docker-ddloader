#!/bin/bash

sbt "runMain $1 --loadFile=$2 --writeFile=ddloader.c --mmap --print --multiproc"
mpicc -O3 ddloader.c -o ddloader -I /LMS-HDFS/src/main/resources/headers/ -I /LMS-HDFS/lms-clean/src/main/resources/headers/
scp ddloader datanode2:/LMS-HDFS/
scp ddloader datanode3:/LMS-HDFS/
if [[ "$3" == 1 ]]; then
	mpirun -np 1 -hosts datanode2 ./ddloader 0
elif [[ "$3" == 2 ]]; then
	mpirun -np 2 -hosts datanode2,datanode3 ./ddloader 0
elif [[ "$3" == 3 ]]; then
	mpirun -np 3 -hosts datanode1,datanode2,datanode3 ./ddloader 0
fi