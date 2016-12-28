---
search:
   keywords: ['ETL', 'etl', 'configuration']
---

<!-- proofread 2015-12-11 SAM -->
# ETL - Configuration

OrientDB manages configuration for the ETL module through a single JSON configuration file, called at execution.

**Syntax** 

```json
{
  "config": {
    <name>: <value>
  },
  "begin": [
    { <block-name>: { <configuration> } }
  ],
  "source" : {
    { <source-name>: { <configuration> } }
  },
  "extractor" : {
    { <extractor-name>: { <configuration> } }
  },
  "transformers" : [
    { <transformer-name>: { <configuration> } }
  ],
  "loader" : { <loader-name>: { <configuration> } },
  "end": [
   { <block-name>: { <configuration> } }
  ]
}
```

- **`"config"`** Manages all settings and context variables used by any component of the process.
- **`"source"`** Manages the source data to process.
- **`"begin"`** Defines a list of [blocks](Block.md) to execute in order when the process begins.
- **`"extractor"`** Manages the [extractor](Extractor.md) settings.
- **`"transformers"`** Defines a list of [transformers](Transformer.md) to execute in the pipeline.
- **`"loader"`** Manages the [loader](Loader.md) settings.
- **`"end"`** Defines a list of [blocks](Block.md) to execute in order when the process finishes.

**Example**


```json
{
  "config": {
    "log": "debug",
    "fileDirectory": "/temp/databases/dbpedia_csv/",
    "fileName": "Person.csv.gz"
  },
  "begin": [
   { "let": { "name": "$filePath",  "value": "$fileDirectory.append( $fileName )"} },
   { "let": { "name": "$className", "value": "$fileName.substring( 0, $fileName.indexOf(".") )"} }
  ],
  "source" : {
    "file": { "path": "$filePath", "lock" : true }
  },
  "extractor" : {
    "row": {}
  },
  "transformers" : [
   { "csv": { "separator": ",", "nullValue": "NULL", "skipFrom": 1, "skipTo": 3 } },
   { "merge": { "joinFieldName":"URI", "lookup":"V.URI" } },
   { "vertex": { "class": "$className"} }
  ],
  "loader" : {
    "orientdb": {
      "dbURL": "plocal:/temp/databases/dbpedia",
      "dbUser": "admin",
      "dbPassword": "admin",
      "dbAutoCreate": true,
      "tx": false,
      "batchCommit": 1000,
      "dbType": "graph",
      "indexes": [{"class":"V", "fields":["URI:string"], "type":"UNIQUE" }]
    }
  }
}
```

## General Rules

In developing a configuration file for ETL module processes, consider the following:
- You can use context variables by prefixing them with the `$` sign.
- It assigns the `$input` context variable before each transformation.
- You can execute an expression in OrientDB SQL with the `={<expression>}` syntax.  For instance,

  ```json
  "field": ={EVAL('3 * 5)}
  ```
  
### Conditional Execution

In conditional execution, OrientDB only runs executable blocks, such as [transformers](Transformer.md) and [blocks](Block.md), when a condition is found true, such as with a [`WHERE`](SQL-Where.md) clause. 

For example,

```json
{ "let": {
    "name": "path",
    "value": "C:/Temp",
    "if": "${os.name} = 'Windows'"
  }
},
{ "let": {
    "name": "path",
    "value": "/tmp",
    "if": "${os.name}.indexOf('nux')"
  }
}
```

### Log setting

