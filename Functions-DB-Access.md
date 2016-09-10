---
search:
   keywords: ['function', 'access', 'database access']
---

# Accessing the Database from a Function

When you create a function for OrientDB, it always binds the special variable `orient` to allow you to use OrientDB services from within the function.  The most important methods are:

| Function | Description |
|---|---|
| `orient.getGraph()` | Returns the current [transactional graph database](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientGraph.html) instance. |
| `orient.getGraphNoTx()` | Returns the current [non-transactional graph database](http://www.orientechnologies.com/javadoc/latest/com/tinkerpop/blueprints/impls/orient/OrientGraphNoTx.html) instance. |
| `orient.getDatabase()` | Returns the current [document database](http://www.orientechnologies.com/javadoc/latest/com/orientechnologies/orient/core/db/document/ODatabaseDocumentTx.html) instance. |

## Executing Queries

Queries are idempotent commands.  To execute a query from within a function, use the `query()` method.  For nstance,

  ```javascript
  return orient.getDatabase().query("SELECT name FROM OUser");
  ```

### Queries with External Parameters

Create a new function with the name `getUserRoles` with the parameter `user`.  Then use this code:

  ```javascript
  return orient.getDatabase().query("SELECT roles FROM OUser WHERE name = ?", name );
  ```

  Here, the function binds the `name` parameter as a variable in JavaScript.  You can use this variable to build your query.


## Executing Commands

OrientDB accepts commands written in any language that the JVM supports.  By default, however, OrientDB only supports SQL and JavaScript.

### SQL Commands

Execute an SQL command within the function:

```javascript
var gdb = orient.getGraph();
var results = gdb.command( "sql", "SELECT FROM Employee WHERE company = ?", [ "Orient Technologies" ] );
```

The command returns an array of objects:

- When it returns vertices: The result is an `OrientVertex` instance.
- When it returns edges: The result is an `OrientEdge` instance.
- When it returns records: The result is an `OIdentifiable` (or, any subclass of it) instance.


## Creating Repository Classes

Functions provide an ideal place for developing the logic your application uses to access the database.  You can adopt a [Domain-driven design](http://en.wikipedia.org/wiki/Domain-driven_design) approach, allowing the function to work as a [repository](http://en.wikipedia.org/wiki/Domain-drven_design#Building_blocks_of_DDD), or as a [Data Access Object](http://en.wikipedia.org/wiki/Data_access_object).

This provides a thin (or thick, if you prefer) layer of encapsulation which may protect you from database changes.

Furthermore, each function is published an dreachable via the HTTP REST protocol, allowing the automatic creation of a RESTful service.

**Examples**

Below are some examples of functions to build a repository for `OUser` records:

```javascript
function user_getAll() {
   return orient.getDatabase().query("SELECT FROM OUser");
}

function user_getByName( name ){
   return orient.getDatabase().query("SELECT FROM OUser WHERE name = ?", name );
}

function user_getAdmin(){
   return user_getByName("admin");
}
 
function user_create( name, role ){
   var db = orient.getDatabase();
   var role = db.query("SELECT FROM ORole WHERE name = ?", roleName);
   if( role == null ){
      response.send(404, "Role name not found", "text/plain", "Error: role name not found" );
   } else {

      db.begin();
      try{
         var result = db.save({ "@class" : "OUser", name : "Luca", password : "Luc4", status: "ACTIVE", roles : role});
         db.commit();
         return result;
      }catch ( err ){
         db.rollback();
         response.send(500, "Error on creating new user", "text/plain", err.toString() );
      }
   }
}
```


![image](images/studio-function-repository.png)
