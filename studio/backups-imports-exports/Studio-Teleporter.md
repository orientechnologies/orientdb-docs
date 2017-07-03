---
search:
   keywords: ['Studio', 'teleporter', 'enterprise']
---

# Teleporter

In Studio 2.2 you can configure the execution of the new Teleporter plugin, which allows you to import your relational database into OrientDB in few simple steps.
If you are interested in a detailed description of the tool, of its inner workings and features you can view the [Teleporter Documentation](Teleporter-Home.md).

NOTE: _This feature is available both for the [OrientDB Enterprise Edition](http://orientdb.com/orientdb-enterprise) and the [OrientDB Community Edition](http://orientdb.com/download/).

This visual tool consists in a wizard composed of 4 steps, where just **Step 1** and **Step 2** are necessary.
Let's have a look at each configuration step.

### Step 1

In the first step you have to type the following required parameters:
- `Database Driver`, as the driver name of the DBMS from which you want to execute the import. You have to choose among:
  - Oracle
  - SQLServer
  - Mysql
  - PostgreSQL
  - HyperSQL
- `Database Host`, as the host where you DBMS instance is running on
- `Port`, as the port where your DBMS is listening on
- `Database Name`, as the name of the source database
- `User Name`, as the username to access the source database (it may be blank)
- `Password`, as the password to access the source database (it may be blank)
- `OrientDB URL`, as the URL for the destination OrientDB graph database

After you typed all the required parameters for the migration you can test the connection.
![Test Connection](images/studio-teleporter-testconnection.png)

### Step 2

In the second step you have to specify all the parameters about the OrientDB target database:
- `Connection protocol`, as the protocol adopted to write in OrientDB. You have to choose among:
  - plocal
  - memory
- `OrientDB Database Name`, as the name of the target database in OrientDB
- `Strategy`, as the strategy adopted during the migration
- `Name Resolver`, as the basic name resolver to adopt during names' resolution
- `Inheritance descriptor`, as the XML file containing all the info describing inheritance relationships present in the source database
- `Password`, as the password to access the source database (it may be blank)
- `Log Level`, as the log level adopted by Teleporter during the migration. You can choose among: 
  - NO
  - DEBUG
  - INFO
  - WARNING
  - ERROR

Now we have collected all the minimal info needed for the migration, so you can run your configured job through the `START MIGRATION` button, thus the job progress monitor will be displayed:

Telpeorter Running image
![Teleporter Running](images/)

At the end of the migration, statistics and warnings about the process are reported as shown below:

Teleporter Finished
![Teleporter Finished](images/)

Otherwise you can go on in your migrationg customisation jumping to the next step.

### Step 3

Here you can exploit Teleporter's filtering features: in the table on the left all the table present in the source database are reported. If you want migrate just a subset of these tables you just have to select and move them in the right table through the specific buttons (you can also drag-and-drop the selected items).

You can perform the same operations also in the opposite direction, from the right table to the left one.

If the right table is empty, no filters will be applied. Instead, if the right table is not empty, just the selected tables will be imported while all the others will be filtered out.

Here too you can start your migration or go to the 4th and last configuration step.


### Step 4
// TODO
