---
search:
   keywords: ['etl', 'ETL']
---

<!-- proofread 2015-12-11 SAM -->
# ETL

The Extractor Transformer and Loader, or ETL, module for OrientDB provides support for moving data to and from OrientDB databases using [ETL processes](http://en.wikipedia.org/wiki/Extract,_transform,_load).

- [Configuration](Configuration-File.md): The ETL module uses a configuration file, written in JSON.
- [Extractor](Extractor.md) Pulls data from the source database.
- [Transformers](Transformer.md) Convert the data in the pipeline from its source format to one accessible to the target database.
- [Loader](Loader.md) loads the data into the target database.


## How ETL Works

The ETL module receives a backup file from another database, it then converts the fields into an accessible format and loads it into OrientDB.

```
EXTRACTOR => TRANSFORMERS[] => LOADER
```

For example, consider the process for a CSV file.  Using the ETL module, OrientDB loads the file, applies whatever changes it needs, then stores the record as a document into the current OrientDB database.

```
+-----------+-----------------------+-----------+
|           |              PIPELINE             |
+ EXTRACTOR +-----------------------+-----------+
|           |     TRANSFORMERS      |  LOADER   |
+-----------+-----------------------+-----------+
|   FILE   ==>  CSV->FIELD->MERGE  ==> OrientDB |
+-----------+-----------------------+-----------+
```

## Usage

To use the ETL module, run the `oetl.sh` script with the configuration file given as an argument.

<pre>
$ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/oetl.sh config-dbpedia.json</code>
</pre>


|    |    |
|----|----|
| ![NOTE](../images/warning.png) | _NOTE: If you are importing data for use in a distributed database, then you must set `ridBag.embeddedToSbtreeBonsaiThreshold=Integer.MAX\_VALUE` for the ETL process to avoid replication errors, when the database is updated online._ |

### Run-time Configuration

When you run the ETL module, you can define its configuration variables by passing it a JSON file, which the ETL module resolves at run-time by passing them as it starts up.

You could also define the values for these variables through command-line options.  For example, you could assign the database URL as `${databaseURL}`, then pass the relevant argument through the command-line:

<pre>
$ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/oetl.sh config-dbpedia.json \
      -databaseURL=plocal:/tmp/mydb</code>
</pre>

When the ETL module initializes, it pulls `/tmp/mydb` from the command-line to define this variable in the configuration file.

## Available Components

- [Blocks](Block.md)
- [Sources](Source.md)
- [Extractors](Extractor.md)
- [Transformers](Transformer.md)
- [Loaders](Loader.md)

Examples:
- [Import the database of Beers](../gettingstarted/tutorials/Import-the-Database-of-Beers.md)
- [Import from CSV to a Graph](Import-from-CSV-to-a-Graph.md)
- [Import from JSON](Import-from-JSON.md)
- [Import DBPedia](Import-from-DBPedia.md)
- [Import from a DBMS](Import-from-DBMS.md)
- [Import from Parse (Facebook)](Import-from-PARSE.md)
