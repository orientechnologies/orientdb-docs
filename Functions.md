---
search:
   keywords: ['API', 'function', 'stored procedures']
---

# Functions

This feature allows you to define custom executable units of code that takes parameters from the database or query and return a modified result-set.


>**NOTE**: This guide refers to the last available release of OrientDB. For past revisions look at [Compatibility](Functions.md#wiki-compatibility).

## Understanding Functions

There are times when you may need to perform some operation or use some feature that is simply not available in OrientDB.  While you can develop workarounds at the application layer, you'll generally see better performance if you can move this logic to teh database layer.  Relational databases solve this issue with Stored Procedures, which allow users to define custom code in what is often a vendor-specific programming language.  OrientDB solves this issue with Functions.

OrientDB Functions are executable units of code.  They allow you to use the Functional programming paradigm to develop custom features to better support your applications and infrastructure.

- **Persistent** Functions are persistent.  They are stored on the database and can be called by any client.
- **Multiple Language Support** Functions support multiple languages.  Currently, you can write them in OrientDB SQL or JavaScript.  Support for Ruby, Scala, Java and other languages is currently in development.
- **Multiple Execution Support** OrientDB can execute Functions through SQL, Java, REST and Studio.
- **Recursion** Functions support 
- **Mapping** Functions automatically map parameters by position and name.
- **Extensibilty** OrientDB Plugins can inject new objects for Functions to use.



>The [OrientDB SQL](SQL.md) dialect supports many functions written in the native language.  To get better performance, you can write your own native functions in the Java language and register them to the engine. 
>
>For more information, see [Custom Functions in Java](SQL-Functions.md#cutom-functions-in-java).


## Compatibility

### 1.5.0 and before

OrientDB binds the following variables:
- `db`, that is the current document database instance
- `gdb`, that is the current graph database instance
