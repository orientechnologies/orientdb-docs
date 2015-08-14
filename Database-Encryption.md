# Database Encryption

(Since 2.2 - Status: Beta, will be final with 2.2 GA)

See also:
- [Database security](Database-Security.md)
- [Server security](Server-Security.md)
- [Secure SSL connections](Using-SSL-with-OrientDB.md)

Starting from v2.2, OrientDB can encrypt the records on disk. This denies anybody from accessing to the database content, even bypassing the OrientDB security system. The encryption key is not saved in database but must be provided at run-time. If the encryption key is lost, the database, or the encrypted portion, can't be read anymore.

Encryption uses the "encryption" interface and act at cluster (collection) level. The supported algorithms are:
- `aes` that uses [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
- `des` that uses [DES](https://en.wikipedia.org/wiki/Data_Encryption_Standard)

**AES** algorithm is preferable to DES because it's stronger.

OrientDB encryption works at database level. Having multiple databases with different encryptions under the same Server (or JVM OrientDB is running embedded) is allowed. For this reason encryption settings are per-database. However you can use the global configuration to use the same encryption rules to all the database open in the same JVM. Example of global configuration via Java API:

```java
OGlobalConfiguration.STORAGE_ENCRYPTION_METHOD.setValue("aes");
OGlobalConfiguration.STORAGE_ENCRYPTION_KEY.setValue("T1JJRU5UREJfSVNfQ09PTA==");
```
And at startup by passing these settings as JVM arguments:

```
java ... -Dstorage.encryptionMethod=aes -Dstorage.encryptionKey="T1JJRU5UREJfSVNfQ09PTA=="
```

## Create an encrypted database 
### Create via Console

To create an encypted database, use the -encryption option on [create database command](Console-Command-Create-Database.md). before that set the encryption key by storing it as console's configuration value with name `storage.encryptionKey`. Example:
```
orientdb> config set storage.encryptionKey T1JJRU5UREJfSVNfQ09PTA==
orientdb> create database plocal:/tmp/db/encrypted admin admin plocal document -encryption=aes
```

### Create via Java API
To create a new database with AES algorithm, set the encryption algorithm and the encryption key as database properties:

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/tmp/db/encrypted");
db.setProperty(OGlobalConfiguration.STORAGE_ENCRYPTION_METHOD.getKey(), "aes");
db.setProperty(OGlobalConfiguration.STORAGE_ENCRYPTION_KEY.getKey(), "T1JJRU5UREJfSVNfQ09PTA==");
db.create();
```

In this way the entire database will be encrypted on disk. The encryption key is never stored inside the database, but must be provided at run-time.

## Encrypt only certain clusters

To encrypt only a few clusters, set the encryption to "nothing" (default) and configure the encryption per cluster through the [`alter cluster`](SQL-Alter-Cluster.md) command:

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/tmp/db/encrypted");
db.setProperty(OGlobalConfiguration.STORAGE_ENCRYPTION_KEY.getKey(), "T1JJRU5UREJfSVNfQ09PTA==");
db.create();
db.command(new OCommandSQL("alter cluster Salary encryption aes")).execute();
```

Note that the key is the same for the entire database. You cannot use different keys per cluster. If the encryption/encryption setting is applied on an non empty cluster, then an error is raised.

If you're using the console, remember to set the encryption key `storage.encryptionKey` before setting the encryption. Example:
```
orientdb> config set storage.encryptionKey T1JJRU5UREJfSVNfQ09PTA==
orientdb> alter cluster Salary encryption aes
```

## Open an encrypted database

### Open via Console

If you're using the console, remember to set the encryption key `storage.encryptionKey` before opening the database. Example:
```
orientdb> config set storage.encryptionKey T1JJRU5UREJfSVNfQ09PTA==
orientdb> connect plocal:/tmp/db/encrypted admin admin
```

### Open via Java API
Since the encryption setting are stored with the database, it's not necessary to specify the encryption algorithm at open time, but only the encryption key. Example:

```java
db.setProperty(OGlobalConfiguration.STORAGE_ENCRYPTION_KEY.getKey(), "T1JJRU5UREJfSVNfQ09PTA==");
db.open("admin", "admin");
```

If on database open, a null or invalid key is passed, then a `OSecurityException` exception is thrown.
