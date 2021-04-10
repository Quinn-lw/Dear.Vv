# Kafka Notes

This tutorial assumes you are starting fresh and have no existing Kafka or Zookeeper data.

[TOC]

## Using Apache Kafka Docker

### 1.Preparation

#### 1.1 Check Kernel Version

Here are prerequisites to *install Docker on Debin9*

- Your Ubuntu must be 64-bits OS
- Docker requires kernel version should be 3.10 at minimum

```shel
ricoo@awesome-debian:~/Documents/dockerfile/product$ uname -r
4.9.0-7-amd64
```

#### 1.2 Install Docker

```shell
# 查看系统版本
ricoo@awesome-debian:~/Documents/dockerfile/product$ sudo lsb_release -a
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 9.5 (stretch)
Release:        9.5
Codename:       stretch
# 更新现有的包列表
ricoo@awesome-debian:~/Documents/dockerfile/product$ sudo apt update
Hit:1 https://mirrors.aliyun.com/docker-ce/linux/debian stretch InRelease
Ign:2 https://dl.bintray.com/sbt/debian  InRelease
Ign:3 http://mirrors.163.com/debian stretch InRelease
Get:4 https://dl.bintray.com/sbt/debian  Release [815 B]
Hit:4 https://dl.bintray.com/sbt/debian  Release 
Hit:5 http://mirrors.163.com/debian stretch-updates InRelease
Hit:6 http://mirrors.163.com/debian stretch Release
Reading package lists... Done                                                                                   
Building dependency tree       
Reading state information... Done
206 packages can be upgraded. Run 'apt list --upgradable' to see them.
# 安装一些允许apt使用包通过HTTPS的必备软件包
ricoo@awesome-debian:~/Documents/dockerfile/product$ sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common
Reading package lists... Done
Building dependency tree       
Reading state information... Done
apt-transport-https is already the newest version (1.4.9).
ca-certificates is already the newest version (20161130+nmu1+deb9u1).
curl is already the newest version (7.52.1-5+deb9u9).
gnupg2 is already the newest version (2.1.18-8~deb9u4).
software-properties-common is already the newest version (0.96.20.2-1).
0 upgraded, 0 newly installed, 0 to remove and 206 not upgraded.
# 将官方Docker存储库的GPG密钥添加到您的系统
ricoo@awesome-debian:~/Documents/dockerfile/product$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
OK
# 将Docker存储库添加到APT源
ricoo@awesome-debian:~/Documents/dockerfile/product$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
# 使用新添加的repo中的Docker包更新包列表
ricoo@awesome-debian:~/Documents/dockerfile/product$ sudo apt update
Hit:1 https://mirrors.aliyun.com/docker-ce/linux/debian stretch InRelease
Get:2 https://download.docker.com/linux/debian stretch InRelease [44.8 kB]
Get:3 https://download.docker.com/linux/debian stretch/stable amd64 Packages [9,983 B]
Ign:4 https://dl.bintray.com/sbt/debian  InRelease
Get:5 https://dl.bintray.com/sbt/debian  Release [815 B]
Hit:5 https://dl.bintray.com/sbt/debian  Release
Ign:7 http://mirrors.163.com/debian stretch InRelease                                                           
Hit:8 http://mirrors.163.com/debian stretch-updates InRelease                                                   
Hit:9 http://mirrors.163.com/debian stretch Release                                                             
Fetched 54.8 kB in 11s (4,868 B/s)        
Reading package lists... Done
Building dependency tree       
Reading state information... Done
206 packages can be upgraded. Run 'apt list --upgradable' to see them.
# 确保您要从Docker repo而不是默认的Debian repo安装
ricoo@awesome-debian:~/Documents/dockerfile/product$ apt-cache policy docker-ce
docker-ce:
  Installed: 5:18.09.7~3-0~debian-stretch
  Candidate: 5:19.03.1~3-0~debian-stretch
  Version table:
     5:19.03.1~3-0~debian-stretch 500
        500 https://mirrors.aliyun.com/docker-ce/linux/debian stretch/stable amd64 Packages
        500 https://download.docker.com/linux/debian stretch/stable amd64 Packages
     5:19.03.0~3-0~debian-stretch 500
        500 https://mirrors.aliyun.com/docker-ce/linux/debian stretch/stable amd64 Packages
        500 https://download.docker.com/linux/debian stretch/stable amd64 Packages
     5:18.09.8~3-0~debian-stretch 500
        500 https://mirrors.aliyun.com/docker-ce/linux/debian stretch/stable amd64 Packages
        500 https://download.docker.com/linux/debian stretch/stable amd64 Packages
# 安装Docker
sudo apt install docker-ce
# 检查Docker守护进程是否正在运行
ricoo@awesome-debian:~/Documents/dockerfile/product$ sudo systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2019-08-14 08:13:00 HKT; 1 weeks 4 days ago
     Docs: https://docs.docker.com
 Main PID: 697 (dockerd)
    Tasks: 17
   Memory: 1013.2M
      CPU: 9min 47.671s
   CGroup: /system.slice/docker.service
           ├─  697 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
           └─24984 /usr/bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 2181 -container-ip 172.17.0.2 -container-port 2181

Aug 22 00:02:11 awesome-debian dockerd[697]: time="2019-08-22T00:02:11.868983532+08:00" level=error msg="Not continuing with pull after error: error pulling image configuration: read tcp 192.168.1.99:51818->104.18.121.25:443: read: connection timed out"
Aug 22 00:02:11 awesome-debian dockerd[697]: time="2019-08-22T00:02:11.912753402+08:00" level=info msg="Layer sha256:c318fbba92645a83843c387bd78497e7b143ecc7f5ed99dcb7d38fc62442c02a cleaned up"
```

