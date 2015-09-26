## Sequences and auto increment
Starting from v2.2, OrientDB supports sequences like most of RDBMS. What's a sequence? It's a structure that manage counters. Sequences are mostly used when you need a number that always increments.

### Usage

#### Create a sequence
```sql
CREATE SEQUENCE <sequence> [TYPE <CACHED|ORDERED>] [START <value>] [INCREMENT <value>] [CACHE <value>]
```

Sequence types:
 * Ordered: Each call to .next() will result in a new value.
 * Cached: The sequence will cache N items on each node, thus improving the performance if many .next() calls are required. 
However, this may create holes.

#### Drop a sequence
```sql
DROP SEQUENCE <sequence>
```

#### Using a sequence
```sql
SELECT #<sequence>.<function>
```
Where:
- `function` can be:
 - `next()` retrieves the next value
 - `current()` gets the current value
 - `reset()` resets the sequence value to it's initial value

# OrientDB before v2.2

OrientDB before v2.2 doesn't support sequences (autoincrement), so you can manage your own counter in this way (example using SQL):

```sql
CREATE CLASS counter
INSERT INTO counter SET name='mycounter', value=0
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

