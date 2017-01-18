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

>Neo4j and Cypher are registered trademark of Neo Technology, Inc.


## Supported Versions

Currently, the _Neo4j to OrientDB Importer_ supports, and has been tested with, the following versions:

- OrientDB: 2.2.x 
- Neo4j: 3.0.x


## Limitations

The following limitations apply:

* Currently only `local` migrations are allowed.
* Schema limitations:
	* In case a node in Neo4j has multiple _Labels_, it will be imported into a single OrientDB `Class` (_"MultipleLabelNeo4jConversion"_). 
		* Note that the information about the original set of Labels is not lost but stored into an internal property of the imported vertex (_"Neo4jLabelList"_). As a result, it will be possible to query nodes with a specific Neo4j _Label_. Note also that the nodes imported into the single class _"MultipleLabelNeo4jConversion"_ can then be moved to other `Classes`, according to your specific needs, using the [MOVE VERTEX](SQL-Move-Vertex.md) command. For more information, please refer to [this](OrientDB-Neo4j-Importer.md#querying-nodes-by-original-neo4j-labels) Section.
	* Neo4j Nodes with same _Label_ but different case, e.g. _LABEL_ and _LAbel_ will be aggregated into a single OrientDB vertex `Class`.
	* Neo4j Relationship with same name but different case, e.g. _relaTIONship_ and _RELATIONSHIP_ will be aggregated into a single OrientDB edge `Class`  
	* Migration of Neo4j's _"existence"_ constraints (only available in the Neo4j's Enterprise Edition) is currently not implemented. 


## Installation

The _Neo4j to OrientDB Importer_ is provided as an external plugin for the OrientDB Server, and is available as a `zip` or `tar.gz` archive.

Please download the plugin from maven central:

<pre><code class="lang-sh">http://central.maven.org/maven2/com/orientechnologies/orientdb-neo4j-importer/{{book.lastGA}}/orientdb-neo4j-importer-{{book.lastGA}}.tar.gz</code></pre>

Replace `tar.gz` with  `zip` for the `zip` archive.

To install the plugin, please unpack the archive on your OrientDB server directory (please make sure that the version of your OrientDB server and the version of the Neo4j to OrientDB Importer are the same. Upgrade your OrientDB server, if necessary). On Linux systems, to unpack the archive you can use a command like the following:

<pre><code class="lang-sh">tar xfv orientdb-neo4j-importer-{{book.lastGA}}.tar.gz -C path_to_orientDB/ --strip-components=1 </code></pre>


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
		[-odbdir <odbdir>]
        [-o true|false]

Where:

* **neo4jlibdir** (mandatory option) is the full path to the Neo4j lib directory (e.g. `D:\neo4j\neo4j-community-3.0.7\lib`). On Windows systems, this parameter must be the first passed parameter. 

* **neo4jdbdir** (mandatory option) is the full path to the Neo4j’s graph database directory (e.g. `D:\neo4j\neo4j-community-3.0.7\data\databases\graph.db`).

* **odbdir** (optional) is the full path to a directory where the Neo4j database will be migrated. The directory will be created by the import tool. In case the directory exists already, the _Neo4j to OrientDB Importer_ will behave accordingly to the value of the option `o` (see below). The default value of `odbdir` is `$ORIENTDB_HOME/databases/neo4j_import`.  

* **o** (optional). If `true` the `odbdir` directory will be overwritten, if it exists. If `false` and the `odbdir` directory exists, a warning will be printed and the program will exit. The default value of `o` is `false`.

If the _Neo4j to OrientDB Importer_ is launched without parameters, it fails because **-neo4jlibdir** and **-neo4jdbdir** are mandatory.


### Example

A typical import command looks like the following (please adapt the value of the `-neo4jlibdir` and `-neo4jdbdir` parameters to your specific case): 

**Windows:**

```
orientdb-neo4j-importer.bat -neo4jlibdir="D:\neo4j\neo4j-community-3.0.7\lib" -neo4jdbdir="D:\neo4j\neo4j-community-3.0.7\data\databases\graph.db"
```

