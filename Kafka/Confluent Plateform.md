# Confluent Plateform

## 安装部署

```
# 下载
wget http://packages.confluent.io/archive/5.1/confluent-5.1.0-2.11.tar.gz
tar -xzvf confluent-5.1.0-2.11.tar.gz
cp -R confluent-5.1.0 /opt/

# 添加驱动
cp debezium-connector-mysql/*jar /opt/confluent-5.1.0/share/java/kafka/
cp debezium-connector-mongodb/*jar /opt/confluent-5.1.0/share/java/kafka/
或者
confluent-hub install debezium/debezium-connector-mysql:0.8.3

# 添加环境变量
vi ~/.bashrc
export PATH=${PATH}:/opt/confluent-5.1.0/bin
source ~/.bashrc

# 启动
confluent start

# 添加debezium主题
[root@test-op77 etc]# mkdir /opt/confluent-5.1.0/etc/kafka-connect-debezium
[root@test-op77 etc]# cd /opt/confluent-5.1.0/etc/kafka-connect-debezium/
[root@test-op77 kafka-connect-debezium]# vi debezium_mysql_test77.json
{
  "name": "test-connector",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "database.hostname": "10.104.6.77",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "dbzm@4PX",
    "database.server.id": "12354",
    "database.server.name": "test77",
    "database.whitelist": "test",
    "database.history.kafka.bootstrap.servers": "10.104.6.77:9092",
    "database.history.kafka.topic": "dbhistory.test77"
    "include.schema.changes": "true"
  }
}
[root@test-op77 kafka-connect-debezium]# curl -X POST -H "Content-Type: application/json" --data @debezium_mysql_test77.json  http://localhost:8083/connectors
{"name":"test-connector","config":{"connector.class":"io.debezium.connector.mysql.MySqlConnector","database.hostname":"10.104.6.77","database.port":"3306","database.user":"debezium","database.password":"dbzm@4PX","database.server.id":"12354","database.server.name":"test77","database.whitelist":"test","database.history.kafka.bootstrap.servers":"10.104.6.77:9092","database.history.kafka.topic":"dbhistory.test77","include.schema.changes":"true","name":"test-connector"},"tasks":[],"type":null}

```

## 部署后的信息

| 功能                              | 端口 |
| --------------------------------- | ---- |
| Confluent Control Center          | 9021 |
| Zookeeper                         | 2181 |
| Apache Kafka brokers (plain text) | 9092 |
| Schema Registry REST API          | 8081 |
| REST Proxy                        | 8082 |
| Kafka Connect REST API            | 8083 |

