# Installation and Configuration

## Installation
Teleporter is really easy to install, you just have to download the installation package available [here](http://orientdb.com/teleporter/) and follow these few instructions:

1. Download the package.
2. Move orientdb-teleporter-1.0.1-SNAPSHOT.jar contained in plugin/ folder to the $ORIENTDB_HOME/plugins folder.
3. Move the scripts oteleporter.sh and oteleporter.bat (for Windows users) contained in script/ folder to the $ORIENTDB_HOME/bin folder.

Teleporter is now ready, you can run the tool through the script as described in the [Home page](Teleporter-Home.md) or just execute it via OrientDB Studio as described [here.](Studio-Teleporter.md)


## Driver Configuration.

### Automatic Driver Configuration
Teleporter provides an automaic driver configuration: when the application starts, it looks for the required driver. If the driver is not found the application will download it and it will automatically configure the classpath, not delegating anything to the end user.   
So when you run Teleporter you just have to indicate the name of the DBMS you want to connect. Teleporter is compatible with Oracle, MySQL, PostgreSQL and HyperSQL products, thus you have to type one of the following parameters **(not case sensitive)**:

- **Oracle**
- **SQLServer**
- **MySQL**
- **PostgreSQL**
- **HyperSQL**

Teleporter will search for the correspondent driver in the $ORIENTDB_HOME/lib folder and if it's not present, it will download the last available driver version. If a driver is already present in the folder, then it will be used for the connection to the source DB.
Therefore if you want use a new driver version, you just have to delete the older version and run Teleporter which will download and configure for you the last available version.

```
./oteleporter.sh -jdriver postgresql -jurl jdbc:postgresql://localhost:5432/testdb 
                -juser username -jpasswd password -ourl plocal:$ORIENTDB_HOME/databases/testdb 
                -s naive -nr java -v 2
``` 

### Manual Driver configuration
It's possible to perform a manual configuration downloading own favourite driver version and properly defining the classpath in the application. 
Below are reported last driver tested versions with some useful information for download, configuration and use.     
       
| Driver     | Last Tested Version |  Path pattern | Path Example | Link for download |
|------------|---------------------|--------------|--------------|-------------------|
| Oracle     | 12c | jdbc:oracle:thin:@\<HOST\>:\<PORT\>:\<SID\> | jdbc:oracle:thin:@localhost:1521:orcl | http://www.oracle.com/technetwork/database/features/jdbc/default-2280470.html |
| SQLServer  | SQLServer 2014 | jdbc:sqlserver://\<HOST\>:\<PORT\>;databaseName=\<DB\> | jdbc:sqlserver://localhost:1433;databaseName=testdb; **(\*)**| http://www.java2s.com/Code/JarDownload/sqljdbc4/sqljdbc4-2.0.jar.zip |
| MySQL      | 5.1.35   | jdbc:mysql://\<HOST\>:\<PORT\>/\<DB\> | jdbc:mysql://localhost:3306/testdb | http://dev.mysql.com/downloads/connector/j/ |
| PostgreSQL | 9.4-1201 | jdbc:postgresql://\<HOST\>:\<PORT\>/\<DB\> | jdbc:postgresql://localhost:5432/testdb | https://jdbc.postgresql.org/download.html |
| HyperSQL   | 2.3.2 | jdbc:hsqldb:hsql://\<HOST\>:\<PORT\>/\<DB\> OR jdbc:hsqldb:file:\<filepath\> | jdbc:hsqldb:hsql://localhost:9500/testdb OR jdbc:hsqldb:file:testdb | http://central.maven.org/maven2/org/hsqldb/hsqldb/2.3.3/hsqldb-2.3.3.jar |

**(\*)**  If the source database contains spaces in the name you have to use a URL like this:

“Source DB” →  -jurl “jdbc:sqlserver://localhost:1433;databaseName={Source DB};”
