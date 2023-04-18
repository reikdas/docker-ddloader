#!/bin/bash

sbt "runMain $1 --loadFile=/1G.txt --writeFile=ddloader.c --mmap --print"
mpicc -O3 ddloader.c -o ddloader -I /LMS-HDFS/src/main/resources/headers/ -I /LMS-HDFS/lms-clean/src/main/resources/headers/
mpirun -np 1 -hosts datanode1 ./ddloader 0