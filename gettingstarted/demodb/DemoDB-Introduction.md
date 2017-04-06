
# Introduction

The demo database can help you understand better OrientDB features and capabilities and replaces the old demo database `GratefulDeadConcerts` included in version 2.2 and previous ones. 

**Note:** Random-generated data is used in the `demodb`, including data used for _Emails_, _Names_, _Surnames_, _Phone Numbers_ and _Reviews_.


## Version

`demodb` has a version that, in general, is not linked to the Server version you are running. You can check the version of the `demodb` included in your distribution by executing the following SQL query:

```sql
SELECT `Version` FROM `DBInfo`;
```

Current version is {{book.demoDBVersion_screenshots}}.


## Location

The demo database is located in the `databases` directory under your `$ORIENTDB_HOME` (e.g. `D:\orientdb\orientdb-community-3.0.0\databases\demodb`.


## Connecting to the Demo Database

It is possible to connect to `demodb` using the three standard OrientDB Users:

- `read` / `read`
- `write` / `write`
- `admin` / `admin`


## Using the Demo Database with OrientDB 2.2.x

The demo database can be easily loaded into OrientDB 2.2.x using the Studio's _"Import a public database"_ feature.

Alternatively, it is possible to import it via an SQL script that includes the set of instructions needed to recreate the data model as well as all the records (vertices, edges, and documents). 
