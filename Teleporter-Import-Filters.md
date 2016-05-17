# Import Filters

It's possible to apply filters to the import process through the **include** and **exclude** arguments.     
With the **include** argument you'll import the listed tables according to the following syntax:

```
-include <tableName1>,<tableName2>,...,<tableNameX>

```


With the **exclude** argument you'll import all the tables except for the listed ones  according to the following syntax:

```
-exclude <tableName1>,<tableName2>,...,<tableNameX>

```
            
For both arguments recognizing tables is **case sensitive.**         
These arguments are **mutually exclusive,** thus you can use just one of them during the same execution.

####Example 1: include usage 

Importing only the "actor" and "film" tables from the source DB.

```
./oteleporter.sh -jdriver postgresql -jurl jdbc:postgresql://localhost:5432/dvdrental
                -juser username -jpasswd password -ourl plocal:$ORIENTDB_HOME/databases/dvdrental
                -include actor,film
```

####Example 2: exclude usage 

Importing all tables from the source DB except for the "actor" table.

```
./oteleporter.sh -jdriver postgresql -jurl jdbc:postgresql://localhost:5432/dvdrental
                -juser username -jpasswd password -ourl plocal:$ORIENTDB_HOME/databases/dvdrental
                -exclude actor
```