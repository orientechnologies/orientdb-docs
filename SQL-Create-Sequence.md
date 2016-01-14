# SQL - `CREATE SEQUENCE`

Creates a new sequence.  Command introduced in version 2.2.

**Syntax**

```
CREATE SEQUENCE <sequence> TYPE <CACHED|ORDERED> [START <start>] 
[INCREMENT <increment>] [CACHE <cache>]
```
- **`<sequence>`** Logical name for the sequence to cache.
- **`TYPE`** Defines the sequence type.  Supported types are,
  - `CACHED` For sequences where it draws on a new value with each call to the `.next()` method.
  - `ORDERED` For sequences where it caches N items on each node to improve performance when you require many calls to the `.next()` method.  (Bear in mind, this many create holes with numeration).
- **`START`** Defines the initial value of the sequence.
- **`INCREMENT`** Defines the increment for each call of the `.next()` method.
- **`CACHE`** Defines the number of value to pre-cache, in the event that you use the cached sequence type.

**Examples**

- Create a new sequence to handle id numbers:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE SEQUENCE idseq TYPE ORDERED</code>
  </pre>

- Use the new sequence to insert id values

  <pre>
  orientdb> <code class="lang-sql userinput">INSERT INTO Account SET id = sequence('idseq').next()</code>
  </pre>

>For more information, see
>
>- [`ALTER SEQUENCE`](SQL-Alter-Sequence.md)
>- [DROP SEQUENCE](SQL-Drop-Sequence.md)
>- [Sequences and Auto-increment](Sequences-and-auto-increment.md)
>- [SQL commands](SQL).

