<!-- proofread 2015-11-26 SAM -->
# Distributed queues use case

Implementing a persistent, distributed and transactional queue system using OrientDB is possible and easy. Besides the fact you don't need a specific API accomplish a queue, there are multiple approaches you can follow depending by your needs. The easiest way is using OrientDB SQL, so this works wit any driver.

Create the queue class first:

```sql
create class queue
```

You could have one class per queue. Example of push operation:

```sql
insert into queue set text = "this is the first message", date = date()
```

Since OrientDB by default keeps the order of creation of records, a simple delete from the queue class with limit = 1 gives to you the perfect pop:

```sql
delete from queue return before limit 1
```

The "return before" allows you to have the deleted record content. If you need to peek the queue, you can just use the select:

```sql
select from queue limit 1
```

That's it. Your queue will be persistent, if you want transactional and running in cluster distributed.
