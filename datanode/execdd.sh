#!/bin/bash

sbt "runMain $1 --loadFile=/1G.txt --writeFile=ddloader.c --mmap --print"
mpicc -O3 ddloader.c -o ddloader -I /LMS-HDFS/src/main/resources/headers/ -I /LMS-HDFS/lms-clean/src/main/resources/headers/
scp ddloader datanode2:/LMS-HDFS/
scp ddloader datanode3:/LMS-HDFS/
mpirun -np 3 -hosts datanode1,datanode2,datanode3 ./ddloader 0