<!-- proofread 2015-12-11 SAM -->
# ETL - Sources

**Source** components represent the source of the data to be extracted. Some [Extractors](Extractor.md) like JDBCExtractor work without a source, and thus can be optional.

## Available Sources


|[file](Source.md#file)|[input](Source.md#input)|[http](Source.md#http)|
|-----|-----|-----|
|<!-- PH -->|<!-- PH -->|<!-- PH -->|

### file

Represents a source file, from which data is read. Files can be text files or compressed with tar.gz.

- Component name: **file**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|path|File path|string|true|-|
|lock|Lock the file while the extraction phase|boolean|false|false|
|encoding|File encoding|string|false|UTF-8|


#### Example
Extracts from the file "/temp/actor.tar.gz":

```json
{ "file": { "path": "/temp/actor.tar.gz", "lock" : true , "encoding" : "UTF-8"} }
```

-----

### input

Extracts data from console input. This is useful when the ETL works in a PIPE with other tools

- Component name: **input**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|

#### Example
Extracts the file as input

```
cat /etc/csv|oetl.sh "{transformers:[{csv:{}}]}"
```
-----

### http

Uses an HTTP endpoint as a data source.

- Component name: **http**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|url|HTTP URL to invoke|String|true|-|
|method|HTTP Method between "GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "TRACE"|String|false|GET|
|headers|Request headers as inner document key/value|Document|false| |

#### Example
Execute an HTTP request against the URL "http://ip.jsontest.com/" in a GET, setting the User-Agent in the headers:

```json
{ "http": {
    "url": "http://ip.jsontest.com/",
    "method": "GET",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36"
    }
  }
}
```

-----
