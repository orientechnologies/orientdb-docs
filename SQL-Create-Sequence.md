# SQL - CREATE SEQUENCE 

(Since v2.2)

Creates a new sequence.

## Syntax

```sql
CREATE SEQUENCE <sequence> TYPE <CACHED|ORDERED> [START <start>] [INCREMENT <increment>] [CACHE <cache>]
```

Where:
- `sequence` is the sequence name to create
- `TYPE` can be:
 - `CACHED`, where each call to the `.next()` will result in a new value
 - `ORDERED`, where the sequence will cache N items on each node, thus improving the performance if many `.next()` calls are required. However, this may create holes with numeration
- `start` set the initial value of the sequence
- `increment` set the value to increment when `.next()` is called
- `cache` set the number of values to pre-cache in case the sequence is of type CACHED

## See also
- [SQL Alter Sequence](SQL-Alter-Sequence.md)
- [SQL Drop Sequence](SQL-Drop-Sequence.md)
- [Sequences and auto increment](Sequences-and-auto-increment.md)

## Examples

### Create and use a new sequence to handle id numbers

```sql
CREATE SEQUENCE idseq TYPE ORDERED
INSERT INTO account SET id = sequence('idseq').next()
```

To know more about other SQL commands look at [SQL commands](SQL).

