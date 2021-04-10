# 启动
COMPOSE_PROJECT_NAME=zk_test docker-compose up -d

# 查看
COMPOSE_PROJECT_NAME=zk_test docker-compose ps

#关闭
COMPOSE_PROJECT_NAME=zk_test docker-compose down

# 查看zk集群是否搭建成功
echo stat | nc 127.0.0.1 2181
echo stat | nc 127.0.0.1 2182
echo stat | nc 127.0.0.1 2183
