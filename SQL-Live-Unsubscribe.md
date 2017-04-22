---
search:
   keywords: ['SQL', 'LIVE UNSUBSCRIBE', 'live', 'unsubscribe', 'command']
---

# SQL - `LIVE UNSUBSCRIBE`

Disables a Live Query token so that it no longer receives updates from OrientDB.  To enable Live Queries, use [`LIVE SELECT`](SQL-Live-Select.md).  This feature was introduced in version 2.1 of OrientDB.

>**NOTE**: Currently, Live Queries are only supported in Java through the [Java API](Java-API.md) and in Node.js through the [OrientJS Driver](OrientJS.md).  The commands are not available through the Console.  For more general information, see [Live Queries](Live-Query.md).

**Syntax**

```sql
LIVE UNSUBSCRIBE <token>
```

- **`<token>`** Unique identifier for the Live Query you want to disable.

