# ETL - Extractors

**Extractor** components are the first part of the ETL process responsible of extracting data.

## Available Extractors

|  |  |  |  |
|-----|-----|-----|-----|
|[row](Extractor.md#row)|[jdbc](Extractor.md#jdbc)|[json](Extractor.md#json) | |

### row
Extracts content row by row.

- Component name: **row**
- Output class: [**String**]

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|

#### Example

```json
{ "row": {} }
```

-----

### JDBC
Extracts data from any **DBMS** that support [JDBC](http://en.wikipedia.org/wiki/JDBC_driver) driver. In order to get the ETL component to connect to the source database, put the DBMS's JDBC driver in the **classpath** or **$ORIENTDB_HOME/lib** directory.

- Component name: **jdbc**
- Output class: [**ODocument**]

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|driver|JDBC Driver class|string|true|-|
|url|JDBC URL to connect|string|true|-|
|userName|DBMS User name|string|true|-|
|userPassword|DBMS User password|string|true|-|
|query|Query that extract the record to import|string|true|-|
|queryCount|Query that return the count of the fetched records. This is used to provide a correct progress indicator|string|false|-|

#### Example
Extracts all the Client from the MySQL database "test" hosted on localhost:

```json
{ "jdbc": {
    "driver": "com.mysql.jdbc.Driver",
    "url": "jdbc:mysql://localhost/test",
    "userName": "root",
    "userPassword": "",
    "query": "select * from Client"
  }
}
```

-----

### json
Extracts content by parsing json objects. If the content has more json items must be enclosed between [].

- Component name: **json**
- Output class: [**ODocument**]

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|


#### Example

```json
{ "json": {} }
```
-----