Most blocks, such [transformers](Transformer.md) and [blocks](Block.md), support the `"log"` setting.  Logs take one of the following logging levels, (which are case-insensitive),: `NONE`, `ERROR`, `INFO`, `DEBUG`.  By default, it uses the `INFO` level.
ETL uses the [Java util logging](https://docs.oracle.com/javase/8/docs/technotes/guides/logging/overview.html) and writes logs on the console and on a dedicated rolling file. A dedicated configuration file (`orientdb-etl-log.properties`) is present under the `config` directory of the OrientDB distribution.
ETL logging levels are mapped to JUL levels:

| ETL level | JUL level|
|-----------|-------------|
| `"NONE"` | `"OFF"` |
| `"INFO"` | `"INFO"` |
| `"DEBUG"` | `"FINE"` |
| `"ERROR"` | `"SEVERE"` |



Setting the log-level to `DEBUG` displays more information on execution.  It also slows down execution, so use it only for development and debugging purposes.

```json
{ "http": {
    "url": "http://ip.jsontest.com/",
    "method": "GET",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36"
    },
    "log": "DEBUG"
  }
}
```



### Configuration Variables

The ETL module binds all values declared in the `"config"` block to the execution context and are accessible to ETL processing.  There are also some special variables used by the ETL process.

| Variable | Description | Type | Default value |
|-----------|-------------|------|-----------|
| `"log"` | Defines the global logging level.  The accepted levels are: `NONE`, `ERROR`, `INFO`, and `DEBUG`. This parameter is useful to debug a ETL process or single component. | string | `INFO` |
| `"maxRetries"` | Defines the maximum number of retries allowed, in the event that the loader raises an `ONeedRetryException`, for concurrent modification of the same record. | integer | 10 |
| `"parallel"` | Defines whether the ETL module executes pipelines in parallel, using all available cores. | boolean | `false` |
| `"haltOnError"` | Defines whether the ETL module halts the process when it encounters unmanageable errors.  When set to `false`, the process continues in the event of errors.  It reports the number of errors it encounters at the end of the import.  This feature was introduced in version 2.0.9. | boolean | `true` |

### Split Configuration on Multiple Files

You can split the configuration into several files allowing for the composition of common parts such as paths, URL's and database references. 

For example, you might split the above configuration into two files: one with the input paths for `Person.csv` specifically, while the other would contain common configurations for the ETL module.

<pre>
$ <code class="lang-sh userinput">cat personConfig.json</code>
<code class="lang-json">
{
  "config": {
    "log": "debug",
    "fileDirectory": "/temp/databases/dbpedia_csv/",
    "fileName": "Person.csv.gz"
  }
}</code>

$ <code class="lang-sh userinput">cat commonConfig.json</code>
<code class="lang-json">
{
  "begin": [
   { "let": { "name": "$filePath",  "value": "$fileDirectory.append( $fileName )"} },
   { "let": { "name": "$className", "value": "$fileName.substring( 0, $fileName.indexOf(".") )"} }
  ],
  "source" : {
    "file": { "path": "$filePath", "lock" : true }
  },
  "extractor" : {
    "row": {}
  },
  "transformers" : [
   { "csv": { "separator": ",", "nullValue": "NULL", "skipFrom": 1, "skipTo": 3 } },
   { "merge": { "joinFieldName":"URI", "lookup":"V.URI" } },
   { "vertex": { "class": "$className"} }
  ],
  "loader" : {
    "orientdb": {
      "dbURL": "plocal:/temp/databases/dbpedia",
      "dbUser": "admin",
      "dbPassword": "admin",
      "dbAutoCreate": true,
      "tx": false,
      "batchCommit": 1000,
      "dbType": "graph",
      "indexes": [{"class":"V", "fields":["URI:string"], "type":"UNIQUE" }]
    }
  }
}</code>
</pre>

Then, when you can call both configuration files when you run the ETL module:

<pre>
$ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/oetl.sh commonConfig.json personConfig.json</code>
</pre>





### Run-time configuration

In the configuration file for the ETL module, you can define variables that the module resolves at run-time by passing them as command-line options.  Values passed in this manner *override* the values defined in the `"config"` section, even when you use multiple configuration files.

For instance, you might set the configuration variable in the file to `${databaseURL}`, then define it through the command-line using:

<pre>
$ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/oetl.sh config-dbpedia.json \
      -databaseURL=plocal:/tmp/mydb</code>
</pre>

In this case, the `databaseURL` parameter is set in the `"config"` section to `/tmp/mydb`, overriding any value given the file.

```json
{
  "config": {
    "log": "debug",
    "fileDirectory": "/temp/databases/dbpedia_csv/",
    "fileName": "Person.csv.gz"
    "databaseUrl": "plocal:/temp/currentDb"
  },
  ...
```

