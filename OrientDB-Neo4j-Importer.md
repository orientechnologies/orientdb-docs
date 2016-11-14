---
search:
   keywords: ['neo4j to orientdb importer', 'neo4j', 'import', 'migration']
---

# Neo4j to OrientDB Importer

The _Neo4j to OrientDB Importer_ is a tool that can help you importing in a quick way a Neo4j graph database into OrientDB.

Imported Neo4j items are:

- nodes
- relationships
- unique constraints
- indexes

_**Note:**_ The _Neo4j to OrientDB Importer_ is currently in **beta**.

>Neo4j and Cypher are registered trademark of Neo Technology, Inc.

## Supported Versions

Currently, the _Neo4j to OrientDB Importer_ supports, and has been tested with, the following versions:

- OrientDB: 2.2.x 
- Neo4j: 3.0.x


## Limitations

The following limitations apply:

* Currently only `local` migrations are allowed
* Schema limitations:
	* In case a node in Neo4j has multiple labels, only the first label is imported into OrientDB	
	* Neo4j Nodes with same Label but different case, e.g. LABEL and LAbel will be aggregated into a single OrientDB vertex `class`
	* Neo4j Relationship with same name but different case, e.g. relaTIONship and RELATIONSHIP will be aggregated into a single OrientDB edge `class`  
	* Migration of Neo4j's "existence" constraints (only available in the Neo4j's Enterprise Edition) is currently not implemented 


## Installation

The _Neo4j to OrientDB Importer_ is provided as an external plugin, as a `zip` or `tar.gz` archive.

Please download the plugin from maven central:

```
http://central.maven.org/maven2/com/orientechnologies/orientdb-neo4j-importer/VERSION/orientdb-neo4j-importer-VERSION.tar.gz
```

where _VERSION_ is your OrientDB version (≥ 2.2.12. Current version is 2.2.12rc1). Replace `tar.gz` with  `zip` for the `zip` archive.

To install the plugin, please unpack the archive on your OrientDB server directory. On Linux systems, to unpack the archive you can use a command similar to the following:

```
tar xfv orientdb-neo4j-importer-VERSION.tar.gz -C path_to_orientDB/ --strip-components=1 
```


## Migration Scenarios

A typical migration scenario consists of the following steps:

- A copy of the Neo4j's database graph directory (typically `graph.db`) is created into a safe place
- OrientDB is installed
- The _Neo4j to OrientDB Importer_ is installed
- The migration process is started from the command line, passing to the _Neo4j to OrientDB Importer_ the copy of the Neo4j's database directory created earlier
- OrientDB (embedded or server) is started and the newly imported graph database can be used

**Notes:** 

* Since currently only exclusive, `local`, connections are allowed, during the migration there must be no running servers on the Neo4j's database directory and on the target OrientDB's import directory.

* As an alternative of creating a copy of the Neo4j's database directory, and in case you can schedule a Neo4j shutdown, you can:
	* Shutdown your Neo4j Server
	* Start the migration by passing the original Neo4j's database directory to the _Neo4j to OrientDB Importer_ (a good practice is to create a back-up first)
 
  
## Usage

After Installation, the _Neo4j to OrientDB Importer_ can be launched using the provided `orientdb-neo4j-importer.sh` script (or `orientdb-neo4j-importer.bat` for Windows systems).


### Syntax
	OrientDB-Neo4j-Importer
		-neo4jlibdir <neo4jlibdir> (mandatory)
		-neo4jdbdir <neo4jdbdir> (mandatory)
		-odbdir <odbdir>
        -o true|false

Where:

* **neo4jlibdir** (mandatory option) is the full path to the Neo4j lib directory (e.g. `D:\neo4j\neo4j-community-3.0.6\lib`). On Windows systems, this parameter must be the first passed parameter. 

* **neo4jdbdir** (mandatory option) is the full path to the Neo4j’s graph database directory (e.g. `D:\neo4j\neo4j-community-3.0.6\data\databases\graph.db`).

* **odbdir** (optional) is the full path to a directory where the Neo4j database will be migrated. The directory will be created by the import tool. In case the directory exists already, the _Neo4j to OrientDB Importer_ will behave accordingly to the value of the option `o` (see below). The default value of `odbdir` is `$ORIENTDB_HOME/databases/neo4j_import`.  

* **o** (optional). If `true` the `odbdir` directory will be overwritten, if it exists. If `false` and the `odbdir` directory exists, a warning will be printed and the program will exit. The default value of `o` is `false`.


If the _Neo4j to OrientDB Importer_ is launched without parameters, it fails because **-neo4jlibdir** and **-neo4jdbdir** are mandatory.


### Example

A typical import command looks like the following (please adapt the value of the `-neo4jlibdir` and `-neo4jdbdir` parameters to your specific case): 

