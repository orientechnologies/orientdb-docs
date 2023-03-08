
# SQL - `ALTER SEQUENCE` 

Changes the sequence.  Using this parameter you can change all sequence options, except for the sequence type.

This feature was introduced in version 2.2.

**Syntax**

```sql
ALTER SEQUENCE <sequence> [START <start-point>] [INCREMENT <increment>] [CACHE <cache>] [CYCLE TRUE|FALSE] [LIMIT <limit_value>] [ASC|DESC]
```

- **`<sequence>`** Defines the sequence you want to change.
- **`START`** Defines the initial sequence value.
- **`INCREMENT`** Defines the value to increment when it calls `.next()`.
- **`CACHE`** Defines the number of values to cache, in the event that the sequence is of the type `CACHED`.
- **`CYCLE`** Defines if sequence will restart from `START` value after `LIMIT` value reached. Default value is `FALSE`.
- **`LIMIT`** Defines limit value sequence can reach. After limit value is reached cyclic sequences will restart from START value, while non cyclic sequences will throw message that limit is reached.
- **`ASC | DESC`** Defines order of the sequence. `ASC` defines that next sequence value will be <code class="lang-sql userinput">currentValue + incrementValue</code>, while `DESC` defines that next sequence value will be <code class="lang-sql userinput">currentValue - incrementValue</code> (assuming that limit is not reached). Default value is `ASC`.
- **`NOLIMIT`** Cancel previously defined `LIMIT` value 


**Examples**

- Alter a sequence, resetting the start value to `1000`:

  <pre>
  orientdb> <code class="lang-sql userinput">ALTER SEQUENCE idseq START 1000 CYCLE TRUE</code>
  </pre>


> For more information, see
>
>- [`CREATE SEQUENCE`](SQL-Create-Sequence.md)
>- [`DROP SEQUENCE`](SQL-Drop-Sequence.md)
>- [Sequences and Auto-increment](Sequences-and-auto-increment.md)
>- [SQL Commands](SQL-Commands.md).
