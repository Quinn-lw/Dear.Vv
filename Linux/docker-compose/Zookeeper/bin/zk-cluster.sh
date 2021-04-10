docker run -it --rm \
    --link zoo1:zk1 \
    --link zoo2:zk2 \
    --link zoo3:zk3 \
    --net zk_test_zoo_kafka \
    wurstmeister/zookeeper bin/zkCli.sh -server zk1:2181,zk2:2181,zk3:2181
