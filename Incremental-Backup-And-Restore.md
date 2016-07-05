# Incremental Backup and Restore

(Since v2.2 - Enteprise Edition only)

An incremental backup generates smaller backup files by storing only the delta between two versions of the database. This is useful when you execute a backup on a regular basis and you want to avoid having to back up the entire database each time.

NOTE: _This feature is available only in the [OrientDB Enterprise Edition](http://orientdb.com/orientdb-enterprise). If you are interested in a commercial license look at [OrientDB Subscription Packages](http://orientdb.com/support)_.

## See also
- [Backup and Restore](Backup-and-Restore.md)
- [BACKUP DATABASE console command](Console-Command-Backup.md)
- [RESTORE DATABASE console command](Console-Command-Restore.md)

## How does it work?

Every time a backup is executed, OrientDB writes a file named `last-backup.json` in the database directory. This is an example of the content:

```json
{
  "lsn": 8438432,
  "startedOn": "2015-08-17 10:33:23.943",
  "completedOn": "2015-08-17 10:33:45.121"
}
```

The most important information is the `lsn` field that is the WAL LSN (Last Serial Number). Thanks to this number, OrientDB is able to understand the last change in the database, so the next incremental backup will be done starting from last `lsn` + 1.

## Executing an Incremental Backup

### Incremental Backup via Console

[Backup Database console command](Console-Command-Backup.md) accepts `-incremental` as an optional parameter to execute an incremental backup. In this case the new backup is executed from the last backup (file `last-backup.json` is read if present). If this is the first incremental backup, a full backup is executed. Example:

```
orientdb> connect plocal:/databases/mydb admin admin
orientdb {db=Whisky}> backup database /tmp/backup -incremental
```

The incremental backup setting also allows you to specify an LSN version to start with. Example:

```
orientdb> connect plocal:/databases/mydb admin admin
orientdb {db=Whisky}> backup database /tmp/backup -incremental=93222
```

### Incremental Backup via Java API
You can perform an incremental backup via the Java API too.

**NOTE** The `remote` protocol is supported, but the specified *path* is relative to the server.

If you are managing an ODocumentDatabase you have to call the `incrementalBackup()` method that accepts a String *path* parameter to the backup directory:

```
ODatabaseDocumentTx documentDatabase = new ODatabaseDocumentTx(dbURL);
documentDatabase.open("root", "password");
documentDatabase.incrementalBackup("/tmp/backup");
```

If you are using the OrientGraph interface you have to get the raw graph before calling the `incrementalBackup()` method:

```
OrientGraph graphDatabase = new OrientGraphNoTx(dbURL);
graphDatabase.open("root", "password");
graphDatabase.getRawGraph().incrementalBackup("/tmp/backup");
```


## Executing an Incremental Restore

### Incremental Restore via the Console

[Restore Database console command](Console-Command-Restore.md) automatically recognizes if a backup contains incremental data. Restoring an incremental backup creates a new database with the restored content.  You cannot perform an in-place incremental restore on an existing database. The execution of the create database command with the option `-restore` builds a fresh database and performs the incremental restore starting from the backup path. 

Example:

```
orientdb> create database remote:localhost/mydb root root plocal graph -restore=/tmp/backup

Creating database [remote:localhost/mydb] using the storage type [plocal]...
Connecting to database [remote:localhost/mydb] with user 'admin'...OK

Database created successfully.

Current database is: remote:localhost/mydb
```

In distributed mode restore will success only with a single node in the cluster. If you have 2 nodes or more in your cluster you have to use the standard restore procedure.

### Incremental Restore via the Java API
You can perform an incremental restore via the Java API too.
To create a database from an incremental backup you can call from Java `ODatabase#create(path-to-incremental-backup-directory)`.

## Distributed Architecture

The incremental backup is used in the [Distributed Architecture](Distributed-Architecture.md) when a server node restarts. This avoids having to backup and tranfer the entire database across the network.

## Internals

### File Format
In case of incremental backup, the content of the zip file is not the database directory, but rather meta files needed to update the database with the delta. Example of the content:

```
- Employee.pcl
- Person.pcl.incremental
- Person.pcm.incremental
```

This means only three files are changed.  Employee.pcl is a full file, while the other two files with extension ".incremental" are incremental. Incremental files contain all the page changes and have the following format:
```
+----------------+-----------------+
| PAGE NUMBER    | PAGE CONTENT    |
| (long)         | byte[]          |
+----------------+-----------------+
```
