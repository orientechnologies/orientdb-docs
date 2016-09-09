---
search:
   keywords: ['SQL', 'OPTIMIZE DATABASE', 'command', 'optimize', 'database']
---

# SQL - `OPTIMIZE DATABASE`

Optimizes the database for particular operations. 

**Syntax**

```sql
OPTIMIZE DATABASE [-lwedges] [-noverbose]
```

- **`-lwedges`** Converts regular edges into Lightweight Edges.
- **`-noverbose`** Disables output.

>Currently, this command only supports optimization for [Lightweight Edges](Lightweight-Edges.md).  Additional optimization options are planned for future releases of OrientDB.

**Examples**

- Convert regular edges into Lightweight Edges:

  <pre>
  orientdb> <code class="lang-sql userinput">OPTIMIZE DATABASE -lwedges</code>
  </pre>

>For more information, see
>- [Lightweight Edges](Lightweight-Edges.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
