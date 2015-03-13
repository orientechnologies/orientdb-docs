# Fetching Strategies

OrientDB supports fetching strategies by using the **Fetch Plans**. Fetch Plans are used to customize how OrientDB must load linked records.

Example:
```
Invoice
 3:100
   |
   | customer
   +---------> Customer
   |            5:233
   | address            city            country
   +---------> Address---------> City ---------> Country
   |            10:1             11:2             12:3
   |
   | orders
   +--------->* [OrderItem OrderItem OrderItem]
                [  8:12      8:19      8:23   ]
```

By default OrientDB loads all the linked records in lazy way. So in this example the linked "customer", "city" and "orders" fields are not loaded until are traversed. If you need the entire tree it could be slow the lazy loading of every single linked record. In this case it would need 7 different loads. If the database is open on a remote server they are 7 different network calls.

This is the reason why OrientDB supports custom fetching strategies using the **Fetch Plans**.  The aim of fetch plans is to pre-load connected records in one shot.

Where use fetch-plans?
- On record loading through the remote connection
- On JSON serializer to produce JSON with nested records

## Remote connection

When a client executes a query (or load directly one single record) setting a fetch plan with level different to 0, then the server traverses all the records of the returning result set and sends them to the client in the same call.

The client avoid to connect directly them to the record by using always the lazy collections (i.e.: OLazyRecordList). Instead, loads all the connected records into the local client. In this ways the collections remain lazy but when you're accessing to the content, the record is early loaded from the local cache avoiding other connections.

## Format

The fetch plan comes in form of a String and can be used at run-time on:
- query
- record loading

The syntax is:

```
[[levels]]<fieldPath>:<depth-level>*
```

Where:
- **levels**, optional, tells at which levels the rules must apply. Levels starts from 0. Since 2.1. Supported syntax is:
 - **level**, example `[0]` to apply only at first level
 - **ranges**, example `[0-3]` form 0 to 3th level. Ranges can be also partial, like `[-3]` means 0-3 and `[3-]` means form 3rd to infinite
 - **any**, by using `*`. Example `[*]` to apply at any level
- **fieldPath**, is the field name path, expected in dot notation, starting from the root record or the wildcard <code>*</code> for "any" field. The wildcard * can be also at the end of the path to specify all the paths that starts for a name
- **depth-level**, is the deep level requested:
 - 0 = Load only current record,
 - 1-N = load only the first-Nth connected record,
 - -1 = unlimited,
 - -2 = exclude it

To express multiple rules separate them by spaces.

Examples with the record tree above:
- <code>"*:-1"</code>: fetches the entire tree recursively
- <code>"*:-1 orders:0"</code>: fetches all the records recursively but the "orders" field in root class. Note that in "orders" field will be loaded only its direct content (only records 8:12,8:19,8:23, none of other records inside them will be loaded).
- <code>"*:0 address.city.country:0"</code>: fetches only not-document fields in the root class and address.city.country field  (records 10:1,11:2,12:3).
- `"[*]in_*:-2 out_*:-2"`: returns all the properties, but edges (at any level)

## Circular dependencies

OrientDB handles circular dependencies to avoid any loop while fetches linking records.

## Example using the Java APIs

### Execute a query with a custom fetch plan

```java
List<ODocument> resultset = database.query(new OSQLSynchQuery<ODocument>("select * from Profile").setFetchPlan("*:-1"));
```

### Export a document and its nested documents in JSON

Export an invoice and its customer:

```java
invoice.toJSON("fetchPlan:customer:1");
```

Export an invoice, its customer and orders:

```java
invoice.toJSON("fetchPlan:customer:1 orders:2");
```

Export an invoice and all the connected records up to 3rd level of depth:

```java
invoice.toJSON("fetchPlan:*:3");
```

From SQL:

```sql
select @this.toJSON('fetchPlan:out_Friend:4') from #10:20
```

Export path in outgoing direction by removing all the incoming edges by using wildcards (Since 2.0):
```sql
select @this.toJSON('fetchPlan:in_*:-2') from #10:20
```

**NOTES:**:
- To avoid looping, the record already traversed by fetching are exported only by their [RIDs](Concepts.md#recordid) (RecordID) form
- "fetchPlan" setting is case sensitive


### Browse objects using a custom fetch plan

```java
for (Account a : database.browseClass(Account.class).setFetchPlan("*:0 addresses:-1")) {
  System.out.println( a.getName() );
}
```

_**NOTE:** fetching Object will mean their presence inside your domain entities. So if you load an object using fetchplan `*:0` all LINK type references won't be loaded._


