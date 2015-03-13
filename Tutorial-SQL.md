# SQL

Most NoSQL products have a custom query language. OrientDB focuses on standards when it comes to query languages. Instead of inventing "Yet Another Query Language", we started from the widely used and well understood SQL. We then extended it to support more complex graph concepts like Trees and Graphs. Why SQL? SQL ubiquitous in the database developer world, it is familiar. Also, it is more readable and concise than Map Reduce scripts.

### Select

To start, let's write a query that returns the same result as the previous `browse cluster ouser` and `browse class ouser`:
```sql
select from OUser
```

Starting from this simple query, we can notice 2 interesting things:
- This query has no projections. This stands for "the entire record" like using the star (*).
- OUser is a class. By default queries are executed against classes.

The target can also be:
- a **cluster**, by prefixing with "cluster:". Example: `select from cluster:OUser`
- one or more **Record IDs**, by using the [RecordID](Concepts.md#recordId) directly. For example: `select from #10:3` or `select from [#10:1, #10:3, #10:5]`
- an **index**, by prefixing with "index:". For example: `select value from index:dictionary where key = 'Jay'`

Similar to standard SQL, OrientDB supports WHERE conditions to filter the returning records by specifying one or more conditions. For example:
```sql
select from OUser where name like 'l%'
```

Returns all OUser records where the name starts with 'l'. For more information, look at all the supported operators and functions: [SQL-Where](SQL-Where.md).

OrientDB also supports the `ORDER BY` clause to order the result set by one or more fields. For example:
```sql
select from Employee where city = 'Rome' order by surname asc, name asc
```

This will return all of the Employees who live in Rome, ordered by surname and name in ascending order. You can also use the `GROUP BY` clause to group results. For example:
```sql
select sum(salary) from Employee where age < 40 group by job
```
This returns the sum of the salaries of all the employees with age under 40 grouped by job type. To limit the result set you can use the `LIMIT` keyword. For example, to limit the result set to maximum of 20 items:
```sql
select from Employee where gender = 'male' limit 20
```
Thanks to the SKIP keyword you can easily manage pagination. Use SKIP to pass over records from the result set. For example, to divide the result set in 3 pages you could do something like:
```sql
select from Employee where gender = 'male' limit 20
select from Employee where gender = 'male' skip 20 limit 20
select from Employee where gender = 'male' skip 40 limit 20
```
Now that we have the basic skills to execute queries, let's discuss how to manage relationships.

### Insert
OrientDB supports ANSI-92 syntax:
```sql
insert into Employee (name, surname, gender) values ('Jay', 'Miner', 'M')
```

And the simplified:
```sql
insert into Employee set name = 'Jay', surname = 'Miner', gender = 'M'
```

Since OrientDB was created for the web, it can natively ingest JSON data:
```sql
insert into Employee content {name : 'Jay', surname : 'Miner', gender : 'M'}
```

### Update
The ANSI-92 syntax is supported. Example:
```sql
update Employee set local = true where city = 'London'
```

Also using JSON with the "merge" keyword to merge the input JSON with current record:

```sql
update Employee merge { local : true } where city = 'London'
```
### Delete
This also respects the ANSI-92 compliant syntax:
```sql
delete from Employee where city <> 'London'
```

