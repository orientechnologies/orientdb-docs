
# Pagination

OrientDB supports pagination natively. Pagination doesn't consume server side resources because no cursors are used. Only [Record ID's](../datamodeling/Concepts.md#record-id) are used as pointers to the physical position in the cluster. 

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
- **lower-rid** is the exclusive lower bound of the range as [Record ID](../datamodeling/Concepts.md#record-id)
- **max-records** is the maximum number of records returned by the query

In this way, OrientDB will start to scan the cluster from the given position **lower-rid** + 1. After the first call, the **lower-rid** will be the rid of the last record returned by the previous call. To scan the cluster from the beginning, use `#-1:-1` as **lower-rid** .
