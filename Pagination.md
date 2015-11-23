OrientDB supports pagination natively. Pagination doesn't consume server side resources because no cursors are used. Only [RecordIDs](Concepts.md#recordid) are used as pointers to the physical position in the cluster. 

There are 2 ways to achieve pagination:

## Use the SKIP-LIMIT

The first and simpler way to do pagination is to use the `SKIP`/`LIMIT` approach. This is the slower way because OrientDB repeats the query and just skips the first X records from the result.
Syntax:
```sql
SELECT FROM <target> [WHERE ...] SKIP <records-to-skip> LIMIT <max-records>
```
Where:
- **records-to-skip** is the number of records to skip before starting to collect them as the result set
- **max-records** is the maximum number of records returned by the query

Example
## Use the RID-LIMIT

This method is faster than the `SKIP`-`LIMIT` because OrientDB will begin the scan from the starting RID. OrientDB can seek the first record in about O(1) time. The downside is that it's more complex to use.

The trick here is to execute the query multiple times setting the `LIMIT` as the page size and using the greater than `>` operator against `@rid`. The **lower-rid** is the starting point to search, for example `#10:300`.

Syntax:
```sql
SELECT FROM <target> WHERE @rid > <lower-rid> ... [LIMIT <max-records>]
```

Where:
- **lower-rid** is the exclusive lower bound of the range as [RecordID](Concepts.md#recordid)
- **max-records** is the maximum number of records returned by the query

In this way, OrientDB will start to scan the cluster from the given position **lower-rid** + 1. After the first call, the **lower-rid** will be the rid of the last record returned by the previous call. To scan the cluster from the beginning, use `#-1:-1` as **lower-rid** .

### Handle it by hand

```java
database.open("admin", "admin");
final OSQLSynchQuery<ODocument> query = new OSQLSynchQuery<ODocument>("select from Customer where @rid > ? LIMIT 20");

List<ODocument> resultset = database.query(query, new ORecordId());
    
while (!resultset.isEmpty()) {
    ORID last = resultset.get(resultset.size() - 1).getIdentity();
    
    for (ODocument record : resultset) {
        // ITERATE THE PAGINATED RESULT SET
    }

    resultset = database.query(query, last);
}
database.close();
```

### Automatic management

In order to simplify the pagination, the `OSQLSynchQuery` object (usually used in queries) keeps track of the current page and, if executed multiple times, it advances page to page automatically without using the `>` operator.

Example:

```java
OSQLSynchQuery<ODocument> query = new OSQLSynchQuery<ODocument>("select from Customer LIMIT 20");
for (List<ODocument> resultset = database.query(query); !resultset.isEmpty(); resultset = database.query(query)) {
    ...
}
```

## Usage of indexes

This is the faster way to achieve pagination with large clusters.

If you've defined an index, you can use it to paginate results. An example is to get all the names next to `Jay` limiting it to 20:
```java
Collection<ODocument> indexEntries = (Collection<ODocument>) index.getEntriesMajor("Jay", true, 20);
```
