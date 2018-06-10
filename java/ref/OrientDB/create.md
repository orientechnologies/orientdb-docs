---
search:
   keywords: ['Java', 'OrientDB', 'create']
---

# OrientDB - create()

This method lets you create a new database on the connected OrientDB Server.

## Creating Databases

Using this method, you can create new databases on the OrientDB Server.  In the event that you want to connect to an existing database, use the [`open()`](open.md) method.  If you want to only create the database if it does not exist already, use the [`createIfNotExists()`](createIfNotExists.md) method.

### Syntax

There are two methods available in creating databases:

```
// METHOD 1
public void OrientDB().create(String name,
      ODatabaseType type)

// METHOD 2
public void OrientDB().create(String name,
      ODatabaseType type,
	  OrientDBConfig config)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`java.lang.String`]({{ book.javase }}/api/java/lang/String.html) | Defines the database name |
| **`type`** | `ODatabaseType` | Defines the database type, can be PLocal or in-memory |
| **`config`** | `OrientDBConfig` | Defines the database configuration |

### Example

Consider the use case of an installation process for your application.  The user needs an embedded OrientDB database installed on their system whenever they start a new project in your application.  You might use a method like the one below to initialize the database and perform any other routine tasks needed whenever they create a new project. 

```java
private OrientDB orientdb = new OrientDB("embedded:/data", null, null);

// START NEW PROJECT
public void createNewProject(String name){

	// Create Project Name
	String db = "project-" + name;

	// Create Database
	orientdb.create(db, ODatabaseType.PLOCAL);
		
}
```

