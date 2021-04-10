# 启动
COMPOSE_PROJECT_NAME=kafka_test docker-compose up -d

# 查看进程
COMPOSE_PROJECT_NAME=kafka_test docker-compose ps

# 关闭
COMPOSE_PROJECT_NAME=kafka_test docker-compose down

# 查看控制台
http://172.23.0.10:9000/
# 添加集群，配置zk，查看brokers是否正常
