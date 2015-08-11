# Database Encryption

See also:
- [Database security](Database-Security.md)
- [Server security](Server-Security.md)
- [Secure SSL connections](Using-SSL-with-OrientDB.md)

Starting from v2.2, OrientDB can encrypt the record content on disk. This deny anybody to access to the database content, even bypassing the OrientDB security system.

Encryption uses the "compression" interface and act at cluster (collection) level. The supported algorithms are:
- `aes-encrypted` that uses [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
- `des-encrypted` that uses [DES](https://en.wikipedia.org/wiki/Data_Encryption_Standard)

**AES** algorithm is preferable to DES because it's stronger.

## Create an encrypted database 

To create a new database with AES algorithm, set the encryption algorithm and the encryption key as database properties:

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/tmp/db/encrypted");
db.setProperty(OGlobalConfiguration.STORAGE_COMPRESSION_METHOD.getKey(), "aes-encrypted");
db.setProperty(OGlobalConfiguration.STORAGE_COMPRESSION_OPTIONS.getKey(), "T1JJRU5UREJfSVNfQ09PTA==");
db.create();
```

In this way the entire database will be encrypted on disk. Instead to encrypt only few clusters, set the encryption to "nothing" (default) and conigure the encryption per cluster through the [`alter cluster`](SQL-Alter-Cluster.md) command:

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/tmp/db/encrypted");
db.setProperty(OGlobalConfiguration.STORAGE_COMPRESSION_OPTIONS.getKey(), "T1JJRU5UREJfSVNfQ09PTA==");
db.create();
db.command(new OCommandSQL("alter cluster Salary compression aes-encrypted")).execute();
```

Note that the key is the same for the entire database. You cannot use diferent keys per cluster. If the compression/encryption seting is applied on an non empty clususter, then an error will be raised.

## Open a encrypted database

Since the encryption setting are stored with the database, it's not necessary to speciy the encryption algorithm on open, but only the key. Example:

```java
db.setProperty(OGlobalConfiguration.STORAGE_COMPRESSION_OPTIONS.getKey(), "T1JJRU5UREJfSVNfQ09PTA==");
db.open("admin", "admin");
```