#### 1.3 Additional Configurations

Avoid using sudo command when use docker commands

```shell
# Create docker group
sudo groupadd docker
# Add our desire user to that group
sudo usermod -aG docker ricoo
# Log out and log in again
# Verify that we don’t need sudo anymore
ricoo@awesome-debian:~$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash
```

#### 1.4 Uninstall Docker

```shell
# Uninstall Docker engine
sudo apt-get purge docker-ce
# Uninstall all related dependent packages
sudo apt-get autoremove --purge docker-ce
# Remove all images, containers, volumes
sudo rm -rf /var/lib/docker
```

### 2.Using Apache Kafka Docker

#### 2.1 Search for Kafka Docker

```shell
ricoo@awesome-debian:~$ docker search kafka
NAME                                     DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
wurstmeister/kafka                       Multi-Broker Apache Kafka Image                 992                                     [OK]
spotify/kafka                            A simple docker image with both Kafka and Zo…   367                                     [OK]
sheepkiller/kafka-manager                kafka-manager                                   165                                     [OK]
ches/kafka                               Apache Kafka. Tagged versions. JMX. Cluster-…   112                                     [OK]
bitnami/kafka                            Apache Kafka is a distributed streaming plat…   69                                      [OK]
hlebalbau/kafka-manager                  Kafka Manager Docker Images Build.              47                                      [OK]
landoop/kafka-topics-ui                  UI for viewing Kafka Topics config and data …   29                                      [OK]
kafkamanager/kafka-manager               Docker image for Kafka manager                  20                                      
landoop/kafka-lenses-dev                 Lenses with Kafka. +Connect +Generators +Con…   16                                      [OK]
```

We can see a list of Kafka Docker are available on the Docker hub. The ones with highest rating stars are on the top. The highest one is **wurstmeister/kafka**  with **175** stars.  However, in this tutorial, we will use the **ches/kafka** Docker which has **37** stars

#### 2.2 Start Apache Kafka Docker

Firstly, we will start **Zookeper Docker**. We will use the Zookeeper Docker:  **jplock/zookeeper**, give the container a name: **zookeeper**, bind the container port **2181** to our host OS port so that we can access that port from the our host OS if needed.

