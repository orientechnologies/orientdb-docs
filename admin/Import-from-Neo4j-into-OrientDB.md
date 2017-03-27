---
search:
   keywords: ['import', 'Neo4j', 'migration']
---

# Import from Neo4j

Neo4j is an open-source graph database that queries and manipulates data using its own Cypher Query Language.

>For more information on the differences between Neo4j and OrientDB, please refer to the [OrientDB vs. Neo4j](http://orientdb.com/orientdb-vs-neo4j/) page.

>Neo4j and Cypher are registered trademark of Neo Technology, Inc. 


## Migration Strategies

Importing data from Neo4j into OrientDB is a straightforward process.

To migrate, please choose one of the following strategies:

1. **Use the _Neo4j to OrientDB Importer_**
	* Starting from OrientDB version 2.2, this is the preferred way to migrate from Neo4j, especially for large and complex datasets. The _Neo4j to OrientDB Importer_ allows you to migrate Neo4j's nodes, relationships, unique constraints and indexes. For more details, please refer to the [Neo4j to OrientDB Importer](../orientdb-neo4j-importer/README.md) section	
1. **Use GraphML**
	* GraphML is an XML-based file format for graphs. For more details, please refer to the section [Import from Neo4j using GraphML](Import-from-Neo4j-using-GraphML.md)

**Note:** if your data is in CSV format, you can migrate to OrientDB using the [OrientDB's ETL](../etl/ETL-Introduction.md) tool.
	

