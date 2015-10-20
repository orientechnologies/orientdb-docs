# ETL - Extractors

**Extractor** components are the first part of the ETL process responsible of extracting data.

## Available Extractors

|  |  |  |  |
|-----|-----|-----|-----|
|[row](Extractor.md#row)|[jdbc](Extractor.md#jdbc)|[json](Extractor.md#json) | [csv](Extractor.md#csv)|

### row
Extracts content row by row.

- Component name: **row**
- Output class: [**String**]

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|multiLine|Supports multi line. This is useful with CSV supporting linefeed inside strings. Since 2.0.9|boolean|false|true|
|lineFeed|Linefeed to use in case of multiline (see above). Since 2.0.9|string|false|`\r\n`|

#### Example with default configuration

```json
{ "row": {} }
```

-----

### csv
(Since v2.1.4)

Extract content from csv files. [Apache Commons-csv](https://commons.apache.org/proper/commons-csv/) is used to parse csv files. 
This component is avaliable since version **2.1.4**

- Component name. **csv**
- Output class: [**ODocument**]

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|separator|Column separator|char|false|,|
|columnsOnFirstLine|Columns are described in the first line|boolean|false|true|
|columns|Columns array containing names, and optionally types by postfixing names with:<type> . Specifying type guarantee better performances'| string[] |false|-|
|nullValue|value to consider as *NULL*|string|false|NULL|
|dateFormat|date format to use for parsing dates|string|false|yyy-mm-dd|
|quote|String character delimiter|char|false|"|
|skipFrom|Line number where start to skip|integer|false|-|
|skipTo|Line number where skip ends|integer|false|-|
|ignoreEmptyLines|Ignore empry lines|boolean|false|false|
|predefinedFormat|Name of standard csv format (from Apache commons-csv): *DEFAULT*, *EXCEL*, *MYSQL*, *RFC4180*, *TDF*|string|false|-|

Documentation about commons-csv predefined format is available here: (https://commons.apache.org/proper/commons-csv/apidocs/org/apache/commons/csv/CSVFormat.html)


#### Examples
Extract lines from CSV (as ODocument), using comma as separator, considering "NULL" as null value and skipping the rows 2-4:
```json
{ "csv": 
    {  "separator": ",", 
        "nullValue": "NULL",
        "skipFrom": 1, 
        "skipTo": 3 
    }
}
```

Extract lines from a CSV exported from MYSQL:

```json
{ "csv": 
    {  "predefinedFormat": "MYSQL"}
}
```


Extract lines from a CSV with default format using 'N/A' as null value placeholder and custom date format:

```json
{ "csv": 
    {  "predefinedFormat": "DEFAULT",
        "nullValue" : "N/A",
        "dateFormat" : "dd-mm-yyyy HH:MM"
    }
}
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
