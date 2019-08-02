# Hive整理

## 参数设置

### hive.cli

```shell
# 打印输出列头
set hive.cli.print.header=true;

# key、value格式打印，每行显示一个
set hive.cli.print.row.to.vertical=true;
set hive.cli.print.row.to.vertical.num=1;

# 
```

### 动态分区

```shell
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nostrick;

hive.exec.max.dynamic.partitions.pernode （缺省值100）：每一个mapreduce job允许创建的分区的最大数量，如果超过了这个数量就会报错
hive.exec.max.dynamic.partitions （缺省值1000）：一个dml语句允许创建的所有分区的最大数量
hive.exec.max.created.files （缺省值100000）：所有的mapreduce job允许创建的文件的最大数量
```

### 合并小文件

```shell
set hive.merge.mapredfiles=true;
set hive.merge.smallfiles.avgsize=100000000;
```

### 本地模式

满足以下条件的小任务：

- job的输入数据大小必须小于参数：hive.exec.mode.local.auto.inputbytes.max(默认128MB)
- job的map数必须小于参数：hive.exec.mode.local.auto.tasks.max(默认4)
- job的reduce数必须为0或者1

```shell
set hive.exec.mode.local.auto.inputbytes.max=134217728;
set hive.exec.mode.local.auto.tasks.max=4;
set hive.exec.mode.local.auto=true;
set hive.mapred.local.mem=本地模式启动的JVM内存大小
```

### 并发执行

```shell
set hive.exec.parallel=true;
set hive.exec.parallel.thread.number=8;
```

### Strict Mode

```sql
set hive.mapred.mode=true;
```

严格模式不允许执行以下查询:

- 分区表上没有指定了分区
- 没有limit限制的order by语句
- 笛卡尔积：JOIN时没有ON语句





## 常用操作

### 导出数据

```shell
Standard syntax:
INSERT OVERWRITE [LOCAL] DIRECTORY directory1
  [ROW FORMAT row_format] [STORED AS file_format] (Note: Only available starting with Hive 0.11.0)
  SELECT ... FROM ...

Hive extension (multiple inserts):
FROM from_statement
INSERT OVERWRITE [LOCAL] DIRECTORY directory1 select_statement1
[INSERT OVERWRITE [LOCAL] DIRECTORY directory2 select_statement2] ...


row_format
  : DELIMITED [FIELDS TERMINATED BY char [ESCAPED BY char]] [COLLECTION ITEMS TERMINATED BY char]
        [MAP KEYS TERMINATED BY char] [LINES TERMINATED BY char]
        [NULL DEFINED AS char] (Note: Only available starting with Hive 0.13)
```

### Multi-Group-By Inserts

```sql
FROM test
INSERT OVERWRITE TABLE count1
SELECT count(DISTINCT test.dqcode)
GROUP BY test.zipcode
INSERT OVERWRITE TABLE count2
SELECT count(DISTINCT test.dqcode)
GROUP BY test.sfcode;
```

### map/reduce数目

减少map数目：
　　set mapred.max.split.size
　　set mapred.min.split.size
　　set mapred.min.split.size.per.node
　　set mapred.min.split.size.per.rack
　　set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat
增加map数目：
当input的文件都很大，任务逻辑复杂，map执行非常慢的时候，可以考虑增加Map数，来使得每个map处理的数据量减少，从而提高任务的执行效率。
假设有这样一个任务：
　　select data_desc, count(1), count(distinct id),sum(case when …),sum(case when ...),sum(…) from a group by data_desc
如果表a只有一个文件，大小为120M，但包含几千万的记录，如果用1个map去完成这个任务，肯定是比较耗时的，这种情况下，我们要考虑将这一个文件合理的拆分成多个，这样就可以用多个map任务去完成。
　　set mapred.reduce.tasks=10;
　　create table a_1 as select * from a distribute by rand(123);
这样会将a表的记录，随机的分散到包含10个文件的a_1表中，再用a_1代替上面sql中的a表，则会用10个map任务去完成。每个map任务处理大于12M（几百万记录）的数据，效率肯定会好很多。

reduce数目设置：
　参数1：hive.exec.reducers.bytes.per.reducer=1G：每个reduce任务处理的数据量
　参数2：hive.exec.reducers.max=999(0.95*TaskTracker数)：每个任务最大的reduce数目
　reducer数=min(参数2,总输入数据量/参数1)
　set mapred.reduce.tasks：每个任务默认的reduce数目。典型为0.99*reduce槽数，hive将其设置为-1，自动确定reduce数目。

## 用户管理

### 添加用户

## 权限管理

### 配置

> **hive-site.xml**

```xml
<property> 
<name>hive.security.authorization.enabled</name> 
<value>true</value> 
 <description>enable or disable the hive client authorization</description> 
 </property> 
<property> 
 <name>hive.security.authorization.createtable.owner.grants</name> 
 <value>ALL</value> 
 <description>the privileges automatically granted to the owner whenever a table gets created. An example like "select,drop" will grant select and drop privilege to the owner of the table</description>
</property>
<property> 
    <name>hive.semantic.analyzer.hook</name> 
    <value>com.hive.AuthHook</value>  
</property>
```

含义

- 分别是开启权限验证
- 表的创建者对表拥有所有权限
- 只有admin用户可以进行Grant/Revoke操作

