DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
ifdef RELEASE
RELEASE := $(RELEASE)
else
RELEASE := ubnutu-18.04
endif

build:
	docker build -t pash-base:$(RELEASE) ./pash-base
	docker build -t hadoop-pash-base:$(RELEASE) ./base

# docker build -t hadoop-namenode:$(RELEASE) ./namenode
# docker build -t hadoop-datanode:$(RELEASE) ./datanode
# docker build -t hadoop-resourcemanager:$(RELEASE) ./resourcemanager
# docker build -t hadoop-nodemanager:$(RELEASE) ./nodemanager
# docker build -t hadoop-historyserver:$(RELEASE) ./historyserver
# docker build -t hadoop-submit:$(RELEASE) ./submit

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base:$(RELEASE) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base:$(RELEASE) hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.2/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base:$(RELEASE) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base:$(RELEASE) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base:$(RELEASE) hdfs dfs -rm -r /input
