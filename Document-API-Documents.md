---
search:
   keywords: ['Document API', 'documents']
---

# Working with Documents

When you have data ready in your database, you need a way to access it in order to manipulate it through your application.  There are three ways to do this:

- [Retrieving Documents](#retrieving-documents) through the Java API.
- [Querying Documents](#querying-documents) through SQL.
- [Traversing Documents](#traversing-documents) through the Java Traverse API.


## Retrieving Documents

Using the Java API, you can retrieve documents into an object or access the database otherwise using the `ODocument` object.  If you're more comfortable working in Java than SQL, this solution may work best for you.

- Browse all documents in a cluster:

  ```java
  for (ODocument doc : database.browserCluster("CityCars")) {
     System.out.println(doc.field("model"));
  }
  ```

- Browe all records in a class:

  ```java
  for (ODocument animal : database.browseClass("Animal")) {
     System.out.println(animal.field("name"));
  }
  ```

- Count records in a class:

  ```java
  long cars = database.countClass("Cars");
  ```

- Count records in a cluster:

  ```java
  long cityCars = database.countCLuster("CityCar");
  ```


## Querying Documents

While OrientDB is a NoSQL database implementation, it does support a subset of SQL.  This allows it to process links to documents and graphs.  For example,

```java
List<ODocument> result = db.query(
   new OSQLQuery<ODocument>(
      "SELECT FROM Animal WHERE id = 10
      AND NAME LIKE 'G%'"
   )
);
```

For more information on the OrientDB syntax, see [SQL](SQL.md).

>**NOTE**: OrientDB is a Graph Database.  This means that it is very efficient at traversals.  You can use this feature to optimize your queries, such as with [pivoting](Pivoting-With-Query.md).

### Asynchronous Queries

In addition to the standard SQL queries, OrientDB also has support for asynchronous queries.  Here, the result is not collected and returned in a synchronous manner, (as above), but rather it uses a callback every time it finds a record that satisfies the predicates.

```java
database.command(
   new OSQLAsynchQuery<ODocument>(
      "SELECT FROM Animal WHERE name = 'Gipsy'",
      new OCommandResultListener() {
         resultCount = 0;
         @Override
         public boolean result(Object iRecord) {
            resultCount++;
            ODocument doc = (ODocument) iRecord;

            // ENTER YOUR CODE TO WORK WITH DOCUMENT

            return resultCount > 20 ? false: true;
         }

         @Override
         public void end() {}
      }
   )
).execute();
```

When OrientDB executes an asynchronous query, it only needs to allocate memory for each of the individual callbacks as it encounters them.  You may find this a huge benefit in cases where you need to work with large result-sets.


#### Non-Blocking Queries

Both synchronous and asynchronous queries are blocking queries.  What this means is that the first instruction you issue after `db.query()` or `db.command().execute()` executes only after you invoke the last callback or receive the complete result-set.

Beginning in version 2.1, OrientDB introduces support for non-blocking queries.  These use a similar API to asynchronous queries.  That is, you have a callback that gets invoked for every record in the result-set.  However, the behavior is very different.  Execution on the current thread continues without blocking on `db.query()` or `db.command().execute()` while it invokes the callback on a different thread.  This means that you can close the database instance while still receiving callbacks from the query result.

```java
Future future = database.command(
   new OSQLNonBlockingQuery<Object>(
      "SELECT FROM Animal WHERE name = 'Gipsy'",
      new CommandResultListener(){
         resultCount = 0;
         @Override
         public boolean result(Object iRecord){
            // ENTER YOUR CODE HERE

            System.out.print("callback "+resultCount+" invoked");
            return resultCount > 20 ? false: true;
         }

         @Override
         public void end(){}
      }
   )
).execute();

System.outprintln("query executed");

future.get();
```

When the code executes, the results look something like this:

```
query executed
callback 0 invoked
callback 1 invoked
callback 2 invoked
callback 3 invoked
callback 4 invoked
```

You might also get results something like this:

```
query executed
callback 0 invoked
callback 1 invoked
query executed
callback 2 invoked
callback 3 invoked
callback 4 invoked
```

Whether this occurs depends on race conditions on the two parallel threads.  That is, a case where one fires the query execution and then continues with "query executed", while the other invokes the callbacks.

The `future.get()` method is a blocking call that returns only after the last callback invocation.  You can avoid this in cases where you don't need to know when the query terminates.


### Prepared Queries

Similar to the Prepared Statement of JDBC, OrientDB now supports prepared queries.  With prepared queries, the database pre-parses the query so that, in cases of multiple executions of the same query, they run faster than the class SQL queries.  Furthermore, the pre-parsing mitigates SQL Injection.

Prepared queries use two kinds of markers to substitute parameters on execution:

- **`?`** Syntax is used in reference to position parameters. For instance,

  ```java
  OSQLSynchQuery<ODocument> query = new OSQLSynchQuery<ODocument>(
     "SELECT FROM Profile WHERE name = ? AND surname = ?"
  );

  List<ODocument> result = database.command(query).execute("Barack", "Obama");
  ```

- **`:<parameter>`** Syntax is used in reference to named parameters.  For instance,

  ```java
  OSQLSynchQuery<ODcument> query = new OSQLSynchQuery<ODocument>(
     "SELECT FROM Profile WHERE name = :name AND surname = :surname"
  );

  Map<String,Object> params = new HashMap<String,Object>();
  params.put("name", "Barack");
  params.put("surname", "Obama");

  List<ODocument> result = database.command(query).execute(params);
  ```


>**NOTE**: With prepared queries, the parameter substitution feature only works with [`SELECT`](SQL-Query.md) statements.  It does not work with [`SELECT`](SQL-Query.md) statements nested with other query types, such as [`CREATE VERTEX`](SQL-Create-Vertex.md).

### SQL Commands

In addition to queries, you can also execute SQL commands through the Java API.  These require that you use the `.command()` method, passing it an `OCommandSQL` object.  For instance,

```java
int recordsUpdated = db.comamnd(
   new OCommandSQL("UPDATE Animal SET sold = false"
).execute();
```

When the command modifies the schema, such as [`CREATE CLASS`](SQL-Create-Class.md) or [`ALTER PROPERTY`](SQL-Alter-Property.md), remember that you also need to force a schema update on the database instance you're using.

```java
db.getMetadata().getSchema().reload();
```

## Traversing Documents

When using SQL, the process of combining two or more tables is handled through joins.  Since OrientDB is a Graph Database, it can operate across documents by traversing links.  This is much more efficient than the SQL join.  For more information, see [Java Traverse API](Java-Traverse.md).

In the example below, the application operates on a database with information on movies.  It traverses each movie instance following links up to the fifth depth level:

```java
for (OIdentifiable id : new OTraverse()
         .field("in").field("out")
         .target(database.browseClass("Movie").iterator())
         .predicate(new OCommandPredicate() {
   public boolean evaluate(ORecord<?> iRecord, OCommandContext iContext) {
      return ((Integer) iContext.getVariable("depth")) <= 5;
            }
         })
     ){
   System.out.println(id);
}
```

