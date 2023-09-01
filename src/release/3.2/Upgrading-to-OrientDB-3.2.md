
# Upgrading to OrientDB 3.2

## Binary formats

When upgrading OrientDB to a newer major/minor version, we recommend to perform an export and import of the databases.
Anyway, OrientDB guarantees binary format compatibility, so export/import is not striclty needed.


## General information

Developing OrientDB 3.2 we put a lot of attention on maintaining backward compatibility with v 3.0 and 3.1. 

Here is a list of the things you should know when migrating to v 3.2

## Database Creation

In OrientDB v 3.2, the creation of a new database does not automatically provide default users (admin, reader, writer). This choice is due to Security considerations: default users come with default passwords, that are a possible weakness in the server security if not promptly changed.

A new database API is provided to create custom users at DB creation time:

```
Orientdb orientdb = ...;

orientdb.execute("CREATE DATABASE foo plocal users(admin identified by 'adminpwd' role admin")
```

The old behaviour (ie. creating default users with default password) can be restored by setting the Global Configuraion option called `security.createDefaultUsers`:

eg.

```
./server.sh -Dsecurity.createDefaultUsers=true
```

## Console 

The console was adapted to include support to [Server-Level commands](../../serverlevel/README.md) and to allow the creation of databases without default users (see above).
The old `create database` command had a complex behaviour: it created a DB with default users and then *connected* to that database using `admin` user and the default password. This is not possible anymore by default (default `admin` user does not exist anymore), so `create database` no longer connects to the DB. 

The new console interaction pattern involves connecting to the server/environment (see [CONNECT ENV](../../console/Console-Command-Connect-Env.md)) and then execute server-level commands on it.

`CREATE DATABASE` command was enhanced to accept default user names and password (see [CREATE DATABASE](../../console/Console-Command-Create-Database.md))

A new `OPEN <database>` command was added to connect to an existing database in current server/environment (see [OPEN](../../console/Console-Command-Open.md))


A backward compatibility option is provided to allow execution of old console scripts; it can be enabled setting the console configuration as follows (this can just be added as the first row of the script):

```
orientdb> SET compatibilityLevel=0;
```



# Release notes

General information on how to upgrade OrientDB can be found in the [Upgrade](../Upgrade.md) Chapter.

You may also be interested in checking the [Release Notes](../Release-Notes.md).
