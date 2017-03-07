---
search:
   keywords: ['Java API', 'JDBC', 'JDBC driver']
---

# JDBC Driver
> GroupId: **com.orientechnologies** ArtifactId: **orientdb-jdbc**

The JDBC driver for OrientDB allows to connect to a remote server using the standard and consolidated way of interacting with database in the Java world.

## How can be used in my code?

The driver is registered to the Java SQL DriverManager and can be used to work with all the OrientDB database types:
- memory,
- plocal and
- remote

The driver's class is ```com.orientechnologies.orient.jdbc.OrientJdbcDriver```. Use your knowledge of JDBC API to work against OrientDB.

## First get a connection

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

The driver retrieves OrientDB metadata (@rid,@class and @version) only on direct queries. Take a look at tests code to see more detailed examples.

## Write queries advices

The OrientDB JDBC Driver maps types returned by OrientDB itself gathering metadata at database and result set level. For better naming and type mapping, the suggestion is to always define aliases when aggregation functions are used.
 
```java
stmt.execute("SELECT DISTINCT(published) AS pub FROM Item ")
 
stmt.execute("SELECT SUM(score) AS totalScore FROM Item ")
 
```

Using aliases helps the driver in the name mapping phase, and it is a good practice anyway.

## Advanced features

### Connection pool
By default a new database instance is created every time you ask for a JDBC connection. OrientDB JDBC driver provides a Connection Pool out of the box. Set the connection pool parameters before to ask for a connection:

```java
Properties info = new Properties();
info.put("user", "admin");
info.put("password", "admin");

info.put("db.usePool", "true"); // USE THE POOL
info.put("db.pool.min", "3");   // MINIMUM POOL SIZE

Connection conn = (OrientJdbcConnection) DriverManager.getConnection("jdbc:orient:remote:localhost/test", info);
```

### Spark compatibility

[Apache Spark](http://spark.apache.org/) allows reading and writing of DataFrames from JDBC data sources. 
The driver can be used to load data from an OrientDB database, but is not able (yet) to write the DataFrame from Spark.
 
The driver offers a compatibility mode to enable load of data frame from an OrientDB's class or query. 

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
