---
search:
   keywords: ['Java', 'OrientDB', 'list databases', 'list']
---

# OrientDB - list()

This method returns a list of databases on the OrientDB Server.

## Listing Databases

Occasionally, you may want to read or operating on every database in an OrientDB Server.  This method returns a list of string values giving the name for each database on the server.  You can then log the list for debugging or pass the name to other methods to perform further operations.

### Syntax

```
public List<String> OrientDB().list()
```

### Example

Default login credentials for an OrientDB database uses the user `admin` with the password `admin`.  Given that this is not a good security practice for production instance, you might want a method that checks each database on the OrientDB Server for default credentials and reports the issue to logs.

```java
private OrientDB orientdb;
private Logger logger;
...

// Check for Default Credentials
public void checkDbCredentials(){

   // Init Variables 
   List<String> reportList;
   List<String> dbs = orientdb.list();

   for (int i = 0; i < dbs.size(); i++){

      // Get Database Name
      String name = dbs.get(i);	

	  // Check Credentials
	  try {

	     // Open Database
         ODatabaseDocumentTx db = orientdb.open(name, "admin", "admin");

		 // Check If Open
		 if (db.isOpen()) {
            reportList.add(name);
		 }

	  } finally {
	     // Close Database
		 db.close();

	  }

   }

   // Report Default Logins to Log
   if (reportList.size() > 0){

      logger.warn("Databases Found with Default Credentials: " +
	     String.join(", ", reportList);

   }
}
```
