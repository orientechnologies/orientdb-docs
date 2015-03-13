# JDBC Driver

[OrientDB](http://www.orientechnologies.com) is a NoSQL DBMS that support a subset of SQL ad query language.

## Include in your projects

```xml
<dependency>
  <groupId>com.orientechnologies</groupId>
  <artifactId>orientdb-jdbc</artifactId>
  <version>1.7</version>
</dependency>
```
_NOTE: to use SNAPSHOT version remember to add the Snapshot repository to your ```pom.xml```._

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

## Advanced features

### Connection pool
By default a new database instance is created every time you ask for a JDBC connection. OrientDB JDBC driver provides a Connection Pool out of the box. Set the connection pool parameters before to ask for a connection:

```java
Properties info = new Properties();
info.put("user", "admin");
info.put("password", "admin");

info.put("db.usePool", "true"); // USE THE POOL
info.put("db.pool.min", "3");   // MINIMUM POOL SIZE
info.put("db.pool.max", "30");  // MAXIMUM POOL SIZE

Connection conn = (OrientJdbcConnection) DriverManager.getConnection("jdbc:orient:remote:localhost/test", info);
```
