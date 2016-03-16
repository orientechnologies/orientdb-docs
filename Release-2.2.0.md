# Release 2.2.x

## What's new?

### Direct Memory
Starting from v2.2, OrientDB uses direct memory. The new server.sh (and .bat) already set the maximum size value to 512GB of memory by setting the JVM configuration
```
-XX:MaxDirectMemorySize=512g
```

If you run OrientDB embedded or with a different script, please set `MaxDirectMemorySize` to a high value, like `512g`.

### Command Cache
OrientDB 2.2 has a new component called [Command Cache](Command-Cache.md), disabled by default, but that can make a huge difference in performance on some use cases. Look at [Command Cache](Command-Cache.md) to know more.

### Sequences
-In progress-

### Parallel queries
Starting from v2.2, the OrientDB SQL executor will decide if execute or not a query in parallel. Before v2.2 executing parallel queries could be done only manually by appending the `PARALLEL` keyword at the end of SQL SELECT. [Issue 4578](https://github.com/orientechnologies/orientdb/issues/4578).

### Automatic usage of Multiple clusters
Starting from v2.2, when a class is created, the number of underlying clusters will be the number of cores. [Issue 4518](https://github.com/orientechnologies/orientdb/issues/4518).

### Encryption at rest
OrientDB v2.2 can encrypt database at file system level [89](https://github.com/orientechnologies/orientdb/issues/89).

### New ODocument.eval()
To execute quick expression starting from a ODocument and Vertex/Edge objects, use the new `.eval()` method. The old syntax `ODocument.field("city[0].country.name")` is not supported anymore. [Issue 4505](https://github.com/orientechnologies/orientdb/issues/4505).

## Migration from 2.1.x to 2.2.x

Databases created with release 2.1.x are compatible with 2.2.x, so you don't have to export/import the database.

### Security and speed

OrientDB v2.2 increase security by using [SALT](https://github.com/orientechnologies/orientdb/issues/1229). This means that hashing of password is much slower than OrientDB v2.1. You can configure the number of cycle for SALT: more is harder to decode but is slower. Change setting `security.userPasswordSaltIterations` to the number of cycles. Default is 65k cycles.
The default password hashing algorithm is now `PBKDF2WithHmacSHA256` this is not present in any environment so you can change it setting `security.userPasswordDefaultAlgorithm` possible alternatives values are `PBKDF2WithHmacSHA1` or `SHA-256`

To improve performance consider also avoiding opening and closing connection, but rather using a connection pool.

### API changes

#### ODocument.field()

To execute quick expression starting from a ODocument and Vertex/Edge objects, use the new `.eval()` method. The old syntax `ODocument.field("city[0].country.name")` is not supported anymore. This is because we simplified the `.field()` method to don't accept expressoion anymore. This allows to boost up performance on such used method. [Issue 4505](https://github.com/orientechnologies/orientdb/issues/4505).


#### Schema.dropClass()
On drop class are dropped all the cluster owned by the class, and not just the default cluster.


### Configuration Changes

Since 2.2 you can force to not ask for a root password setting `<isAfterFirstTime>true</isAfterFirstTime>` inside the `<orient-server>` element in the orientdb-server-config.xml file.


### SQL and Console commands Changes

Strict SQL parsing is now applied also to statements for *Schema Manipulation* (CREATE CLASS, ALTER CLASS, CREATE PROPERTY, ALTER PROPERTY etc.)

**ALTER DATABASE**: A statement like
```
ALTER DATABASE dateformat yyyy-MM-dd
```
is correctly executed, but is interpreted in the WRONG way: the `yyyy-MM-dd` is interpreted as an expression (two subtractions) and not as a single date format. Please re-write it as (see quotes)
```
ALTER DATABASE dateformat 'yyyy-MM-dd'
```

**CREATE FUNCTION**

In some cases a variant the syntax with curly braces was accepted (not documented), eg.

```
CREATE FUNCTION testCreateFunction {return 'hello '+name;} PARAMETERS [name] IDEMPOTENT true LANGUAGE Javascript
```

Now it's not supported anymore, the right syntax is
```
CREATE FUNCTION testCreateFunction "return 'hello '+name;" PARAMETERS [name] IDEMPOTENT true LANGUAGE Javascript
```

**ALTER PROPERTY**

The ALTER PROPERTY command, in previous versions, accepted any unformatted value as last argument, eg.

```
ALTER PROPERTY Foo.name min 2015-01-01 00:00:00
```

In v.2.2 the value must be a valid expression (eg. a string):
```
ALTER PROPERTY Foo.name min "2015-01-01 00:00:00"
```
