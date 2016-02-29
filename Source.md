<!-- proofread 2015-12-11 SAM -->
# ETL - Sources

When OrientDB executes the ETL module, source components define the source of the data you want to extract.  In the case of some [extractors](Extractor.md) like JDBCExtractor work without source, making this component optional.  The ETL module in OrientDB supports the following types of sources:

- [`"file"`](#file-sources)
- [`"input"`](#input-sources)
- [`"http"`](#http-sources)


## File Sources

In the file source component, the variables represent a source file containing the data you want the ETL module to read.  You can use text files or files comprssed to `tar.gz`.

- Component name: `file`

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|:---------:|-----------|
| `"path"` | Defines the path to the file | string | yes | |
| `"lock"` | Defines whether to lock the file during the extraction phase. | boolean | | `false` |
| `"encoding"` | Defines the encoding for the file. | string | | `UTF-8` |

**Examples**

- Extract data from the file at `/tmp/actor.tar.gz`:

  ```json
  { 
     "file": { 
	    "path": "/tmp/actor.tar.gz", 
		"lock" : true , 
		"encoding" : "UTF-8" 
     }
  }
  ```

## Input Sources

In the input source component, the ETL module extracts data from console input.  You may find this useful in cases where the ETL module operates in a pipe with other tools.

- Component name: `input`

**Syntax**
```sh
oetl.sh "<input>"
```
**Example**

- Cat a file, piping its output into the ETL module:

  <pre>
  $ <code class="lang-sh userinput">cat /etc/csv | $ORIENTDB_HOME/bin/oetl.sh \
        "{transformers:[{csv:{}}]}"</code>
  </pre>


## HTTP Sources

In the HTTP source component, the ETL module extracts data from an HTTP address as source.

- Component name: `http`

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-------|-------|------|:--------:|-----------|
| `"url"` | Defines the URL to look to for source data. | string | yes | |
| `"method"` | Defines the HTTP method to use in extracting data.  Supported methods are: `GET`, `POST`, `PUT`, `DELETE`, `HEAD`, `OPTIONS`, and `TRACE`. | string | | `GET` |
| `"headers"` | Defines the request headers as an inner document key/value. | document | | |

**Examples**

- Execute an HTTP request in a `GET`, setting the user agent in the header:

  ```json
  { 
     "http": {
        "url": "http://ip.jsontest.com/",
        "method": "GET",
        "headers": {
           "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36"
        }
     }
  }
  ```
