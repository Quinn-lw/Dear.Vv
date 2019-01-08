## Installing Debezium

Download the  connector plugins :

- [MySQL Connector plugin archive](https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/0.8.3.Final/debezium-connector-mysql-0.8.3.Final-plugin.tar.gz)
- [Postgres Connector plugin archive](https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/0.8.3.Final/debezium-connector-postgres-0.8.3.Final-plugin.tar.gz)
- [MongoDB Connector plugin archive](https://repo1.maven.org/maven2/io/debezium/debezium-connector-mongodb/0.8.3.Final/debezium-connector-mongodb-0.8.3.Final-plugin.tar.gz)
- [Oracle Connector plugin archive](https://repo1.maven.org/maven2/io/debezium/debezium-connector-oracle/0.9.0.Beta1/debezium-connector-oracle-0.9.0.Beta1-plugin.tar.gz)(tech preview)
- [SQL Server Connector plugin archive](https://repo1.maven.org/maven2/io/debezium/debezium-connector-sqlserver/0.9.0.Beta1/debezium-connector-sqlserver-0.9.0.Beta1-plugin.tar.gz)(tech preview)

```bash
> vi config/connect-distributed.properties
+ plugin.path=/usr/local/share/kafka/plugins
> mkdir -p /usr/local/share/kafka/plugins
> cd /usr/local/share/kafka/plugins
> tar -xzf ~/debezium-connector-mysql-0.8.3.Final-plugin.tar.gz
> tar -xzf ~/debezium-connector-mongodb-0.8.3.Final-plugin.tar.gz
```

## Debezium Connector for MySQL

### Enabling the binlog

The MySQL server must be configured to use a *row-level* binary log, which is described in more detail in the [MySQL documentation](http://dev.mysql.com/doc/refman/5.7/en/replication-options.html). This is most often done in the MySQL server configuration file, and will look similar to the following fragment:

```
server-id         = 223344
log_bin           = mysql-bin
binlog_format     = row
binlog_row_image  = full
expire_logs_days  = 10
```

where:

- the value for [`server-id`](http://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_server_id) must be unique for each server and replication client within the MySQL cluster. When we set up the connector, we’ll also assign the connector a unique server ID.
- the value for [`log_bin`](http://dev.mysql.com/doc/refman/5.7/en/replication-options-binary-log.html#sysvar_log_bin) is the base name for the sequence of binlog files.
- the value for [`binlog_format`](http://dev.mysql.com/doc/refman/5.7/en/replication-options-binary-log.html#sysvar_binlog_format) must be set to `row` or `ROW`.
- the value for [`binlog_row_image`](https://dev.mysql.com/doc/refman/5.7/en/replication-options-binary-log.html#sysvar_binlog_row_image) must be set to `full` or `FULL`.
- the value for [`expire_log_days`](http://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_expire_logs_days) is the number of days for automatic binary log file removal. The default is 0, which means "no automatic removal," so be sure to set a value that is appropriate for your environment.

### Enabling GTIDs (optional)

The MySQL server can be configured to use [GTID-based replication](https://dev.mysql.com/doc/refman/5.6/en/replication-gtids.html). Global transaction identifiers, or GTIDs, were introduced in MySQL 5.6.5, and they uniquely identify a transaction that occurred on a particular server within a cluster. Using GTIDs greatly simplifies replication and makes it possible to easily confirm whether masters and slaves are consistent. **Note that if you’re using an earlier version of MySQL, you will not be able to enable GTIDs.**

```
gtid_mode                 = on
enforce_gtid_consistency  = on
```

where:

- the value for [`gtid_mode`](https://dev.mysql.com/doc/refman/5.6/en/replication-options-gtids.html#option_mysqld_gtid-mode) specifies the GTID mode of the MySQL server.
- the value for [`enforce_gtid_consistency`](https://dev.mysql.com/doc/refman/5.6/en/replication-options-gtids.html) instructs the server to enforce GTID consistency by allowing execution of only those statements that can be logged in a transactionally safe manner, and is required when using GTIDs.

Consult the [MySQL documentation](https://dev.mysql.com/doc/refman/5.6/en/replication-options-gtids.html#option_mysqld_gtid-mode) for details and specifics about setting up GTIDs.

### Enabling Query Log Events (optional)

Starting with MySQL 5.6 row based replication can be configured to include the original SQL statement with each binlog event. **Note that if you’re using an earlier version of MySQL, you will not be able to enable this feature.**

Enabling this option can be done in the MySQL server configuration file, and will look similar to the following fragment:

```
binlog_rows_query_log_events = on
```

where:

- the value for [`binlog_rows_query_log_events`](https://dev.mysql.com/doc/refman/5.7/en/replication-options-binary-log.html#sysvar_binlog_rows_query_log_events) can be set to `on` or `ON` to enable support for including the original SQL statement in the binlog entry.

###  Create a MySQL user for the connector

A MySQL user must be defined that has all of the following permissions on all of the databases that the connector will monitor:

- [`SELECT`](http://dev.mysql.com/doc/refman/5.7/en/privileges-provided.html#priv_select) - enables the connector to select rows from tables in databases; used only when performing a snapshot
- [`RELOAD`](http://dev.mysql.com/doc/refman/5.7/en/privileges-provided.html#priv_reload) - enables the connector of the [`FLUSH`](http://dev.mysql.com/doc/refman/5.7/en/flush.html) statement to clear or reload various internal caches, flush tables, or acquire locks; used only when performing a snapshot
- [`SHOW DATABASES`](http://dev.mysql.com/doc/refman/5.7/en/privileges-provided.html#priv_show-databases) - enables the connector to see database names by issuing the `SHOW DATABASE` statement; used only when performing a snapshot
- [`REPLICATION SLAVE`](http://dev.mysql.com/doc/refman/5.7/en/privileges-provided.html#priv_replication-slave) - enables the connector to connect to and read the binlog of its MySQL server; always required for the connector
- [`REPLICATION CLIENT`](http://dev.mysql.com/doc/refman/5.7/en/privileges-provided.html#priv_replication-client) - enables the use of `SHOW MASTER STATUS`, `SHOW SLAVE STATUS`, and `SHOW BINARY LOGS`; always required for the connector

For example, the following statement grants these permissions for a user `debezium` that authenticates with the password `dbz`, where the user can be on any machine:

```sql
create user 'debezium'@'%' identified by 'kafka@4PX';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium' IDENTIFIED BY 'kafka@4PX';
flush privileges;
```

### Deploying a connector

To use the connector to produce change events for a particular MySQL server or cluster, simply create a [configuration file for the MySQL Connector](https://debezium.io/docs/connectors/mysql/#configuration) and use the [Kafka Connect REST API](http://docs.confluent.io/3.0.0/connect/userguide.html#rest-interface) to add that connector to your Kafka Connect cluster. When the connector starts, it will grab a consistent snapshot of the databases in your MySQL server and start reading the MySQL binlog, producing events for every inserted, updated, and deleted row. The connector can optionally produce events with the DDL statements that were applied, and you can even choose to produce events for a subset of the databases and tables. Optionally ignore, mask, or truncate columns that are sensitive, too large, or not needed.

#### Example configuration

Using the MySQL connector is straightforward. Here is an example of the configuration for a MySQL connector that monitors a MySQL server at port 3306 on 192.168.99.100, which we logically name `fullfillment`:

```
{
  "name": "inventory-connector",  (1)
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector", (2)
    "database.hostname": "192.168.99.100", (3)
    "database.port": "3306", (4)
    "database.user": "debezium", (5)
    "database.password": "dbz", (6)
    "database.server.id": "184054", (7)
    "database.server.name": "fullfillment", (8)
    "database.whitelist": "inventory", (9)
    "database.history.kafka.bootstrap.servers": "kafka:9092", (10)
    "database.history.kafka.topic": "dbhistory.fullfillment" (11)
    "include.schema.changes": "true" (12)
  }
}
```

1. The name of our connector when we register it with a Kafka Connect service.
2. The name of this MySQL connector class.
3. The address of the MySQL server.
4. The port number of the MySQL server.
5. The name of the MySQL user that has the [required privileges](https://debezium.io/docs/connectors/mysql/#mysql-user).
6. The password for the MySQL user that has the [required privileges](https://debezium.io/docs/connectors/mysql/#mysql-user).
7. The connector’s identifier that must be unique within the MySQL cluster and similar to MySQL’s `server-id` configuration property.
8. The logical name of the MySQL server/cluster, which forms a namespace and is used in all the names of the Kafka topics to which the connector writes, the Kafka Connect schema names, and the namespaces of the corresponding Avro schema when the [Avro Connector](https://debezium.io/docs/connectors/mysql/#avro-converter) is used.
9. A list of all databases hosted by this server that this connector will monitor. This is optional, and there are other properties for listing the databases and tables to include or exclude from monitoring.
10. The list of Kafka brokers that this connector will use to write and recover DDL statements to the database history topic.
11. The name of the [database history topic](https://debezium.io/docs/connectors/mysql/#database-schema-history) where the connector will write and recover DDL statements. This topic is for internal use only and should not be used by consumers.
12. The flag specifying that the connector should generate on the [schema change topic](https://debezium.io/docs/connectors/mysql/#schema-change-topic) named `fullfillment` events with the DDL changes that *can* be used by consumers.