**Linux / Mac:**

```
./orientdb-neo4j-importer.sh -neo4jlibdir /mnt/d/neo4j/neo4j-community-3.0.7/lib -neo4jdbdir /mnt/d/neo4j/neo4j-community-3.0.7/data/databases/graph.db
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

* In case a node in Neo4j has no _Label_, it will be imported in OrientDB into the Class _"GenericClassNeo4jConversion"_.

* Starting from version 2.2.14, in case a node in Neo4j has multiple _Labels_, it will be imported into the `Class` _"MultipleLabelNeo4jConversion"_. Before 2.2.14, only the first _Label_ was imported.

* List of original Neo4j _Labels_ are stored as properties in the imported OrientDB vertices (property: _"Neo4jLabelList"_). 

* During the import, a not unique index is created on the property _"Neo4jLabelList"_. This allows you to query by _Label_ even over nodes migrated into the single `Class` _"MultipleLabelNeo4jConversion"_, using queries like: 
`SELECT FROM V WHERE Neo4jLabelList CONTAINS 'your_label_here'` or the equivalent with the [MATCH](SQL-Match.md) syntax: `MATCH {class: V, as: your_alias, where: (Neo4jLabelList CONTAINS 'your_label'} RETURN your_alias`.

* Original Neo4j `IDs` are stored as properties in the imported OrientDB vertices and edges (`Neo4jNodeID` for vertices and `Neo4jRelID` for edges). Such properties can be (manually) removed at the end of the import, if not needed.
 
* During the import, an OrientDB index is created on the property `Neo4jNodeID` for all imported vertex `classes` (node's _Labels_ in Neo4j). This is to speed up vertices lookup during edge creation. The created indexes can be (manually) removed at the end of the import, if not needed.
 
* In case a Neo4j Relationship has the same name of a Neo4j _Label_, e.g. _"RelationshipName"_, the _Neo4j to OrientDB Importer_ will import that relationship into OrientDB in the class `E_RelationshipName` (i.e. prefixing the Neo4j's `RelationshipType` with an `E_`).

* During the creation of properties in OrientDB, Neo4j `Char` data type is mapped to a `String` data type.


### Details on Schema Migration

The following are some schema-specific migration details that is good to keep in mind:

* If in Neo4j there are no constraints or indexes, and if we exclude the properties and indexes created for internal purposes (`Neo4jNodeID`, `Neo4jRelID`, `Neo4jLabelList` and corresponding indexes), the imported OrientDB database is schemaless.

* If in Neo4j there are constraints or indexes, the imported OrientDB database is schema-hybrid (with some properties defined). In particular, for any constraint and index: 

	* The Neo4j property where the constraint or index is defined on, is determined.
	
	* A corresponding property is created in OrientDB (hence the schema-hybrid mode).	 	

* If a Neo4j unique constraint is found, a corresponding unique index is created in OrientDB

	* In case the creation of the unique index fails, a not unique index will be created. Note: this scenario can happen, by design, when migrating nodes that have multiple _Labels_, as they are imported into a single vertex `Class`).

* If a Neo4j index is found, a corresponding (not unique) OrientDB index is created.


## Migration Best Practices

Below some migration best practices.

1. Check if you are using _Labels_ with same name but different case, e.g. _LABEL_ and _LAbel_ and if you really need them. If the correct _Label_ is _Label_, change _LABEL_ and _LAbel_ to _Label_ in the original Neo4j database before the import. If you really cannot change them, be aware that with the current version of the Neo4j to OrientDB Importer such nodes will be aggregated into a single OrientDB vertex `Class`.

2. Check if you are using relationships with same name but different case, e.g. _relaTIONship_ and _RELATIONSHIP_ and if you really need them. If the correct relationship is _Relationship_, change _relaTIONship_ and _RELATIONSHIP_ to _Relationship_ before the import. If you really cannot change them, be aware that with the current version of the Neo4j to OrientDB Importer such relationships will be aggregated into a single OrientDB edge `Class`.

3. Check your constraints and indexes before starting the import. Sometime you have more constraints or indexes than needed, e.g. old ones that you created on _Labels_ that you are not using anymore. These constraints will be migrated as well, so a best practice is to check that you have defined, in Neo4j, only those that you really want to import. To check constraints and indexes in Neo4j, you can type `:schema` in the Browser and then click on the "play" icon. Please delete the not needed items.

4. Check if you are using nodes with multiple _Labels_, and if you really need more than one _Label_ on them. Be aware that with current version of the Neo4j to OrientDB Importer such nodes with multiple _Labels_ will be imported into a single OrientDB `Class` ("_MultipleLabelNeo4jConversion_").


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
 

## Query Strategies

This section includes a few strategies that you can use to query your data after the import.

As first thing, please be aware that in OrientDB you can query your data using both [SQL](http://orientdb.com/docs/master/Commands.html) or pattern matching. In case you are familiar with Neo4j's Cypher query language, it may be more easy for you to use our pattern matching (see our [MATCH](http://orientdb.com/docs/master/SQL-Match.html) syntax for more details). However, keep in mind that depending on your specific use case, our SQL can be of great help.


### Counting all nodes

To count all nodes (vertices):

<table>
<tr>
    <th width="50%">Neo4j's Cypher</th>
    <th width="50%">OrientDB's SQL</th>
</tr>
<tr>
<td>
<pre>
MATCH (n) RETURN count(n)
</pre>
</td>
<td>
<pre>
SELECT COUNT(*) FROM V
</pre>
</td>
</tr>
</table>
 

### Counting all relationships

To count all relationships (edges):

<table>
<tr>
    <th width="50%">Neo4j's Cypher</th>
    <th width="50%">OrientDB's SQL</th>
</tr>
<tr>
<td>
<pre>
MATCH ()-->() RETURN count(*)
</pre>
</td>
<td>
<pre>
SELECT COUNT(*) FROM E 
</pre>
</td>
</tr>
</table>   


### Querying nodes by original Neo4j ID

If you would like to query nodes by their original Neo4j Node ID, you can use the property _Neo4jNodeID_, which is created automatically for you during the import, and indexed as well.

To query a node that belongs to a specific `Class` with name _ClassName_, you can execute a query like:

```
SELECT FROM ClassName WHERE Neo4jNodeID = your_id_here
```

To query a node regardless of the `Class` where it has been included in, you can use a query like:

```
SELECT FROM V WHERE Neo4jNodeID = your_id_here
```

### Querying relationships by original Neo4j ID

The strategy to query relationships by their original Neo4j Relationship ID, will be improved in the next hotfix (see GitHub [Issue #9](https://github.com/orientechnologies/orientdb-neo4j-importer/issues/9), which also includes a workaround).


### Querying nodes by original Neo4j Labels

In case the original nodes have just one _Label_, they will be migrated in OrientDB into a `Class` that has name equals to the Neo4j's _Label_ name. In this simple case, to query nodes by _Label_ you can execute a query like the following: 

<table>
<tr>
    <th width="50%">Neo4j's Cypher</th>
    <th width="50%">OrientDB's SQL</th>
</tr>
<tr>
<td>
<pre>
MATCH (n:LabelName) RETURN n
</pre>
</td>
<td>
<pre>
SELECT FROM LabelName
</pre>

or using our MATCH syntax:

<pre>
MATCH {class: LabelName, as: n} RETURN n
</pre>
</td>
</tr>
</table>  

More generally speaking, since the original Neo4j _Label_ is stored inside the property _Neo4jLabelList_, to query imported nodes (vertices) using their original Neo4j _Label_, you can use queries like the following:

<table>
<tr>
    <th width="50%">Neo4j's Cypher</th>
    <th width="50%">OrientDB's SQL</th>
</tr>
<tr>
<td>
<pre>
MATCH (n:LabelName) RETURN n
</pre>
</td>
<td>
<pre>
SELECT * FROM V WHERE Neo4jLabelList CONTAINS 'LabelName'
</pre>

or using our MATCH syntax:

<pre>
MATCH {class: V, as: n, where: (Neo4jLabelList CONTAINS 'LabelName')} RETURN n
</pre>
</td>
</tr>
</table>  

This is, in particular, the strategy that must be followed in case the original Neo4j's nodes have multiple _Labels_ (and are hence migrated into the single OrientDB `Class` _MultipleLabelNeo4jConversion_). 

Note that the property _Neo4jLabelList_ has an index on it.


## Migration Example

A complete example of a migration from Neo4j to OrientDB using the _Neo4j to OrientDB Importer_ can be found in the section [Tutorial: Importing the *northwind* Database from Neo4j](Tutorial-Importing-the-northwind-Database-from-Neo4j.md).


## Roadmap

A list of prioritized enhancements for the Neo4j to OrientDB Importer, along with some other project information can be found [here](https://github.com/orientechnologies/orientdb-neo4j-importer/projects/1).


## FAQ

**1. In case original nodes in Neo4j have multiple _Labels_, they are imported into a single OrientDB vertex Class. Depending on the specific use case, after the migration, it may be useful to manually move vertices to other Classes. How can this be done?**

First, please note that there is an open [enhancement request](https://github.com/orientechnologies/orientdb-neo4j-importer/issues/8) about having a customized mapping between Neo4j _Labels_ and OrientDB `Classes`. Until it is implemented, a possible strategy to quickly move vertices into other `Classes` is to use the [`MOVE VERTEX`](SQL-Move-Vertex.md) syntax. 

The following are the steps to follow:

**A** - Create the `Classes` where you want to move the vertices.

When creating the `Classes`, please keep in mind the following:

- Define the following properties: 
	- _Neo4jNodeID_ of type _LONG_ 
	- _Neo4jLabelList_ of type _EmbeddedList String_

**Example:**

```
CREATE CLASS YourNewClassHere EXTENDS V
CREATE PROPERTY YourNewClassHere.Neo4jNodeID LONG 
CREATE PROPERTY YourNewClassHere.Neo4jLabelList EMBEDDEDLIST STRING 
```

**B** - Select all vertices that have a specific Neo4j _Label_, and then move them to your new `Class`. To do this you can use a query like:

```
MOVE VERTEX (
  SELECT FROM MultipleLabelNeo4jConversion 
    WHERE Neo4jLabelList CONTAINS 'Your Neo4j Label here'
  ) 
TO CLASS:YourNewClassHere BATCH 10000
```

(use a batch size appropriate to your specific case).

**C** - Create the following indexes in your new `Classes`:

- A unique index on the property _Neo4jNodeID_
- A not unique index on the property _Neo4jLabelList_

**Important:** creation of the indexes above is crucial in case you will want to query vertices using their original Neo4j node _IDs_ or _Labels_.

**Example:**

```
CREATE INDEX YourNewClassHere.Neo4jNodeID ON YourNewClassHere(Neo4jNodeID) UNIQUE
CREATE INDEX YourNewClassHere.Neo4jLabelList ON YourNewClassHere(Neo4jLabelList) NOTUNIQUE
```


**2. Not all constraints have been imported. Why?**

By design, there are certain cases where not all the constraints can be imported. It may be that you are in one of these cases. When nodes are aggregated into a single `Class` (either because that node has multiple _Labels_ or because there are _Labels_ with the same name but different case, e.g. _LABEL_ and _LAbel_) not all constraints can be imported: the creation of unique indices in OrientDB will probably fail; as a workaround the Importer will try to create not unique indexes, but when aggregating nodes into a single `Class`, number of created constraints will be probably less than number of constraints in Neo4j, even after the creation of the not unique indexes. This in general may or may not be a problem depending on your specific case. Please feel free to open an [issue](https://github.com/orientechnologies/orientdb-neo4j-importer/issues) if you believe you incurred into a bug.


