
# SQL - `DROP CLASS`

Removes a class from the schema.

**Syntax**

```sql
DROP CLASS <class> [ UNSAFE ]
```

- **`<class>`** Defines the class you want to remove.
- **`UNSAFE`** Defines whether the command drops non-empty edge and vertex classes.  Note, this can disrupt data consistency.  Be sure to create a backup before running it.



>**NOTE**: Bear in mind, that the schema must remain coherent.  For instance, avoid removing classes that are super-classes to others.  This operation won't delete the associated cluster.

**Examples**

- Remove the class `Account`:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP CLASS Account</code>
  </pre>


>For more information, see
>- [`CREATE CLASS`](SQL-Create-Class.md)
>- [`ALTER CLASS`](SQL-Alter-Class.md)
>- [`ALTER CLUSTER`](SQL-Alter-Cluster.md)
>- [SQL Commands](SQL-Commands.md)
>- [Console Commands](../console/Console-Commands.md)