**Windows:**

```
orientdb-neo4j-importer.bat -neo4jlibdir="D:\neo4j\neo4j-community-3.0.6\lib" -neo4jdbdir="D:\neo4j\neo4j-community-3.0.6\data\databases\graph.db"
```

**Linux / Mac:**

```
./orientdb-neo4j-importer.sh -neo4jlibdir /mnt/d/neo4j/neo4j-community-3.0.6/lib -neo4jdbdir /mnt/d/neo4j/neo4j-community-3.0.6/data/databases/graph.db
```

## Migration Details

Internally, the _Neo4j to OrientDB Importer_ makes use of the Neo4j's `java` API to read the graph database from Neo4j and of the OrientDB's `java` API to store the graph into OrientDB.

The import consists of four phases:

* **Phase 1:** Initialization of the Neo4j and OrientDB servers
* **Phase 2:** Migration of nodes and relationships
* **Phase 3:** Schema migration
* **Phase 4:** Shutdown of the servers and summary info


### General Migration Details

The following are some general migration details that is good to keep in mind:

* During the import, OrientDB's [`WAL`](http://orientdb.com/docs/last/Configuration.html#storageusewal) and [`WAL_SYNC_ON_PAGE_FLUSH`](http://orientdb.com/docs/last/Configuration.html#storagewalsynconpageflush
) are disabled, and OrientDB is prepared for massive inserts (_OIntentMassiveInsert_).

* In case a node in Neo4j has no Label, it will be imported in OrientDB in the Class `GenericClassNeo4jConversion`.

* Original Neo4j `IDs` are stored as properties in the imported OrientDB vertices and edges (`Neo4jNodeID` for vertices and `Neo4jRelID` for edges). Such properties can be (manually) removed at the end of the import, if not needed.
 
* During the import, an OrientDB index is created on the property `Neo4jNodeID` for all imported vertex `classes` (node's Labels in Neo4j). This is to speed up vertices lookup during edge creation. The created indexes can be (manually) removed at the end of the import, if not needed.
 
* In case a Neo4j Relationship has the same name of a Neo4j Label, e.g. "RelationshipName", the _Neo4j to OrientDB Importer_ will import that relationship into OrientDB in the class `E_RelationshipName` (i.e. prefixing the Neo4j's `RelationshipType` with an `E_`).

* During the creation of properties in OrientDB, Neo4j `Char` data type is mapped to a `String` data type.


### Details on Schema Migration

The following are some schema-specific migration details that is good to keep in mind:

* If in Neo4j there are no constraints or indices, the imported OrientDB database is schemaless.

* If in Neo4j there are constraints or indexes, the imported OrientDB database is schema-hybrid (with some properties defined). In particular, for any constraint and index: 

	* The Neo4j property where the constraint or index is defined on, is determined
	
	* A corresponding property is created in OrientDB (hence the schema-hybrid mode)	 	

* If a Neo4j unique constraint is found, a corresponding unique index is created in OrientDB

* If a Neo4j index is found, a corresponding (not unique) OrientDB index is created


## Migration Log

During the migration, a log file is created.

The log can be found at `path_to_orientDB/log/orientdb-neo4j-importer.log`.


## Migration Tuning

The parameter `-XX:MaxDirectMemorySize=4g` is hardcoded inside the start scripts `orientdb-neo4j-importer.sh` and `orientdb-neo4j-importer.bat`.

Depending on the amount of available memory on your system, you may want to increase this value.


## Migration Monitoring

During the migration, for each imported Neo4j items (nodes, relationships, constraints and indexes) a completion percentage is written in the shell from where the import has been started, thus allowing to monitor progresses.

For large imports, a best practice is to monitor also the produced import log, using a program like `tail`, e.g.

```
tail -f -n 100 -f path_to_orientDB/log/orientdb-neo4j-importer.log
``` 

## Migration Troubleshooting

In case of problems, the details of the occurred errors are written in the migration log file. Please use this file to troubleshoot the migration.


## Connecting to the newly imported Database

After the migration process, you may start an OrientDB server using the `server.sh` or `server.bat` scripts.

You can connect to the newly imported database through [Studio](Studio-Home-page.md) or the [Console](Console-Commands.md) using the OrientDB's default database users, e.g. using the user _admin_ and password _admin_.

Please secure your database by removing the default users, if you don't need them, or by creating new users.

For further information on using OrientDB, please refer to the [Getting Started Guide](Tutorial-Introduction-to-the-NoSQL-world.md).
 

## Migration Example

A complete example of a migration from Neo4j to OrientDB using the _Neo4j to OrientDB Importer_ can be found in the section [Tutorial: Importing the *northwind* Database from Neo4j](Tutorial-Importing-the-northwind-Database-from-Neo4j.md).