```shell
ricoo@debin-vm:~$ docker run -d --name zookeeper jplock/zookeeper
Unable to find image 'jplock/zookeeper:latest' locally
latest: Pulling from jplock/zookeeper
d0ca440e8637: Pull complete
a3ed95caeb02: Pull complete
05bee9feaa04: Pull complete
1ac73445c6b1: Pull complete
a5d98b9fadfc: Pull complete
Digest: sha256:e416e0a98ccb8e06d2d712f25bdf85627734c9c56f65b4974ef352d6b6ce3894
Status: Downloaded newer image for jplock/zookeeper:latest
71e5e96cc52755185603a12168c5b33fca89880ac9411d0d505b270e39545763
```

The next step, we will start the Kafka Docker, name it: **kafka**, link it to the above Zookeeper container.

```shell
ricoo@debin-vm:~$ docker run -d --name kafka --link zookeeper:zookeeper ches/kafka
Unable to find image 'ches/kafka:latest' locally
latest: Pulling from ches/kafka
 
012a7829fd3f: Downloading [==========================>       ] 34.97 MB/65.79 MB
41158247dd50: Download complete
916b974d99af: Download complete
a3ed95caeb02: Download complete
8ec2accd3368: Downloading [==========>                       ] 37.29 MB/186.2 MB
253fd32218f3: Download complete
d7de66b60976: Downloading [============================>     ] 13.51 MB/23.74 MB
4a31badbf864: Waiting
f0b87da80939: Waiting
d2dc03daf63a: Waiting
99e10bf6620f: Waiting
a1576e01119d: Waiting
c4fffdc533e8: Waiting
a1ff90d481bf: Waiting
```

When the start completed, we may check whether all the containers were started successfully or not

```shell
ricoo@debin-vm:~$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                          NAMES
9b25c096dabb        ches/kafka          "/start.sh"              About a minute ago   Up About a minute   7203/tcp, 9092/tcp             kafka
717cfa653ced        jplock/zookeeper    "/opt/zookeeper/bin/z"   About a minute ago   Up About a minute   2181/tcp, 2888/tcp, 3888/tcp   zookeeper

```

#### 2.3 Working with Kafka Docker

Getting the IP addresses and ports of Zookeeper and Kafka Dockers.

```shell
ZK_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' zookeeper)
KAFKA_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' kafka)
echo $ZK_IP, $KAFKA_IP
172.17.0.2, 172.17.0.3
```

Create a topic

```shell
docker run --rm ches/kafka \
> kafka-topics.sh --create --topic test --replication-factor 1 --partitions 1 --zookeeper $ZK_IP:2181
```

Produce messages

```shell
docker run --rm --interactive ches/kafka \ 
> kafka-console-producer.sh --topic test --broker-list $KAFKA_IP:9092
```

Consume messages

```shell
ZK_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' zookeeper)
KAFKA_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' kafka)
docker run --rm ches/kafka kafka-console-consumer.sh \ 
> --topic test --from-beginning --zookeeper $ZK_IP:2181
```




## Kafka Quicksart
### Step 1: Download the code

