# Hadoop Docker

## Generic docker setup

* Install docker
* Install docker-compose
* Enable docker daemon

## Setup cluster

```
./setup-compose.sh
```

## Enter node

```
docker exec -it <node> /bin/bash
```

In terms of the project, you should launch the `datanode1` node like this:
```
docker exec -it datanode1 /bin/bash
```

## Moving file to HDFS

Make sure you have 1G.txt in base/. It doesn't come with the GitHub repository.

The first time you enter a node, you probably want to move the `/1G.txt` file to HDFS by executing - 
```
hdfs dfs -moveFromLocal /1G.txt /1G.txt
```

## Executing DDLoader distributed programs

Inside the `datanode1` container, irst enter the DDLoader directory by -
```
cd LMS-HDFS
```

And then execute the `execdd.sh` script. The syntax is - `./execdd.sh <op> /1G.txt <num_nodes>`. `op` is one of `WordCount`, `Whitespace` and `CharFreq`. `num_nodes` is either 1, 2 or 3. 

For eg. to run Character frequency count on all 3 nodes, we would do-
```
./execdd.sh CharFreq /1G.txt 3
```

The way the script is set up right now, only supports executing the script from `datanode1`. Feel free to look at the script and compile/copy over the executable to different nodes, to try out different combinations.

## Remove every docker container, image and volume on your system
```
./clean.sh
```
