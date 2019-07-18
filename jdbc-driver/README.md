---
search:
   keywords: ['JDBC', 'JDBC driver']
---

# JDBC Driver
> GroupId: **com.orientechnologies** ArtifactId: **orientdb-jdbc**

The JDBC driver for OrientDB allows connecting to an OrientDB database using the standard way of interacting with databases in the Java world.

## Overview

The driver is registered to the Java SQL DriverManager and can be used to work with all the OrientDB database types:
- memory
- plocal
- remote

The driver's class is ```com.orientechnologies.orient.jdbc.OrientJdbcDriver```.

## Getting a Connection

```java
Properties info = new Properties();
info.put("user", "admin");
info.put("password", "admin");

Connection conn = (OrientJdbcConnection) DriverManager.getConnection("jdbc:orient:remote:localhost/test", info);
```

Then execute a Statement and get the ResultSet:

```java
Statement stmt = conn.createStatement();

ResultSet rs = stmt.executeQuery("SELECT stringKey, intKey, text, length, date FROM Item");

rs.next();

rs.getInt("@version");
rs.getString("@class");
rs.getString("@rid");

rs.getString("stringKey");
rs.getInt("intKey");

rs.close();
stmt.close();
```

## Writing Queries

The OrientDB JDBC Driver maps types returned by OrientDB, gathering metadata at the database and resultset level. For better naming and type mapping, the suggested approach is to always define aliases when aggregation functions are used.
 
```java
stmt.execute("SELECT DISTINCT(published) AS pub FROM Item ")
 
stmt.execute("SELECT SUM(score) AS totalScore FROM Item ")
 
```

Using aliases helps the driver in the name mapping phase, and it is a good practice anyway.

## Advanced Features

### Connection Pool
By default a new database instance is created every time you ask for a JDBC connection. The OrientDB JDBC driver provides a Connection Pool out of the box. Set the connection pool parameters before creating a connection:

```java
Properties info = new Properties();
info.put("user", "admin");
info.put("password", "admin");

info.put("db.usePool", "true"); // USE THE POOL
info.put("db.pool.min", "3");   // MINIMUM POOL SIZE

Connection conn = (OrientJdbcConnection) DriverManager.getConnection("jdbc:orient:remote:localhost/test", info);
```

### Spark Compatibility

[Apache Spark](http://spark.apache.org/) allows reading and writing of DataFrames from JDBC data sources. 
The driver can be used to load data from an OrientDB database.
 
The driver offers a compatibility mode to enable loading of a DataFrame from an OrientDB class or query. 

```java
Map<String, String> options = new HashMap<String, String>() {{
    put("url", "jdbc:orient:remote:localhost/sparkTest");
    put("user", "admin");
    put("password", "admin");
    put("spark", "true"); // ENABLE Spark compatibility
    put("dbtable", "Item");
}};

SQLContext sqlCtx = new SQLContext(ctx);

DataFrame jdbcDF = sqlCtx.read().format("jdbc").options(options).load();
```

## Dependencies
The OrientDB JDBC driver is dependent on the following jars (they can be found in the lib directory of an OrientDB installation):
- concurrentlinkedhashmap-lru-x.x.x.jar
- jna-x.x.x.jar
- orientdb-client-x.x.x.jar
- orientdb-core-x.x.x.jar
- orientdb-jdbc-x.x.x.jar