[Download](http://mirror.bit.edu.cn/apache/kafka/2.1.0/kafka_2.11-2.1.0.tgz) the 2.1.0 release and un-tar it.

```bash
> tar -xzvf kafka_2.11-2.1.0.tgz
> cd kafka_2.11-2.1.0
```

### Step 2: Start the server

Kafka uses [ZooKeeper](https://zookeeper.apache.org/) so you need to first start a ZooKeeper server if you don't already have one. You can use the convenience script with kafka to get a quick-and-dirty single-node ZooKeeper instance.

```bash
> bin/zookeeper-server-start.sh config/zookeeper.properties
[2013-04-22 15:01:37,495] INFO Reading configuration from: config/zookeeper.properties (org.apache.zookeeper.server.quorum.QuorumPeerConfig)
...
```

Now start the Kafka server:

```bash
> bin/kafka-server-start.sh config/server.properties
[2013-04-22 15:01:47,028] INFO Verifying properties (kafka.utils.VerifiableProperties)
[2013-04-22 15:01:47,051] INFO Property socket.send.buffer.bytes is overridden to 1048576 (kafka.utils.VerifiableProperties)
...
```

### Step 3: Create a topic

Let's create a topic named "test" with a single partition and only one replica:

```bash
> bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
```

We can now see that topic if we run the list topic command:

```bash
> bin/kafka-topics.sh --list --zookeeper localhost:2181
test
```

Alternatively, instead of manually creating topics you can also configure your brokers to ==auto-create topics when a non-existent topic is published to.==

### Step 4: Send some messages

Kafka comes with a command line client that will take input from a file or from standard input and send it out as messages to the Kafka cluster. By default, each line will be sent as a separate message.

Run the producer and then type a few messages into the console to send to the server.

```bash
> bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
This is a message
This is another message
```

### Step 5: Start a consumer

Kafka also has a command line consumer that will dump out messages to standard output.

```bash
> bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
This is a message
This is another message
```

If you have each of the above commands running in a different terminal then you should now be able to type messages into the producer terminal and see them appear in the consumer terminal.

All of the command line tools have additional options; ==running the command with no arguments will display usage information documenting them in more detail==.

### Step 6: Setting up a multi-broker cluster

So far we have been running against a single broker, but that's no fun. For Kafka, a single broker is just a cluster of size one, so nothing much changes other than starting a few more broker instances. But just to get feel for it, let's expand our cluster to three nodes (still all on our local machine).

First we make a config file for each of the brokers (on Windows use the `copy` command instead):

```bash
> cp config/server.properties config/server-1.properties
> cp config/server.properties config/server-2.properties
```

Now edit these new files and set the following properties:

```basic
config/server-1.properties:
    broker.id=1
    listeners=PLAINTEXT://:9093
    log.dirs=/tmp/kafka-logs-1
 
config/server-2.properties:
    broker.id=2
    listeners=PLAINTEXT://:9094
    log.dirs=/tmp/kafka-logs-2
```

The `broker.id` property is ==the unique and permanent name of each node== in the cluster. We have to override the port and log directory only because we are running these all on the same machine and we want to keep the brokers from all trying to register on the same port or overwrite each other's data.

We already have Zookeeper and our single node started, so we just need to start the two new nodes:

```bash
> bin/kafka-server-start.sh config/server-1.properties &
...
> bin/kafka-server-start.sh config/server-2.properties &
...
```

Now create a new topic with a replication factor of three:

```bash
> bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic test-replicated
```

Okay but now that we have a cluster how can we know which broker is doing what? To see that run the "describe topics" command:

```bash
> bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test-replicated
Topic:test-replicated   PartitionCount:1    ReplicationFactor:3 Configs:
    Topic: test-replicated  Partition: 0    Leader: 1   Replicas: 1,2,0 Isr: 1,2,0
```

Here is an explanation of output. The first line gives a summary of all the partitions, each additional line gives information about one partition. Since we have only one partition for this topic there is only one line.

- "leader" is the node responsible for all reads and writes for the given partition. Each node will be the leader for a randomly selected portion of the partitions.
- "replicas" is the list of nodes that replicate the log for this partition regardless of whether they are the leader or ==even if they are currently alive==.
- "isr" is the set of "in-sync" replicas. This is the subset of the replicas list that is ==currently alive and caught-up to the leader==.

Note that in my example node 1 is the leader for the only partition of the topic.

We can run the same command on the original topic we created to see where it is:

```bash
> bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test
Topic:test  PartitionCount:1    ReplicationFactor:1 Configs:
    Topic: test Partition: 0    Leader: 0   Replicas: 0 Isr: 0
```

So there is no surprise there—the original topic has no replicas and is on server 0, the only server in our cluster when we created it.

Let's publish a few messages to our new topic:

```bash
> bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test-replicated
...
my test message 1
my test message 2
^C
```

Now let's consume these messages:

```bash
> bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic test-replicated
...
my test message 1
my test message 2
^C
```

Now let's test out fault-tolerance. Broker 1 was acting as the leader so let's kill it:

```bash
> ps aux | grep server-1.properties
7564 ttys002    0:15.91 /System/Library/Frameworks/JavaVM.framework/Versions/1.8/Home/bin/java...
> kill -9 7564
```

Leadership has switched to one of the slaves and node 1 is no longer in the in-sync replica set:

```bash
> bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test-replicated
Topic:test-replicated   PartitionCount:1    ReplicationFactor:3 Configs:
    Topic: test-replicated  Partition: 0    Leader: 2   Replicas: 1,2,0 Isr: 2,0
```

But the messages are still available for consumption even though the leader that took the writes originally is down:

```bash
> bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic test-replicated
...
my test message 1
my test message 2
^C
```

### Step 7: Use Kafka Connect to import/export data

Writing data from the console and writing it back to the console is a convenient place to start, but you'll probably want to use data from other sources or export data from Kafka to other systems. For many systems, instead of writing custom integration code you can use Kafka Connect to import or export data.

Kafka Connect is a tool included with Kafka that imports and exports data to Kafka. It is an extensible tool that runs *connectors*, which implement the custom logic for interacting with an external system. In this quickstart we'll see how to run Kafka Connect with simple connectors that import data from a file to a Kafka topic and export data from a Kafka topic to a file.

First, we'll start by creating some seed data to test with:

```bash
> echo -e "foo\nbar" > test.txt
```

Next, we'll start two connectors running in *standalone* mode, which means they ==run in a single, local, dedicated process==. We provide three configuration files as parameters. The first is always the configuration for the Kafka Connect process, containing common configuration such as the Kafka brokers to connect to and the serialization format for data. The remaining configuration files each specify a connector to create. These files include a unique connector name, the connector class to instantiate, and any other configuration required by the connector.

```bash
> bin/connect-standalone.sh config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties
```

These sample configuration files, included with Kafka, use the default local cluster configuration you started earlier and create two connectors: the first is a source connector that reads lines from an input file and produces each to a Kafka topic and the second is a sink connector that reads messages from a Kafka topic and produces each as a line in an output file.

During startup you'll see a number of log messages, including some indicating that the connectors are being instantiated. Once the Kafka Connect process has started, the source connector should start reading lines from `test.txt` and producing them to the topic `connect-test`, and the sink connector should start reading messages from the topic `connect-test` and write them to the file `test.sink.txt`. We can verify the data has been delivered through the entire pipeline by examining the contents of the output file:

```bash
> more test.sink.txt
foo
bar
```

Note that the data is being stored in the Kafka topic `connect-test`, so we can also run a console consumer to see the data in the topic (or use custom consumer code to process it):

```bash
> bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic connect-test --from-beginning
{"schema":{"type":"string","optional":false},"payload":"foo"}
{"schema":{"type":"string","optional":false},"payload":"bar"}
...
```

The connectors continue to process data, so we can add data to the file and see it move through the pipeline:

```bash
> echo Another line>> test.txt
```

You should see the line appear in the console consumer output and in the sink file.

### Step 8: Use Kafka Streams to process data

Kafka Streams is a client library for building mission-critical real-time applications and microservices, where the input and/or output data is stored in Kafka clusters. Kafka Streams combines the simplicity of writing and deploying standard Java and Scala applications on the client side with the benefits of Kafka's server-side cluster technology to make these applications highly scalable, elastic, fault-tolerant, distributed, and much more. This [quickstart example](http://kafka.apache.org/21/documentation/streams/quickstart) will demonstrate how to run a streaming application coded in this library.















































