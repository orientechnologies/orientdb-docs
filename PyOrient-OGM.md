# PyOrient OGM

Where the PyOrient Client is a wrapper for the [Binary Protocol](Network-Binary-Protocol.md), the Object-Graph Mapper provides a higher-level object-oriented Pythonic interface for Graph databases in OrientDB.  It is comparable to the use of ORM's with Relational databases.

The purpose of the OGM is to make interactions with large and complex Graph databases more understandable and easier to maintain.  It bridges the gap between higher level object-oriented concepts in your application and the vertices and edges in your database.

## Understanding the OGM

What the OGM does is that it maps Python objects to classes and properties in OrientDB.  Your application can then operate on objects as it would normally, with PyOrient operating on the database in the background.

- When you have an existing OrientDB database schema, the PyOrient OGM can map the schema classes to Python classes in your application.

- When you have an existing Python application, the PyOrient OGM can build a database schema in OrientDB from the Python classes in your application.

>Whichever method you choose to adopt, once you have built the database and mapped its schema to your Python classes, you can execute queries against it.  You can do this using the OrientDB console or from within your application.
>
>Currently, the mapper does not support [`TRAVERSE`](SQL-Traverse.md) and it's support for Gremlin is functional, but limited.

## Using the OGM

- [**Database Connections**](PyOrient-OGM-Connection.md)
- [**Working with Schemas**](PyOrient-OGM-Schemas.md)
- [**Working with Brokers**](PyOrient-OGM-Brokers.md)
- [**Batch Transactions**](PyOrient-OGM-Batch.md)
- [**Scripting**](PyOrient-OGM-Scripts.md)

