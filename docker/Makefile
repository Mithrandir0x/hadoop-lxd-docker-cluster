all: build publish remove-local-images

build: build-hadoop-base build-hdfs-namenode build-hdfs-datanode build-yarn-resourcemanager build-yarn-nodemanager build-mapred-jobhistory build-zeppelin
publish: publish-hadoop-base publish-hdfs-namenode publish-hdfs-datanode publish-yarn-resourcemanager publish-yarn-nodemanager publish-mapred-jobhistory publish-zeppelin
remove-local-images: remove-local-image-hadoop-base remove-local-image-hdfs-namenode remove-local-image-hdfs-datanode remove-local-image-yarn-resourcemanager remove-local-image-yarn-nodemanager remove-local-image-mapred-jobhistory remove-local-image-zeppelin

build-hadoop-base:
	docker build -t hadoop-base:2.8.1 hadoop-base

publish-hadoop-base:
	docker tag hadoop-base:2.8.1 edge-local-vm:443/local.vm/hadoop-base:2.8.1
	docker push edge-local-vm:443/local.vm/hadoop-base:2.8.1

remove-local-image-hadoop-base:
	docker image rm hadoop-base:2.8.1

build-hdfs-namenode:
	docker build -t hdfs-namenode:2.8.1 hdfs-namenode

publish-hdfs-namenode:
	docker tag hdfs-namenode:2.8.1 edge-local-vm:443/local.vm/hdfs-namenode:2.8.1
	docker push edge-local-vm:443/local.vm/hdfs-namenode:2.8.1

remove-local-image-hdfs-namenode:
	docker image rm hdfs-namenode:2.8.1

build-hdfs-datanode:
	docker build -t hdfs-datanode:2.8.1 hdfs-datanode

publish-hdfs-datanode:
	docker tag hdfs-datanode:2.8.1 edge-local-vm:443/local.vm/hdfs-datanode:2.8.1
	docker push edge-local-vm:443/local.vm/hdfs-datanode:2.8.1

remove-local-image-hdfs-datanode:
	docker image rm hdfs-datanode:2.8.1

build-yarn-resourcemanager:
	docker build -t yarn-resourcemanager:2.8.1 yarn-resourcemanager

publish-yarn-resourcemanager:
	docker tag yarn-resourcemanager:2.8.1 edge-local-vm:443/local.vm/yarn-resourcemanager:2.8.1
	docker push edge-local-vm:443/local.vm/yarn-resourcemanager:2.8.1

remove-local-image-yarn-resourcemanager:
	docker image rm yarn-resourcemanager:2.8.1

build-yarn-nodemanager:
	docker build -t yarn-nodemanager:2.8.1 yarn-nodemanager

publish-yarn-nodemanager:
	docker tag yarn-nodemanager:2.8.1 edge-local-vm:443/local.vm/yarn-nodemanager:2.8.1
	docker push edge-local-vm:443/local.vm/yarn-nodemanager:2.8.1

remove-local-image-yarn-nodemanager:
	docker image rm yarn-nodemanager:2.8.1

build-mapred-jobhistory:
	docker build -t mapred-jobhistory:2.8.1 mapred-jobhistory

publish-mapred-jobhistory:
	docker tag mapred-jobhistory:2.8.1 edge-local-vm:443/local.vm/mapred-jobhistory:2.8.1
	docker push edge-local-vm:443/local.vm/mapred-jobhistory:2.8.1

remove-local-image-mapred-jobhistory:
	docker image rm mapred-jobhistory:2.8.1

build-zeppelin:
	docker build -t zeppelin:2.8.1 zeppelin

publish-zeppelin:
	docker tag zeppelin:2.8.1 edge-local-vm:443/local.vm/zeppelin:2.8.1
	docker push edge-local-vm:443/local.vm/zeppelin:2.8.1

remove-local-image-zeppelin:
	docker image rm zeppelin:2.8.1

verify-docker-compose:
	docker-compose config
