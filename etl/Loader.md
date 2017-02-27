---
search:
   keywords: ['etl', 'ETL', 'loader']
---

<!-- proofread 2015-12-11 SAM -->
# ETL - Loaders

When the ETL module executes, Loaders handle the saving of records.  They run at the last stage of the process.  The ETL module in OrientDB supports the following loaders:

- [Output](#output-loader)
- [OrientDB](#orientdb-loader)

## Output Loader

When the ETL module runs the Output Loader, it prints the transformer results to the console output.  This is the loader that runs by default.

- Component name: **output**
- Accepted input classes: [**Object**]


## OrientDB Loader

When the ETL module runs the OrientDB Loader, it loads the records and vertices from the transformers into the OrientDB database.

- Component name: `orientdb`
- Accepted input classes: `[ ODocument, OrientVertex ]`

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"dbURL"` | Defines the database URL. | string | yes | |
| `"dbUser"` | Defines the user name. | string | | `admin` |
| `"dbPassword"` | Defines the user password. | string | | `admin` |
| `"serverUser"` | Defines the server administrator user name, usually `root` | string | |  |
| `"serverPassword"` | Defines the server administrator user password that is provided at server startup | string | |  |
| `"dbAutoCreate"` | Defines whether it automatically creates the database, in the event that it doesn't exist already. | boolean | | `true` |
| `"dbAutoCreateProperties"` | Defnes whether it automatically creates properties in the schema. | boolean | | `false` |
| `"dbAutoDropIfExists"` | Defines whether it automatically drops the database if it exists already. | boolean | | `false` |
| `"tx"` | Defines whether it uses [transactions](../internals/Transactions.md) | boolean | | `false` |
| `"txUseLog"` | Defines whether it uses log in transactions. | boolean | | |
| `"wal"` | Defines whether it uses write ahead logging.  Disable to achieve better performance. | boolean | | `true` |
| `"batchCommit"` | When using transactions, defines the batch of entries it commits.  Helps avoid having one large transaction in memory. | integer | | `0` |
| `"dbType"` | Defines the database type: `graph` or `document`. | string | | `document` |
| `"class"` | Defines the class to use in storing new record. | string | | |
| `"cluster"` | Defines the cluster in which to store the new record. | string | | |
| `"classes"` | Defines whether it creates [classes](#classes), if not defined already in the database. | inner document | | |
| `"indexes"` | Defines [indexes](#indexes) to use on the ETL process.  Before starting, it creates any declared indexes not present in the database.  Indexes must have `"type"`, `"class"` and `"fields"`. | inner document | | |
| `"useLightweightEdges"` | Defines whether it changes the default setting for [Lightweight Edges](../Lightweight-Edges.md). | boolean | | `false` |
| `"standardELementConstraints"` | Defines whether it changes the default setting for TinkerPop BLueprint constraints.  Value cannot be null and you cannot use `id` as a property name. | boolean |  | `true` |

For the `"txUseLog"` parameter, when WAL is disabled you can still achieve reliable transactions through this parameter.  You may find it useful to group many operations into a batch, such as [`CREATE EDGE`](../sql/SQL-Create-Edge.md).
If `"dbAutoCreate"` or `"dbAutoDropIfExists"` are set to true and remote connection is used,  `serverUsername` and `serverPassword` must be provided. Usually the server administrator user name is `root` and  the password is provided at the startup of the OrientDB server.  


### Classes

When using the `"classes"` parameter, it defines an inner document that contains additional configuration variables.

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"name"` | Defines the class name. | string | yes | |
| `"extends"` | Defines the super-class name. | string | | |
| `"clusters"` | Defines the number of cluster to create under the class. | integer | | `1` |

>**NOTE**: The `"clusters"` parameter was introduced in version 2.1.

### Indexes

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"name"` | Defines the index name. | string | | |
| `"class"` | Defines the class name in which to create the index. | string | yes | |
| `"type"` | Defines the index type. | string | yes | |
| `"fields"` | Defines an array of fields to index.  To specify the field type, use the syntax: `<field>.<type>`. | string | yes | |
| `"metadata"` | Defines additional index metadata. | string | | |


## Examples

Configuration to load data into the database `dbpedia` on OrientDB, in the directory `/temp/databases` using the PLocal protocol and a Graph database.  The load is transactional, performing commits in thousand insert batches.  It creates two lookup vertices with indexes against the property string `URI` in the base vertex class `V`.  The index is unique.

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
      "classes": [
        {"name":"Person", "extends": "V" },
        {"name":"Customer", "extends": "Person", "clusters":8 }
      ],
      "indexes": [
        {"class":"V", "fields":["URI:string"], "type":"UNIQUE" },
        {"class":"Person", "fields":["town:string"], "type":"NOTUNIQUE" ,
            metadata : { "ignoreNullValues" : false }
        }
      ]
    }
```
