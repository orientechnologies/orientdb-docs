---
search:
   keywords: ['java', 'odatabasedocument', 'execute']
---

# ODatabaseDocument - execute()

Runs the given script in the specified query language and returns a result-set.

## Executing Queries

Using this method you can execute queries on the OrientDB database.  You may find it useful when you need to construct an OrientDB SQL statement based on user input or runtime information.  Note that the method returns an [`OResultSet`](../OResultSet.md) instance, which you need to close when done.

### Syntax

```
OResultSet ODatabaseDocument().execute(String lang, String script, Object... args)
OResultSet ODatabaseDocument().execute(String lang, String script, Map<String, ?> args)
```

| Argument | Type | Description |
|---|---|---|
| **`lang`** | `String` | Defines the language you want to use.  For instance, `sql` for OrientDB SQL |
| **`script`** | `String` | Provides the script you want to execute |
| **`args`** | `Object | Map<String, ?>` | Defines arguments to use in formatting the script |

#### Return Value

This method returns an [`OResultSet`](../OResultSet.md) instance, containing the result-set of the query.  Note that you need to close the result-set when you're done using it in order to free up resources.

### Example

Imagine an application that stores account information on OrientDB.  You might create a method to connect to the database and add new client data, rolling the [`INSERT`](../../../sql/SQL-Insert.md) statement with the data provided by the parameters.

```java
private ODatabaseDocument db;

// Queries
private String addAccountSql = "INSERT INTO Account SET company = '?', contact = '?', email = '?'";
...

// Add New Client to Accounts Task
public void addAccounts(String company, String contact, String email){

     // Log Operation
	 System.out.println(String.format("Adding Client: %s", company));

	 // Execute Query
	 OResultSet results = db.execute("sql", addAccountsql, company, contact, email);

	 // Close Result-set
	 results.close();
}
```

You can also use the alternative syntax, where the data parameters are defined by a `Map` instance.

```java
private ODatabaseDocument db;

// Queries
private String addAccountSql = "INSERT INTO Account SET company = ':company', contact = ':contact', email = ':email'";
...

// Add New Client to Accounts Task
public void addAccounts(Map<String, String> params){

     // Log Operation
	 System.out.println(String.format("Adding Client: %s", company));

	 // Execute Query
	 OResultSet results = db.execute("sql", addAccountsql, params);

	 // Close Result-set
	 results.close();
}
```


