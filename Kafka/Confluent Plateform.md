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
```

## 部署后的信息

