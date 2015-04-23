# ETL - Configuration

One of the most important OrientDB-ETL module features is the simplicity to configure complex ETL processed, just by working to a single [JSON](http://en.wikipedia.org/wiki/JSON) file.

The Configuration file is divided in the following sections:
- **config**, to manage all the settings and context's variables used by any component of the process
- **source**, to manage the source to process
- **begin**, as a list of [Blocks](Block.md) to execute in order. This section is executed when the process begins
- **extractor**, contains the [Extractor](Extractor.md) configuration
- **transformers**, contains the list of [Transformers](Transformer.md) configuration to execute in pipeline
- **loader**, contains the [Loader](Loader.md) configuration
- **end**, as a list of [Blocks](Block.md) to execute in order. This section is executed when the process is finished

## Syntax
```
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

Example:

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

## Generic rules
- context variables can be used by prefixing them with $
- `$input` is the context variable assigned before each transformation
- to execute an expression using OrientDB SQL, use `={<expression>}`, example: `={eval('3 * 5')}`

## Conditional execution
All executable blocks, like [Transformers](Transformer.md) and [Blocks](Block.md), can be executed only if a condition is true by using the **if** conditional expression using the [OrientDB SQL syntax](SQL-Where.md). Example:

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
````

## Log setting
Most of the blocks, like [Transformers](Transformer.md) and [Blocks](Block.md), supports the `log` setting. Log can be one of the following values (case insensitive): `[NONE, ERROR, INFO, DEBUG]`. By default is `INFO`.

Set the log level to `DEBUG` to display more information on execution. Remember that logging slows down execution, so use it only for development and debug purpose. Example:

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

## Configuration variables
All the variables declared in "config" block are bound in the execution context and can be used by ETL processing.

There are also special variables used by ETL process:

| Variable | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|log|Global "log" setting. Accepted values: `[NONE, ERROR, INFO, DEBUG]`. Useful to debug a ETL process or single component.|string|false|INFO|
|maxRetries|Maximum number of retries in case the loader raises a ONeedRetryException: concurrent modification of the same records|integer|false|10|
|parallel|Executes pipelines in parallel by using all the available cores. This feature is experimental.|boolean|false|false|
|haltOnError|Halt the process in case of unmanaged error. If it is false, the process continue in case of errors. The encountered error number is reported at the end of importing. Since 2.0.9.|boolean|false|true|