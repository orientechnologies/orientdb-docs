# Sequences and auto-increment

OrientDB doesn't support serial (autoincrement), so you can manage your own counter in this way (example using SQL):

```sql
create class counter
insert into counter set name='mycounter', value=0
```

And then every time you need a new number you can do:

```sql
UPDATE counter INCREMENT value = 1 WHERE name = 'mycounter'
```

This works in a SQL batch in this way:

```sql
BEGIN
let $counter = UPDATE counter INCREMENT value = 1 WHERE name = 'mycounter' return after
INSERT INTO items SET id = $counter.value, qty = 10, price = 1000
COMMIT
```

