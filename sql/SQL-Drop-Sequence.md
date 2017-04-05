---
search:
   keywords: ['SQL', 'DROP SEQUENCE', 'command', 'drop', 'delete', 'sequence']
---

# SQL - `DROP SEQUENCE`

Removes a sequence.  This feature was introduced in version 2.2.

**Syntax**

```sql
DROP SEQUENCE <sequence>
```

- **`<sequence>`** Defines the name of the sequence you want to remove.


**Examples**

- Remove the sequence `idseq`:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP SEQUENCE idseq</code>
  </pre>


>For more information, see
>- [`CREATE SEQUENCE`](SQL-Create-Sequence.md)
>- [`DROP SEQUENCE`](SQL-Drop-Sequence.md)
>- [Sequences and auto increment](Sequences-and-auto-increment.md)
>- [SQL Commands](SQL-Commands.md)
