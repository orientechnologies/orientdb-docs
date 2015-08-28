# ETL

The OrientDB-ETL module is an amazing tool to move data from and to OrientDB by executing an [ETL process](http://en.wikipedia.org/wiki/Extract,_transform,_load). It's super easy to use. OrientDB ETL is based on the following principles:
- one [configuration file](Configuration-File.md) in [JSON](http://en.wikipedia.org/wiki/JSON) format
- one [Extractor](Extractor.md) is allowed to extract data from a source
- one [Loader](Loader.md) is allowed to load data to a destination
- multiple [Transformers](Transformer.md) that transform data in pipeline. They receive something in input, do something, return something as output that will be processed as input by the next component

## How ETL works
```
EXTRACTOR => TRANSFORMERS[] => LOADER
```
Example of a process that extract from a CSV file, apply some change, lookup if the record has already been created and then store the record as document against OrientDB database:

```
+-----------+-----------------------+-----------+
|           |              PIPELINE             |
+ EXTRACTOR +-----------------------+-----------+
|           |     TRANSFORMERS      |  LOADER   |
+-----------+-----------------------+-----------+
|   FILE   ==>  CSV->FIELD->MERGE  ==> OrientDB |
+-----------+-----------------------+-----------+
```

The pipeline, made of transformation and loading phases, can run in parallel by setting the configuration ```{"parallel":true}```.

## Installation
Starting from OrientDB v2.0 the ETL module will be distributed in bundle with the official release. If you want to use it, then follow these steps:
- Clone the repository on your computer, by executing:
 - ```git clone https://github.com/orientechnologies/orientdb-etl.git```
- Compile the module, by executing:
 - ```mvn clean install```
- Copy ```script/oetl.sh``` (or .bat under Windows) to $ORIENTDB_HOME/bin
- Copy ```target/orientdb-etl-2.0-SNAPSHOT.jar``` to $ORIENTDB_HOME/lib

## Usage

```
$ cd $ORIENTDB_HOME/bin
$ ./oetl.sh config-dbpedia.json
```

|    |    |
|----|----|
| ![NOTE](images/warning.png) | _NOTE: If importing data for use in a distributed database then you must set `ridBag.embeddedToSbtreeBonsaiThreshold=Integer.MAX\_VALUE` for the ETL process to avoid replication errors when the database is updated online._ |

### Run-time configuration

In ETL JSON file you can define variable that will be resolved at run-time by passing them at startup . You could for example assign the database URL as `${databaseURL}` and then pass the database URL at execution time with:
```
$ ./oetl.sh config-dbpedia.json -databaseURL=plocal:/temp/mydb
```

## Available Components
- [Blocks](Block.md)
- [Sources](Source.md)
- [Extractors](Extractor.md)
- [Transformers](Transformer.md)
- [Loaders](Loader.md)

Examples:
- [Import the database of Beers](Import-the-Database-of-Beers.md)
- [Import from CSV to a Graph](Import-from-CSV-to-a-Graph.md)
- [Import from JSON](Import-from-JSON.md)
- [Import DBPedia](Import-from-DBPedia.md)
- [Import from a DBMS](Import-from-DBMS.md)
- [Import from Parse (Facebook)](http://www.orientechnologies.com/docs/last/orientdb-etl.wiki/Import-from-PARSE.html)
