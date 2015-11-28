<!-- proofread 2015-11-26 SAM -->
# Fetching Strategies

*Fetchplans* are used in two different scopes:

1. Connections that use the [Binary Protocol](Network-Binary-Protocol.md) can *early load* records on the client's. On traversing of connected records, the client hasn't to execute further remote calls to the server, because the requested records are already on the client's cache
1. Connections that use the [HTTP/JSON Protocol](OrientDB-REST.md) can *expand the resulting JSON* to include connected records as embedded in the same JSON. This is useful on HTTP protocol to fetch all the connected records in just one call

## Format for Fetch Plans

In boths scopes, the fetchplan syntax is the same.  In terms of their use, Fetch Plans are strings that you can use at run-time on queries and record loads.  The syntax for these strings is,

<pre>
[[<code class="replaceable">levels</code>]]<code class="replaceable">fieldPath</code>:<code class="replaceable">depthLevel</code>
</pre>

- **Levels** Is an optional value that tells which levels to use with the Fetch Plans.  Levels start from `0`.  As of version 2.1, levels use the following syntax:
   - *Level* The specific level on which to use the Fetch Plan.  For example, using the level `[0]` would apply only to the first level.
   - *Range* The range of levels on which to use the Fetch Plan.  For example, `[0-2]` means to use it on the first to third level.  You can also use the partial range syntax: `[-3]` means from the first to fourth level while `[4-]` means from the fifth level to infinity.
   - *Any* The wildcard variable indicates that you want to use the Fetch Plan on all levels.  For example, `[*]`.
- **Field Path** Is the field name path, which OrientDB expects in dot notation.  The path begins from either the root record or the wildcard variable `*` to indicate any field.  You can also use the wildcard at the end of the path to specify all paths taht start for a name.
- **Depth Level** Is the depth of the level requested.  The depth level variable uses the following syntax:
   - `0` Indicates to load the current record.
   - `1-N` Indicates to load the current record to the *n*th record.
   - `-1` Indicates an unlimited level.
   - `-2` Indicates an excluded level.

In the event that you want to express multiple rules for your Fetch Plans, separate them by spaces.  

Consider the following Fetch Plans for use with the example above:

| Fetch Plan | Description |
|:---------|:---|
|`*:-1` | Fetches recursively the entire tree. |
|`*:-1 orders:0` | Fetches recursively all records, but uses the field `orders` in the root class.  Note that the field `orders` only loads its direct content, (that is, the records `8:12`, `8:19`, and `8:23`).  No other records inside of them load. |
|`*:0 address.city.country:0` | Fetches only non-document fields in the root class and the field `address.city.country`, (that is, records `10:1`,`11:2` and `12:3`).|
|`[*]in_*:-2 out_*:-2`| Fetches all properties, except for edges at any level.|


## Early loading of records

By default, OrientDB loads linked records in a lazy manner.  That is to say, it does not load linked fields until it traverses these fields.  In situations where you need the entire tree of a record, this can prove costly to performance.  For instance,

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

Here, you have a class `Invoice`, with linked fields `customer`, `city` and `orders`.  If you were to run a [`SELECT`](SQL-Query.md) query on `Invoice`, it would not load the linked class, it would require seven different loads to build the return value.  In the event that you have a remote connection that means seven network calls, as well.

In order to avoid performance issues that may arise from this behavior, OrientDB supports fetching strategies, called Fetch Plans, that allow you to customize how it loads linked records.  The aim of a Fetch Plan is to pre-load connected records in a single call, rather than several.  The best use of Fetch Plans is on records loaded through remote connections and when using JSON serializers to produce JSON with nested records.

>**NOTE** OrientDB handles circular dependencies to avoid any loops while it fetches linking records.

### Remote Connections

Under the default configuration, when a client executes a query or loads directly a single record to a remote database, it continues to send network calls for each linked record involved in the query, (that is, through `OLazyRecordList`).  You can mitigate this with a Fetch Plan.

When the client executes a query, set a Fetch Plan with a level different from `0`.  This causes the server to traverse all the records of the return result-set, sending them in response to a single call.  OrientDB loads all connected records into the local client, meaning that the collections remain lazy, but when accessing content, the record is loaded from the local cache to mitigate the need for additional connections.

## Examples using the Java APIs

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
SELECT @this.toJSON('fetchPlan:out_Friend:4') FROM #10:20
```

Export path in outgoing direction by removing all the incoming edges by using wildcards (Since 2.0):
```sql
SELECT @this.toJSON('fetchPlan:in_*:-2') FROM #10:20
```

>**NOTES:**:
>- To avoid looping, the record already traversed by fetching are exported only by their [RIDs](Concepts.md#recordid) (RecordID) form
>- "fetchPlan" setting is case sensitive


### Browse objects using a custom fetch plan

```java
for (Account a : database.browseClass(Account.class).setFetchPlan("*:0 addresses:-1")) {
  System.out.println( a.getName() );
}
```

>**NOTE:** Fetching Object will mean their presence inside your domain entities. So if you load an object using fetchplan `*:0` all LINK type references won't be loaded.
