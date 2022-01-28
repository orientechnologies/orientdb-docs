---
search:
   keywords: ['Java API', 'live query', 'live queries']
---

# Using Live Queries in Java

In order to implement the Live Query feature in your Java applications, you need two elements:

- [**Listener**](#listener) The class that asynchronously receives the result-set from the query.
- [**Statement**](#statement) The SELECT query statement that OrientDB executes to define the records to be monitored.

## Listener

When developing a listener for your query, you must implement the `OLiveQueryResultListener` class.  It must have a callback method that receives the Live Query token and the record that was modified with the operation that occurred, (that is, [`INSERT`](../sql/SQL-Insert.md), [`UPDATE`](../sql/SQL-Update.md), or [`DELETE`](../sql/SQL-Delete.md).

```java
class MyLiveQueryListener implements OLiveQueryResultListener {

    @Override
    public void onCreate(ODatabaseDocument database, OResult data) {
       // your record create logic here
    }

    @Override
    public void onUpdate(ODatabaseDocument database, OResult before, OResult after) {
       // your record update logic here
    }

    @Override
    public void onDelete(ODatabaseDocument database, OResult data) {
       // your record delete logic here
    }

    @Override
    public void onError(ODatabaseDocument database, OException exception) {
       // your error logic here
    }

    @Override
    public void onEnd(ODatabaseDocument database) {
       // this is invoked when you unsubscribe
    }
  }
```

## Live Query execution

In order to actually execute a Live Query, you can use the `db.live(query, listener, parameters...)` method, passing it the SQL query statement.  For instance, assume you have an active `ODatabaseSession` instance tied to the `db` object and that you want a Live Query to update a webpage that shows current messages for a user with the Record ID #12:40.

```java
// Instantiate Query Listener
OLiveQueryResultListener listener = new MyLiveQueryListener();

// Execute Live Query
OLiveQueryMonitor monitor = db.live("SELECT FROM Messages WHERE toAddress = #12:40"", listener);

// and eventually stop the live query, when you don't need it anymore
monitor.unSubscribe();
```

From now on, your application receives updates from OrientDB whenever changes are made to the result-set.  So, for instance, say that someone connected to another client where to execute an [`INSERT`](../sql/SQL-Insert.md) statement, like

```java
// Send Message
db.command("INSERT INTO Messages SET toAddress = #12:40, "
      + "fromAddress = 12:80, "
      + "subject = 'Re: Recent Events'"
   );
```

When the client executes this command on OrientDB, OrientDB in turn invokes the `onCreate()` method on your listener class.  



### Unsubscribe

Live Queries remain active indefinitely, until the server shuts down or you unsubscribe from the token.  As described above, the live query execution returns a monitor object, that can be used to unsubscribe from the live query.

```java
monitor.unSubscribe();
```

From now on, your application no longer receives updates on this query.






# Legacy Live Queries

OrientDB v 3.0 still supports the legacy APIs, that were the default implementation in v 2.2.
We strongly suggest to avoid using these APIs, as they will be removed in next major versions.


## Legacy Listener

When developing a listener for your query, you must implement the `OLiveResultListener` class.  It must have a callback method that receives the Live Query token and the record that was modified with the operation that occurred, (that is, [`INSERT`](../sql/SQL-Insert.md), [`UPDATE`](../sql/SQL-Update.md), or [`DELETE`](../sql/SQL-Delete.md).

```java
class MyLiveQueryListener implements OLiveResultListener {

   public List<ORecordOperation> ops = new 
         ArrayList<ORecordOperation>();

   @Override
   public void onLiveResult(
         int LiveToken, 
         ORecordOperation iOp)
         throws OException {
   
      System.out.println(
         "New Result from server for live query "
         + iLiveToken);
      System.out.println("operation: " + iOp.type);
      System.out.println("content: " + iOp.record);
   }

   public void onError(int iLiveToken){
      System.out.println(
         "Live query terminated due to error"
      );
   }

   public void onUnsubscribe(int iLiveToken){
      System.out.println(
         "Live query terminated with unsubscribe."
      );
   }
}
```

## Legacy Live Query execution

In order to actually execute a Live Query, you can use the `db.query()` method, passing itan `OLiveQuery` object as an argument with a [`LIVE QUERY`](../sql/SQL-Live-Select.md) SQL statement.  For instance, assume you have an active `ODatabaseDocumentTx` instance tied to the `db` object and that you want a Live Query to update a webpage that shows current messages for a user with the Record ID #12:40.

```java
// Instantiate Query Listener
MyLiveQueryListener listener = new MyLiveQueryListener();

// Execute Live Query
List<ODocument> result = db.query(
   new OLiveQuery<ODocument>(
      "LIVE SELECT FROM Messages WHERE toAddress = #12:40"
   )
);

// Retrieve Live Query Token
String token = result.get(0).field("token");
```

From now on, your application receives updates from OrientDB whenever changes are made to the result-set.  So, for instance, say that someone connected to another client where to execute an [`INSERT`](../sql/SQL-Insert.md) statement, like

```java
// Send Message
db.command("INSERT INTO Messages SET toAddress = #12:40, "
      + "fromAddress = 12:80, "
      + "subject = 'Re: Recent Events'"
   );
```

When the client executes this command on OrientDB, OrientDB in turn invokes the `onLiveResult()` method on your listener class.  Given the way the code is written in Listener above, your applications prints the following information to standard output:

```
New result from server for live query 1234567
operation: 3 <- ORecordOperation.CREATED
content: {@RID: "15:20", toAddress: "#12:40", 
fromAddress: "#12:80", subject: "Re: Recent Events"}
```

### Legacy Unsubscribe

Live Queries remain active indefinitely, until the server shuts down or you unsubscribe from the token.  In the above section, you use the following line to store the Live Query token in the `token` variable

```java
// Retrieve Live Query Token
String token = result.get(0).field("token");
```

You can use this variable with [`LIVE UNSUBSCRIBE`](../sql/SQL-Live-Unsubscribe.md) to unsubscribe from the Live Query.

```java
db.command(
   new OCommandSQL("LIVE UNSUBSCRIBE " + token))
   .execute();
```

From now on, your application no longer receives updates on this query.
