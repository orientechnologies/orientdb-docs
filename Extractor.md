---
search:
   keywords: ['etl', 'ETL', 'extractor']
---

<!-- proofread 2015-12-11 SAM -->
# ETL - Extractors

When OrientDB executes the ETL module, extractor components handle data extraction from source.  They are the first part of the ETL process. The ETL module in OrientDB supports the following extractors:

- [Row](#row-extractor)
- [CSV](#csv-extractor)
- [JDBC](#jdbc-extractor)
- [JSON](#json-extractor)
- [XML](#xml-extractor)

## Row Extractor

When the ETL module runs with a Row Extractor, it extracts content row by row.  It outputs a string array class.

- Compnent name: `row`
- Output Class: `[ string ]`

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|:------:|-----------|
| `"multiLine"` | Defines whether the process supports multiline.  Useful with CSV's supporting linefeed inside of string. | boolean | | `true` |
| `"linefeed"` | Defines the linefeed to use in the event of multiline processing. | string | | `\r\n` |

>The `"multiLine"` and `"linefeed"` parameters were introduced in version 2.0.9.


**Examples**

- Use the row extractor with its default configuration:

  ```json
  { 
     "row": {} 
  }
  ```

## CSV Extractor

When the ETL module runs the CSV Extractor, it parses a file formated to [Apache Commons CSV](https://commons.apache.org/proper/commons-csv) and extracts the data into OrientDB.  This component was introduced in version 2.1.4 and is unavailable in older releases of OrientDB.

- Component name: `csv`
- Output class: `[ ODocument ]`

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"separator"` | Defines the column separator. | char | | `,` |
| `"columnsOnFirstLine"` | Defines whether the first line contains column descriptors. | boolean | | `true` |
| `"columns"` | Defines array for names and (optionally) types to write. | string array | | |
| `"nullValue"` | Defines the null value in the file. | string | | `NULL` |
| `"dateFormat"` | Defines the format to use in parsing dates from file. | string | | `yyyy-MM-dd` |
| `"dateTimeFormat"` | Defines the format to use in parsing dates with time from file. | string | | `yyyy-MM-dd HH:mm` |
| `"quote"` | Defines string character delimiter. | char | | `"`|
| `"skipFrom"` | Defines the line number you want to skip from. | integer | | |
| `"skipTo"` | Defines the line number you want to skip to. | integer | | |
| `"ignoreEmptyLines"` | Defines whether it should ignore empty lines. | boolean | | `false` |
| `"ignoreMissingColumns"` | Defines whether it should ignore empty columns. | boolean | | `false` |
| `"predefinedFormat"` | Defines the CSV format you want to use. | string | | |

- For the `"columns"` parameter, specify the type by postfixing it to the value.  Specifying types guarantees better performance.  

- For the `"predefinedFormat"` parameter, the available formats are: `Default`, `Excel`, `MySQL`, `RFC4180`, `TDF`.

**Examples**

- Extract lines from CSV to the `ODocument` class, using commas as the separator, considering `NULL` as the null value and skipping rows two through four:


  ```json
  { "csv": 
      {  "separator": ",", 
         "nullValue": "NULL",
         "skipFrom": 1, 
         "skipTo": 3 
      }
  }
  ```

- Extract lines from a CSV exported from MySQL:

  ```json
  { "csv": 
      {  "predefinedFormat": "MySQL"}
  }
  ```

- Extract lines from a CSV with the default formatting, using `N/A` as the null value and a custom date format:

  ```json
  { "csv": 
      {  "predefinedFormat": "Default",
         "nullValue" : "N/A",
         "dateFormat" : "dd-MM-yyyy",
         "dateTimeFormat" : "dd-MM-yyyy HH:mm"
      }
  }
  ```

- Extract lines from a CSV with the default formatting, using `N/A` as the null value, a custom date format, a custom dateTime format and columns type mapping :

  ```json
  { "csv": 
      {  "predefinedFormat": "DEFAULT",
         "nullValue" : "N/A",
         "dateFormat" : "dd-MM-yyyy",
         "dateTimeFormat" : "dd-MM-yyyy HH:mm",
         "columns": ["name:string","createdAt:date","updatedAt:dateTime"]
      }
  }
  ```

## JDBC Extractor

When the ETL module runs the JDBC Extractor, it can access any database management system that supports the [JDBC](http://en.wikipedia.org/wiki/JDBC_driver) driver.

In order for the ETL component to connect to the source database, put the source database's JDBC driver in the classpath, or in the `$ORIENTDB_HOME/lib` directory.

- Component name: `jdbc`
- Output class: `[ ODocument ]`

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"driver"` | Defines the JDBC Driver class. | string | yes | |
| `"url"` | Defines the JDBC URL to connect to. | string | yes | |
| `"userName"` | Defines the username to use on the source database. | string | yes | |
| `"userPassword"` | Defines the user password to use on the source database. | string | yes | |
| `"query"` | Defines the query to extract the record you want to import. | string | yes | |
| `"queryCount"` | Defines query that returns the count of the fetched records, (used to provide a correct progress indicator). | string | | |

**Example**

- Extract the contents of the `client` table on the MySQL database `test` at localhost:

  ```json
  { "jdbc": {
      "driver": "com.mysql.jdbc.Driver",
      "url": "jdbc:mysql://localhost/test",
      "userName": "root",
      "userPassword": "my_mysql_passwd",
      "query": "SELECT * FROM client"
    }
  }
  ```

## JSON Extractor

When the ETL module runs with a JSON Extractor, it extracts data by parsing JSON objects.  If the data has more than one JSON items, you must enclose the in `[]` brackets.

- Component name: `json`
- Output class: `[ ODocument ]`

<!-- #### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------| -->


**Example**

- Extract data from a JSON file.

  ```json
  { "json": {} }
  ```

## XML Extractor

When the ETL module runs with the XML extractor, it extracts data by parsing XML elements.  This feature was introduced in version 2.2.

- Component name: `xml`
- Output class: `[ ODocument ]`

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"rootNode"` | Defines the root node to extract in the XML.  By default, it builds from the root element in the file. | string | | |
| `"tagsAsAttribute"` | Defines an array of elements, where child elements are considered as attributes of the document and the attribute values as the text within the element. | string array | | |

**Examples**

- Extract data from an XML file, where the XML file reads as:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <a>
	<b>
		<c name='Ferrari' color='red'>ignore</c>
		<c name='Maserati' color='black'/>
	</b>
  </a>
  ```

  While the OrientDB-ETL configuration file reads as:

  ```json
  { "source": 
    { "file": 
	  { "path": "src/test/resources/simple.xml" } 
    }, 
    "extractor" : 
	  { "xml": {} }, 
	  "loader": 
	    { "test": {} } 
  }
  ```

  This extracts the data as:
  ```json
  {
    "a": {
      "b": {
        "c": [
          {
            "color": "red",
            "name": "Ferrari"
          },
          {
            "color": "black",
            "name": "Maserati"
          }
        ]
      }
    }
  }
  ```

- Extract a collection from XML, where the XML file reads as:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <CATALOG>
      <CD>
          <TITLE>Empire Burlesque</TITLE>
          <ARTIST>Bob Dylan</ARTIST>
          <COUNTRY>USA</COUNTRY>
          <COMPANY>Columbia</COMPANY>
          <PRICE>10.90</PRICE>
          <YEAR>1985</YEAR>
      </CD>
      <CD>
          <TITLE>Hide your heart</TITLE>
          <ARTIST>Bonnie Tyler</ARTIST>
          <COUNTRY>UK</COUNTRY>
          <COMPANY>CBS Records</COMPANY>
          <PRICE>9.90</PRICE>
          <YEAR>1988</YEAR>
      </CD>
      <CD>
          <TITLE>Greatest Hits</TITLE>
          <ARTIST>Dolly Parton</ARTIST>
          <COUNTRY>USA</COUNTRY>
          <COMPANY>RCA</COMPANY>
          <PRICE>9.90</PRICE>
          <YEAR>1982</YEAR>
      </CD>
  </CATALOG>
  ```

  While the OrientDB-ETL configuration file reads:

  ```json
  { "source": 
    { "file": 
	  { "path": "src/test/resources/music.xml" } 
    }, "extractor" : 
	  { "xml": 
	    { "rootNode": "CATALOG.CD", 
		  "tagsAsAttribute": ["CATALOG.CD"] 
		} 
	  }, 
	  "loader": { "test": {} } 
  }
  ```

  This extracts the data as:

  ```json
  {
    "TITLE": "Empire Burlesque",
    "ARTIST": "Bob Dylan",
    "COUNTRY": "USA",
    "COMPANY": "Columbia",
    "PRICE": "10.90",
    "YEAR": "1985"
  }
  {
    "TITLE": "Hide your heart",
    "ARTIST": "Bonnie Tyler",
    "COUNTRY": "UK",
    "COMPANY": "CBS Records",
    "PRICE": "9.90",
    "YEAR": "1988"
  }
  {
    "TITLE": "Greatest Hits",
    "ARTIST": "Dolly Parton",
    "COUNTRY": "USA",
    "COMPANY": "RCA",
    "PRICE": "9.90",
    "YEAR": "1982"
  }
  ```
