---
search:
   keywords: ['orientdb neo4j import', 'neo4j', 'import']
---

# OrientDB's Neo4j Importer

The OrientDB's Neo4j Importer is a tool that can help you importing in a quick way a Neo4j graph database into OrientDB.

Imported Neo4j items are:

- nodes
- relationships
- unique constraints
- indexes

_Note:_ The OrientDB's Neo4j Importer tool is currently in **beta**.

>Neo4j and Cypher are registered trademark of Neo Technology, Inc.

## Supported Versions

Currently, the OrientDB's Neo4j Importer tool supports, and has been tested with, the following versions:

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

The OrientDB's Neo4j Importer tool is provided as an external plugin, as a `zip` or `tar.gz` archive.

To install it, please unpack the archive on your OrientDB server directory. On Linux systems, to unpack the archive you can use a command similar to the following:

```
tar xfv orientdb-neo4j-importer-VERSION.tar.gz -C path_to_orientDB/ --strip-components=1 
```


## Migration Scenarios

A typical migration scenario consists of the following steps:

- A copy of the Neo4j's database graph directory (typically `graph.db`) is created into a safe place
- OrientDB is installed
- The OrientDB's Neo4j Importer tool is installed
- The migration process is started from the command line, passing to the OrientDB's Neo4j Importer tool the copy of the Neo4j's database directory created earlier
- OrientDB (embedded or server) is started and the newly imported graph database can be used

**Notes:** 

* Since currently only exclusive, `local`, connections are allowed, during the migration there must be no running servers on the Neo4j's database directory and on the target OrientDB's import directory.

* As an alternative of creating a copy of the Neo4j's database directory, and in case you can schedule a Neo4j shutdown, you can:
	* Shutdown your Neo4j Server
	* Start the migration by passing the original Neo4j's database directory to the OrientDB's Neo4j Importer tool (a good practice is to create a back-up first)
 
  
## Usage

After Installation, the OrientDB's Neo4j Importer tool can be launched using the provided `orientdb-neo4j-importer.sh` script (or `orientdb-neo4j-importer.bat` for Windows systems).


### Syntax
	OrientDB-Neo4j-Importer
		-neo4jlibdir <neo4jlibdir> (mandatory)
		-neo4jdbdir <neo4jdbdir> (mandatory)
		-odbdir <odbdir>
        -o true|false

Where:

* **neo4jlibdir** (mandatory option) is the full path to the Neo4j lib directory (e.g. `D:\neo4j\neo4j-community-3.0.6\lib`). On Windows systems, this parameter must be the first passed parameter. 

* **neo4jdbdir** (mandatory option) is the full path to the Neo4j’s graph database directory (e.g. `D:\neo4j\neo4j-community-3.0.6\data\databases\graph.db`).

* **odbdir** (optional) is the full path to a directory where the Neo4j database will be migrated. The directory will be created by the import tool. In case the directory exists already, the OrientDB's Neo4j Importer tool will behave accordingly to the value of the option `o` (see below). The default value of `odbdir` is `$ORIENTDB_HOME/databases/neo4j_import`.  

* **o** (optional). If `true` the `odbdir` directory will be overwritten, if it exists. If `false` and the `odbdir` directory exists, a warning will be printed and the program will exit. The default value of `o` is `false`.


If the OrientDB's Neo4j Importer Tool is launched without parameters, it fails because **-neo4jlibdir** and **-neo4jdbdir** are mandatory.


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

Internally, the OrientDB's Neo4j Importer tool makes use of the Neo4j's `java` API to read the graph database from Neo4j and of the OrientDB's `java` API to store the graph into OrientDB.

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
 
* In case a Neo4j Relationship has the same name of a Neo4j Label, e.g. "RelationshipName", the OrientDB's Neo4j Importer tool will import that relationship into OrientDB in the class `E_RelationshipName` (i.e. prefixing the Neo4j's `RelationshipType` with an `E_`).

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

# Migration Tuning

