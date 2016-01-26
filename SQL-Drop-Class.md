# SQL - `DROP CLASS`

Removes a class from the schema.

**Syntax**

```sql
DROP CLASS <class>
```

- **`<class>`** Defines the class you want to remove.


>**NOTE**: Bear in mind, that the schema must remain coherent.  For instance, avoid removing calsses that are super-classes to others.  This operation won't delete the associated cluster.

**Examples**

- Remove the class `Account`:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP CLASS Account</code>
  </pre>


>For more information, see
>- [`CREATE CLASS`](SQL-Create-Class.md)
>- [`ALTER CLASS`](SQL-Alter-Class.md)
>- [`ALTER CLUSTER`](SQL-Alter-Cluster.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
