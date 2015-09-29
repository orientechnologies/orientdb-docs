# SQL - ALTER SEQUENCE 

(Since v2.2)

Alters a sequence. All the settings can be changed, but the sequence type.

## Syntax

```sql
ALTER SEQUENCE <sequence> [START <start>] [INCREMENT <increment>] [CACHE <cache>]
```

Where:
- `sequence` is the sequence name to alter
- `start` set the initial value of the sequence
- `increment` set the value to increment when `.next()` is called
- `cache` set the number of values to pre-cache in case the sequence is of type CACHED

## See also
- [SQL Create Sequence](SQL-Create-Sequence.md)
- [SQL Drop Sequence](SQL-Drop-Sequence.md)
- [Sequences and auto increment](Sequences-and-auto-increment.md)

## Examples

### Alter a sequence by resetting the value to 1000

```sql
ALTER SEQUENCE idseq START 1000
```

To know more about other SQL commands look at [SQL commands](SQL).
