# ETL - Loaders

**Loader** components are the last part of the ETL process responsible of the saving of records.

## Available Loaders

|  |  |  |  |
|-----|-----|-----|-----|
|[Output](Loader.md#output)|[OrientDB](Loader.md#orientdb)| | |

-----

### Output
It's the default Loader. It prints the transformation result to the console output.

- Component name: **output**
- Accepted input classes: [**Object**]

-----

### OrientDB
Loads record and vertices into a OrientDB database.

- Component name: **orientdb**
- Accepted input classes: [**ODocument**, **OrientVertex**]

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|dbURL|Database URL|string|true|-|
|dbUser|User Name|string|false|admin|
|dbPassword|User Password|string|false|admin|
|dbAutoCreate|If the database not exists, create it automatically|boolean|false|true|
|tx|Use [transactions](Transactions.md) or not|boolean|false|false|
|wal|Use WAL (Write Ahead Logging). Disable WAL to achieve better performances|boolean|false|true|
|batchCommit|With [transactions](Transactions.md) enabled, commit every X entries. Use this to avoid having one huge transaction in memory|integer|false|0|
|dbType|Database type, between 'graph' or 'document'|string|false|document|
|indexes|Contains the indexes used on ETL process. Before starting any declared index not present in database will be created automatically. Index configuration must have "type", "class" and "fields"|inner document|false|-|

#### Example
Below an example of configuration to load in a OrientDB database called "dbpedia" in directory "/temp/databases" open using "plocal" protocol and used as "graph". The loading is transactional and commits the transaction every 1,000 inserts. To lookup vertices has been create the index against the property string "URI" in base vertex "V" class. The index is unique.

```json
"orientdb": {
      "dbURL": "plocal:/temp/databases/dbpedia",
      "dbUser": "importer",
      "dbPassword": "IMP",
      "dbAutoCreate": true,
      "tx": false,
      "batchCommit": 1000,
      "wal" : false,
      "dbType": "graph",
      "indexes": [{"class":"V", "fields":["URI:string"], "type":"UNIQUE" }]
    }
```

-----
