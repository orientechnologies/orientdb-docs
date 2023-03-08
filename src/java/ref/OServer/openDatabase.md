---
search:
   keywords: ['Java API', 'OServer', 'open database', 'ODatabase', 'openDatabase']
---

# OServer - openDatabase()

This method opens a database on the OrientDB Server.

## Opening Databases

In order to operate on databases on a given [`OServer`](../OServer.md) instance, you first need to open the database.  Databases have separate login credentials from the OrientDB Server.


### Syntax

There are several methods available, depending on which arguments you want to use in opening the given database and what you would like the method to return.

```
public ODatabase<T> OServer().openDatabase(String iDbURL,
		OToken iToken)

public ODatabase<T> OServer().openDatabase(String iDbURL,
		String user, String passwd)

public ODatabase<T> OServer().openDatabase(String iDbURL,
		String user, String passwd, ONetworkProtocolData data)

public ODatabaseDoucmentTx OServer().openDatabase(String iDbURL,
		String user, String passwd, ONetworkProtocolData data,
		Boolean iBypassAccess)

public ODatabaseDocumentTx OServer().openDatabase(ODatabaseDocumentTx database,
		String user, String passwd, ONetworkProtocolData data,
		Boolean iBypassAccess)
```

| Argument | Type | Description |
|---|---|---|
| **`iDbURL`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the URL to the database. |
| **`user`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the user to open the database. |
| **`passwd`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the password for the user. |
| **`data`** | `ONetworkProtocolData` | Defines the network protocol for the connection. |
| **`iBypassAccess`** | [`java.lang.Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Defines whether to bypass authentication in opening the database. |
| **`database`** | [`ODatabaseDocument`](../ODatabaseDocument.md) | Defines the database to open. |

#### Return Value

This method returns an `ODatabase<T>` value, where `T` is a generic for any OrientDB database types.

- `ODatabaseDocumentTx`
- `OrientGraph`
- `OObjectDatabaseTx`