```java
package com.hive;
import org.apache.hadoop.hive.ql.parse.ASTNode;
import org.apache.hadoop.hive.ql.parse.AbstractSemanticAnalyzerHook;
import org.apache.hadoop.hive.ql.parse.HiveParser;
import org.apache.hadoop.hive.ql.parse.HiveSemanticAnalyzerHookContext;
import org.apache.hadoop.hive.ql.parse.SemanticException;
import org.apache.hadoop.hive.ql.session.SessionState;

public class  HiveAdmin extendsAbstractSemanticAnalyzerHook {
	private static String admin = "admin";
   	@Override
	public ASTNodepreAnalyze(HiveSemanticAnalyzerHookContext context,
ASTNode ast) throws SemanticException {
		switch(ast.getToken().getType()) {
			case HiveParser.TOK_CREATEDATABASE:
			case HiveParser.TOK_DROPDATABASE:
			case HiveParser.TOK_CREATEROLE:
			case HiveParser.TOK_DROPROLE:
			case HiveParser.TOK_GRANT:
			case HiveParser.TOK_REVOKE:
			case HiveParser.TOK_GRANT_ROLE:
			case HiveParser.TOK_REVOKE_ROLE:
             	StringuserName = null;
				if(SessionState.get() != null && SessionState.get().getAuthenticator()!= null){
					userName = SessionState.get().getAuthenticator().getUserName();
            	}
				if(!admin.equalsIgnoreCase(userName)) {
					throw new SemanticException(userName + " can't use ADMIN options,except " + admin +".");
            	}
				break;
			default:
				break;
        }
		return ast;
    }
}
```

还可以通过上面钩子添加用户访问控制，好比根据用户限制可以访问的路径之类的

### 命令

```sql
-- 创建删除
CREATE ROLE ROLE_NAME
DROP ROLE ROLE_NAME
-- 赋权回收
GRANT ROLE role_name [, role_name] ... TO principal_specification [, principal_specification] ... 
REVOKE ROLE role_name [, role_name] ... FROM principal_specification [, principal_specification] ...
-- 查看
SHOW ROLE GRANT principal_specification 
```

principal_specification   : USER user   | GROUP group   | ROLE role 



HIVE支持以下权限：

| 权限名称      | 含义                                                         |
| ------------- | ------------------------------------------------------------ |
| ALL           | 所有权限                                                     |
| ALTER         | 允许修改元数据（modify metadata data of object）---表信息数据 |
| UPDATE        | 允许修改物理数据（modify physical data of object）---实际数据 |
| CREATE        | 允许进行Create操作                                           |
| DROP          | 允许进行DROP操作                                             |
| INDEX         | 允许建索引（目前还没有实现）                                 |
| LOCK          | 当出现并发的使用允许用户进行LOCK和UNLOCK操作                 |
| SELECT        | 允许用户进行SELECT操作                                       |
| SHOW_DATABASE | 允许用户查看可用的数据库                                     |

```sql
GRANT priv_type [(column_list)] [, priv_type [(column_list)]] ... [ON object_type] TO principal_specification [, principal_specification] ... [WITH GRANT OPTION] 

REVOKE priv_type [(column_list)] [, priv_type [(column_list)]] ... [ON object_type priv_level] FROM principal_specification [, principal_specification] ... 

REVOKE ALL PRIVILEGES, GRANT OPTION FROM user [, user] ...  
```

object_type:    TABLE   | DATABASE  

priv_level:    db_name   | tbl_name 



As of the release of Hive 0.7, only these operations require permissions, according to org.apache.hadoop.hive.ql.plan.HiveOperation:

| Operation                       | ALTER | UPDATE | CREATE | DROP | INDEX | LOCK | SELECT | SHOW DATABASE |
| ------------------------------- | ----- | ------ | ------ | ---- | ----- | ---- | ------ | ------------- |
| LOAD                            |       | √      |        |      |       |      |        |               |
| EXPORT                          |       |        |        |      |       |      | √      |               |
| IMPORT                          | √     | √      |        |      |       |      |        |               |
| CREATE TABLE                    |       |        | √      |      |       |      |        |               |
| CREATE TABLE AS SELECT          |       | √      |        |      |       |      | √      |               |
| DROP TABLE                      |       |        |        | √    |       |      |        |               |
| SELECT                          |       |        |        |      |       |      | √      |               |
| ALTER TABLE ADD COLUMN          | √     |        |        |      |       |      |        |               |
| ALTER TABLE REPLACE COLUMN      | √     |        |        |      |       |      |        |               |
| ALTER TABLE RENAME              | √     |        |        |      |       |      |        |               |
| ALTER TABLE ADD PARTITION       |       |        | √      |      |       |      |        |               |
| ALTER TABLE DROP PARTITION      |       |        |        | √    |       |      |        |               |
| ALTER TABLE ARCHIVE             |       | √      |        |      |       |      |        |               |
| ALTER TABLE UNARCHIVE           |       | √      |        |      |       |      |        |               |
| ALTER TABLE SET PROPERTIES      | √     |        |        |      |       |      |        |               |
| ALTER TABLE SET SERDE           | √     |        |        |      |       |      |        |               |
| ALTER TABLE SET SERDEPROPERTIES | √     |        |        |      |       |      |        |               |
| ALTER TABLE CLUSTER BY          | √     |        |        |      |       |      |        |               |
| ALTER TABLE PROTECT MODE        | √     |        |        |      |       |      |        |               |
| ALTER PARTITION PROTECT MODE    | √     |        |        |      |       |      |        |               |
| ALTER TABLE SET FILEFORMAT      | √     |        |        |      |       |      |        |               |
| ALTER TABLE SET LOCATION        |       | √      |        |      |       |      |        |               |
| ALTER PARTITION SET LOCATION    |       | √      |        |      |       |      |        |               |
| ALTER TABLE CONCATENATE         |       | √      |        |      |       |      |        |               |
| ALTER PARTITION CONCATENATE     |       | √      |        |      |       |      |        |               |
| SHOW DATABASE                   |       |        |        |      |       |      |        | √             |
| LOCK TABLE                      |       |        |        |      |       | √    |        |               |
| UNLOCK TABLE                    |       |        |        |      |       | √    |        |               |