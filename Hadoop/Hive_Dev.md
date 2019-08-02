# Hive

## FUNC

### Built-in Date Func

### UDF

本文中UDF函数采用Maven的方式

pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.fpx.hiveudf</groupId>
    <artifactId>datefunc</artifactId>
    <version>1.0-SNAPSHOT</version>

    <!-- 设置版本参数 -->
    <properties>
        <hadoop.version>3.0.0-cdh6.1.1</hadoop.version>
        <hive.version>2.1.1-cdh6.1.1</hive.version>
    </properties>

    <!-- 由于使用CDH的hadoop和hive，需要添加CDH的官方repository -->
    <!-- 如果是Apache版本的hadoop和hive，则不需要添加该repository -->
    <repositories>
        <repository>
            <id>cloudera</id>
            <url>https://repository.cloudera.com/artifactory/cloudera-repos/</url>
        </repository>
    </repositories>

    <!-- 添加依赖 -->
    <dependencies>
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-common</artifactId>
            <version>${hadoop.version}</version>
        </dependency>
        <dependency>
            <groupId>org.apache.hive</groupId>
            <artifactId>hive-exec</artifactId>
            <version>${hive.version}}</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
```

使用Maven自动下载依赖

## DDL
### CREATE TABLE
#### LOAD DATA FROM CSV
```sql
DROP TABLE temp.t_ic_jindie;
CREATE TABLE `temp.t_ic_jindie`(
  `ic_no` string, 
  `ic_date` string, 
  `price_1` string, 
  `sub_price` string, 
  `price_2` string, 
  `cm_code` string, 
  `cm_name` string, 
  `pk_code` string, 
  `pk_name` string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    "separatorChar" = ",",
    "quoteChar"     = "'",
    "escapeChar"    = "\\"
)
STORED AS TEXTFILE;

load data local inpath '/root/20190801_data.csv' into table temp.t_ic_jindie;
```