# Hive数据同步方案

## Oracle2Hive

### 事实表

#### 多列数据

> Parquet适用场景：有很多列，但常用的就几列

##### 语法

```sql
-- Hive创建Parquet文件格式并压缩
create table mytable(a int,b int) 
STORED AS PARQUET TBLPROPERTIES('parquet.compression'='SNAPPY');

-- 如果创建的时候没有指定压缩，后期修改表属性添加压缩
ALTER TABLE mytable SET TBLPROPERTIES ('parquet.compression'='SNAPPY');

或者在写入的时候set parquet.compression=SNAPPY;
不过只会影响后续入库的数据，原来的数据不会被压缩，需要重跑原来的数据。
```



#### 频繁查询

### 维度表

