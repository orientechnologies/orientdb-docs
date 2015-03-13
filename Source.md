# ETL - Sources

**Source** components represent the source where to extract the content. Source is optional, some [Extractor](Extractor.md) like JDBCExtractor works without a source.

## Available Sources

|  |  |  |  |
|-----|-----|-----|-----|
|[file](Source.md#file)|[input](Source.md#input)|[http](Source.md#http)| |

### File
Represents a source file where to start reading. Files can be text files or compressed with tar.gz.

- Component name: **file**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|path|File path|string|true|-|
|lock|Lock the file while the extraction phase|boolean|false|false|


#### Example
Extracts from the file "/temp/actor.tar.gz":

```json
{ "file": { "path": "/temp/actor.tar.gz", "lock" : true } }
```

-----

### Input
Extracts data from console input. This is useful when the ETL works in PIPE with other tools

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

### HTTP
Use a HTTP endpoint as content source.

- Component name: **http**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|url|HTTP URL to invoke|String|true|-|
|method|HTTP Method between "GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "TRACE"|String|false|GET|
|headers|Request headers as inner document key/value|Document|false| |

#### Example
Execute a HTTP request against the URL "http://ip.jsontest.com/" in GET setting the User-Agent in headers:

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
