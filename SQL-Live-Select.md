---
search:
   keywords: ['SQL', 'LIVE SELECT', 'live', 'select']
---

# SQL - `LIVE SELECT`

Enables a Live Query, returning a unique identifier token.  Through this token, your application can receive updates whenever [`INSERT`](SQL-Insert.md), [`DELETE`](SQL-Delete.md), or [`UPDATE`](SQL-Update.md) commands are issued against the given records.  This feature was introduced in version 2.1 of OrientDB.

>**NOTE**: Currently, Live Queries are only supported in Java through the [Java API](Java-API.md), and in Node.js through the [OrientJS Driver](orientjs/OrientJS.md).  It is not currently supported through the Console.  For more general information, see [Live Queries](Live-Query.md).

**Syntax**

```
LIVE SELECT FROM <target>
```

- **`FROM <target>`** Designates the object to register for live queries.  THis can be a class, cluster, single Record ID, set of Record ID's, or index values sorted by ascending or descending key order.