The parameter `-XX:MaxDirectMemorySize=4g` is hardcoded inside the start scripts `orientdb-neo4j-importer.sh` and `orientdb-neo4j-importer.bat`.


# Migration Monitoring

During the migration, for each imported Neo4j items (nodes, relationships, constraints and indexes) a completion percentage is written in the shell from where the import has been started, thus allowing to monitor progresses.

For large imports, a best practice is to monitor also the produced import log, using a program like `tail`, e.g.

```
tail -f -n 100 -f path_to_orientDB/log/orientdb-neo4j-importer.log
``` 

# Migration Troubleshooting

In case of problems, the details of the occurred errors are written in the migration log file. Please use this file to troubleshoot the migration.


# Migration Example

The following is the output that is written by the OrientDB's Neo4j Importer tool when migrating the example Neo4j's database `northwind`:

```
./orientdb-neo4j-importer.sh -neo4jlibdir /mnt/d/neo4j/neo4j-community-3.0.6/lib -neo4jdbdir /mnt/d/neo4j/neo4j-community-3.0.6/data/databases/graph.db

OrientDB's Neo4j Importer v.2.2.12-SNAPSHOT - Copyrights (c) 2016 OrientDB LTD

WARNING: 'o' option not found. Defaulting to 'false'.

WARNING: 'odbdir' option not found. Defaulting to '/mnt/d/orientdb/orientdb-community-2.2.12/databases/neo4j_import'.

Please make sure that there are no running servers on:
  '/mnt/d/neo4j/neo4j-community-3.0.6/data/databases/graph.db' (Neo4j)
and:
  '/mnt/d/orientdb/orientdb-community-2.2.12/databases/neo4j_import' (OrientDB)

Initializing Neo4j...Done

Initializing OrientDB...Done

Importing Neo4j database:
  '/mnt/d/neo4j/neo4j-community-3.0.6/data/databases/graph.db'
into OrientDB database:
  '/mnt/d/orientdb/orientdb-community-2.2.12/databases/neo4j_import'

Getting all Nodes from Neo4j and creating corresponding Vertices in OrientDB...
  1035 OrientDB Vertices have been created (100% done)
Done

Creating internal Indices on property 'Neo4jNodeID' on all OrientDB Vertices Classes...
  5 OrientDB Indices have been created (100% done)
Done

Getting all Relationships from Neo4j and creating corresponding Edges in OrientDB...
  3139 OrientDB Edges have been created (100% done)
Done

Getting Constraints from Neo4j and creating corresponding ones in OrientDB...

Done

Getting Indices from Neo4j and creating corresponding ones in OrientDB...
  5 OrientDB Indices have been created (100% done)
Done

Import completed!

Shutting down OrientDB...Done
Shutting down Neo4j...Done

===============
Import Summary:
===============

- Found Neo4j Nodes                                                        : 1035
-- With at least one Label                                                 :  1035
--- With multiple Labels                                                   :   0
-- Without Labels                                                          :  0
- Imported OrientDB Vertices                                               : 1035 (100%)

- Found Neo4j Relationships                                                : 3139
- Imported OrientDB Edges                                                  : 3139 (100%)

- Found Neo4j Constraints                                                  : 0
- Imported OrientDB Constraints (Indices created)                          : 0

- Found Neo4j (non-constraint) Indices                                     : 5
- Imported OrientDB Indices                                                : 5 (100%)

- Additional created Indices (on vertex properties 'Neo4jNodeID')          : 5

- Total Import time:                                                       : 127 seconds
-- Initialization time                                                     :  73 seconds
-- Time to Import Nodes                                                    :  14 seconds (71,8 nodes/sec)
-- Time to Import Relationships                                            :  23 seconds (136,73 rels/sec)
-- Time to Import Constraints and Indices                                  :  4 seconds (1,39 indices/sec)
-- Time to create internal Indices (on vertex properties 'Neo4jNodeID')    :  8 seconds (0,62 indices/sec)
```
