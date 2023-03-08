
# SQL - `LIVE SELECT`

Enables a Live Query.  Your application will receive updates whenever [`INSERT`](SQL-Insert.md), [`DELETE`](SQL-Delete.md), or [`UPDATE`](SQL-Update.md) commands are issued against the given records.  This feature was introduced in version 2.1 of OrientDB, but the corresponding Java API was refactored in v 3.0

>**NOTE**: Currently, Live Queries are only supported in Java through the [Java API](../java/Java-API.md), and in Node.js through the [OrientJS Driver](../orientjs/OrientJS.md).  It is not currently supported through the Console.  For more general information, see [Live Queries](../java/Live-Query.md).

**Syntax**

```
SELECT FROM <target> WHERE <filters>
```

- **`FROM <target>`** Designates the object to register for live queries.  THis can be a class, cluster, single Record ID, set of Record ID's, or index values sorted by ascending or descending key order.

