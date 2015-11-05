# Sequences and auto increment
Starting from v2.2, OrientDB supports sequences like most of RDBMS. What's a sequence? It's a structure that manage counters. Sequences are mostly used when you need a number that always increments. Sequence types can be:
- **ORDERED**: each call to `.next()` will result in a new value.
- **CACHED**: the sequence will cache N items on each node, thus improving the performance if many `.next()` calls are required. However, this may create holes.

To manipulate sequences you can use the Java API or SQL commands.

## Create a sequence

### Create a sequence with Java API
```java
OSequenceLibrary sequenceLibrary = database.getMetadata().getSequenceLibrary();
OSequence seq = sequenceLibrary.createSequence("idseq", SEQUENCE_TYPE.ORDERED, new OSequence.CreateParams().setStart(0));
```

### SQL CREATE SEQUENCE
```sql
CREATE SEQUENCE idseq
INSERT INTO account SET id = sequence('idseq').next()
```

For more information look at [SQL CREATE SEQUENCE](SQL-Create-Sequence.md).

## Using a sequence

### Using a sequence with Java API
```java
OSequence seq = graph.getRawGraph().getMetadata().getSequenceLibrary().getSequence("idseq");
graph.addVertex("class:Account", "id", seq.next());
```

### Using a sequence from SQL
You can use a sequence from SQL with the following syntax:

```sql
sequence('<sequence>').<method>
```

Where:
- `method` can be:
 - `next()` retrieves the next value
 - `current()` gets the current value
 - `reset()` resets the sequence value to it's initial value

Example
```sql
INSERT INTO Account SET id = sequence('mysequence').next()
```

## Alter a sequence

## Alter a sequence with Java API

```java
graph.getRawGraph().getMetadata().getSequenceLibrary().getSequence("idseq").updateParams( new OSequence.CreateParams().setStart(1000) );
```

### SQL ALTER SEQUENCE
```sql
ALTER SEQUENCE idseq START 1000
```

For more information look at [SQL ALTER SEQUENCE](SQL-Alter-Sequence.md).

## Drop a sequence

### Drop a sequence with Java API
```java
graph.getRawGraph().getMetadata().getSequenceLibrary().dropSequence("idseq");
```

### SQL DROP SEQUENCE

```sql
DROP SEQUENCE idseq
```

For more information look at [SQL DROP SEQUENCE](SQL-Drop-Sequence.md).

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
let $counter = UPDATE counter INCREMENT value = 1 return after $current WHERE name = 'mycounter'
INSERT INTO items SET id = $counter.value[0], qty = 10, price = 1000
COMMIT
```

