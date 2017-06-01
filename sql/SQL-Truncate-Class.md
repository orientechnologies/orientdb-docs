---
search:
   keywords: ['SQL', 'TRUNCATE CLASS', 'truncate', 'class']
---

# SQL - `TRUNCATE CLASS`

Deletes records of all clusters defined as part of the class.  

By default, every class has an associated cluster with the same name.  This command operates at a lower level than [`DELETE`](SQL-Delete.md).  This commands ignores sub-classes, (That is, their records remain in their clusters).  If you want to also remove all records from the class hierarchy, you need to use the `POLYMORPHIC` keyword.

Truncation is not permitted on vertex or edge classes, but you can force its execution using the `UNSAFE` keyword.  Forcing truncation is strongly discouraged, as it can leave the graph in an inconsistent state.

**Syntax**

```
TRUNCATE CLASS <class> [ POLYMORPHIC ] [ UNSAFE ] 
```

- **`<class>`** Defines the class you want to truncate.
- **`POLYMORPHIC`** Defines whether the command also truncates the class hierarchy.
- **`UNSAFE`** Defines whether the command forces truncation on vertex or edge classes, (that is, sub-classes that extend the classes `V` or `E`).

**Examples**

- Remove all records of the class `Profile`:

  <pre>
  orientdb> <code class='lang-sql userinput'>TRUNCATE CLASS Profile</code>
  </pre>

>For more information, see
>- [`DELETE`](SQL-Delete.md)
>- [`TRUNCATE CLUSTER`](SQL-Truncate-Cluster.md)
>- [`CREATE CLASS`](SQL-Create-Class.md)
>- [SQL Commands](SQL-Commands.md)
>- [Console Commands](../console/Console-Commands.md)
