---
search:
   keywords: ['SQL', 'TRUNCATE RECORD', 'truncate', 'record']
---

# SQL - `TRUNCATE RECORD`

Deletes a record or records without loading them.  Useful in cases where the record is corrupted in a way that prevents OrientDB from correctly loading it.

**Syntax**

```
TRUNCATE RECORD <record-id>*
```

- **`<record-id>`** Defines the Record ID you want to truncate.  You can also truncate multiple records using a comma-separated list within brackets.

This command returns the number of records it truncates.


**Examples**

- Truncate a record:

  <pre>
  orientdb> <code class='lang-sql userinput'>TRUNCATE RECORD 20:3</code>
  </pre>

- Truncate three records together:

  <pre>
  orientdb> <code class="lang-sql userinput">TRUNCATE RECORD [20:0, 20:1, 20:2]</code>
  </pre>

>For more information, see
>- [`DELETE`](SQL-Delete.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
