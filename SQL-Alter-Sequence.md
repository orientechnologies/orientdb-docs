# SQL - ALTER `SEQUENCE` 

Changes the sequence.  Using this parameter you can change all sequence options, except for the sequence type.

This feature was introduced in version 2.2.

**Syntax**

```sql
ALTER SEQUENCE <sequence> [START <start-point>] [INCREMENT <increment>] [CACHE <cache>]
```

- **`<sequence>`** Defines the sequence you want to change.
- **`START`** Defines the initial sequence value.
- **`INCREMENT`** Defines the value to increment when it calls `.next()`.
- **`CACHE`** Defines the number of values to cache, in the event that the sequence is of the type `CACHED`.


**Examples**

- Alter a sequence, resetting the start value to `1000`:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER SEQUENCE idseq START 1000</code>
  </pre>


> For more information, see
>
>- [`CREATE SEQUENCE`](SQL-Create-Sequence.md)
>- [`DROP SEQUENCE`](SQL-Drop-Sequence.md)
>- [Sequences and Auto-increment](Sequences-and-auto-increment.md)
>- [SQL Commands](SQL).
