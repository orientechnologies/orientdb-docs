# Common Database Operations

## Connecting to an Existing Database

To connect to an existing database, select a database from the databases list and use a valid _database_ user. 

By default **reader/reader** can read records from the database, **writer/writer** can read, create, update and delete records. **admin/admin** has all rights.


## Creating a New Database

To create a new database, click the "New DB" button from the Home Page:

![Home Page](../images/studio-newDb.png)

Some information is needed to create a new database:

* Database name
* Database type (Document/Graph)
* Storage type (plocal/memory)
* _Server_ user
* _Server_ password 

You can find the server credentials in the 
$ORIENTDB_HOME/config/orientdb-server-config.xml file:
```
<users>
  <user name="root" password="pwd" resources="*" />
</users>
```
Once created, Studio will automatically login to the new database.


## Importing a Public Database

Starting from version 2.2, Studio allows you to import databases from a public repository.
These databases contain public data and bookmarked queries that will allow you to start
playing with OrientDB and OrientDB SQL. 

![Home Page](../images/studio-importPublic.png)

To install a public database, you will need the Server Credentials. 
Then, click the download button of the database that you are interested in.
Then Studio will download and install in to your $ORIENTDB_HOME/databases directory.
Once finished, Studio will automatically login to the newly installed database.


## Dropping an Existing Database

To drop an existing database, select it from the databases list and click the trash icon.
Studio will display a confirmation popup where you have to insert:

* _Server_ User
* _Server_ Password

and then click the "Drop database" button.
You can find the server credentials in the 
$ORIENTDB_HOME/config/orientdb-server-config.xml file:
```
<users>
  <user name="root" password="pwd" resources="*" />
</users>
```