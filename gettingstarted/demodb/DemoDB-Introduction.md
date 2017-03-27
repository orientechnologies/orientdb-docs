
## Introduction

The demo database can help you understand better OrientDB features and capabilities and replace the old demo database `GratefulDeadConcerts`. 

_Note:_ Random-generated data is used in the `demodb`, including data used for Emails, Names, Surnames, Phone Numbers and Reviews.

This Section introduces the `demodb` database, its Data Model, and includes some queries that is possible to execute on it.


### Version

`demodb` has a version that is in general not linked to the Server version you are running. You can check version of your `demodb` by executing the following SQL query:

```sql
SELECT `Version` FROM `DBInfo`;
```

### Location

The demo database is located in the `databases` directory under `$ORIENTDB_HOME` (e.g. `D:\orientdb\orientdb-community-3.0.0\databases\demodb`.


### Connecting to the Demo Database

It is possible to connect to `demodb` using the three standard OrientDB Users:

- `read` / `read`
- `write` / `write`
- `admin` / `admin`


### Using the Demo Database with version 2.2.x

The demo database can be easily loaded into OrientDB 2.2.x using the Studio's "Import a public database" feature.

Alternatively, it is possible to import it via an SQL script that includes the set of instructions needed to recreate the data model as well as all the records (vertices, edges, documents). 
