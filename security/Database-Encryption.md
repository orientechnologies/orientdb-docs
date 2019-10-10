---
search:
   keywords: ['security', 'encryption', 'database encryption']
---

# Database Encryption

Beginning with version 2.2, OrientDB can encrypt records on disk.  This prevents unauthorized users from accessing database content or even from bypassing OrientDB security.  OrientDB does not save the encryption key to the database.  You must provide it at run-time.  In the event that you lose the encryption key, the database, (or at least the parts of the database you have encrypted), you lose access to its content.

> **NOTE**: Encryption at rest is not supported on remote protocol yet. It can be used only with plocal. 

Encryption works through the encryption interface.  It acts at the cluster (collection) level.  OrientDB supports two algorithms for encryption:

- `aes` algorithm, which uses [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
- `des` algorithm, which uses [DES](https://en.wikipedia.org/wiki/Data_Encryption_Standard)

The AES algorithm is preferable to DES, given that it's stronger.

Encryption in OrientDB operates at the database-level.  You can have multiple databases, each with different encryption interfaces, running under the same server, (or, JVM, in the event that you run OrientDB embedded).  That said, you can use global configurations to define the same encryption rules for all databases open in the same JVM.  For instance, you can define rules through the Java API:

```java
OGlobalConfiguration.STORAGE_ENCRYPTION_METHOD.setValue("aes");
OGlobalConfiguration.STORAGE_ENCRYPTION_KEY.setValue("T1JJRU5UREJfSVNfQ09PTA==");
```

You can enable this at startup by passing these settings as JVM arguments:

<pre>
$ <code class="lang-sh userinput">java ... -Dstorage.encryptionMethod=aes \
      -Dstorage.encryptionKey="T1JJRU5UREJfSVNfQ09PTA=="</code>
</pre>


For more information on security in OrientDB, see the following pages:
- [Database security](Database-Security.md)
- [Server security](Server-Security.md)
- [Secure SSL connections](Using-SSL-with-OrientDB.md)



## Creating Encrypted Databases

You can create an encrypted database using either the console or through the Java API.  To create an encrypted database, use the `-encryption` option through the [`CREATE DATABASE`](../console/Console-Command-Create-Database.md) command.  However, before you do so, you must set the encryption key by defining the `storage.encryptionKey` value through the [`CONFIG`](../console/Console-Command-Config.md) command.

<pre>
orientdb> <code class="lang-sql userinput">CONFIG SET storage.encryptionKey T1JJRU5UREJfSVNfQ09PTA==</code>
orientdb> <code class="lang-sql userinput">CREATE DATABASE plocal:/tmp/db/encrypted-db admin my_admin_password 
          plocal document -encryption=aes</code>
</pre>

To create an encrypted database through the Java API, define the encryption algorithm and then set the encryption key as database properties:

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/tmp/db/encrypted");
db.setProperty(OGlobalConfiguration.STORAGE_ENCRYPTION_METHOD.getKey(), "aes");
db.setProperty(OGlobalConfiguration.STORAGE_ENCRYPTION_KEY.getKey(), "T1JJRU5UREJfSVNfQ09PTA==");
db.create();
```

Whether you use the console or the Java API, these commands encrypt the entire database on disk.  OrientDB does not store the encryption key within the database.  You must provide it at run-time.



## Opening Encrypted Databases

You can access an encrypted database through either the console or the Java API.  To do so through the console, set the encryption key with `storage.encryptionKey` then open the database.

<pre>
orientdb> <code class="lang-sql userinput">CONFIG SET storage.encryptionKey T1JJRU5UREJfSVNfQ09PTA==</code>
orientdb> <code class="lang-sql userinput">CONNECT plocal:/tmp/db/encrypted-db admin my_admin_password</code>
</pre>

When opening through the Java API, given that the encryption settings are stored with the database, you do not need to define the encryption algorithm when you open the database, just the encryption key.

```java
db.setProperty(OGlobalConfiguration.STORAGE_ENCRYPTION_KEY.getKey(), "T1JJRU5UREJfSVNfQ09PTA==");
db.open("admin", "my_admin_password");
```

In the event that you pass a null or invalid key when you open the database, OrientDB raises an `OSecurityException` exception.

> **Note**: from version 3.x cluster encryption is no longer supported.
