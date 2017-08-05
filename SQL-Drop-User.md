---
search:
   keywords: ['SQL', 'DROP USER', 'command', 'drop', 'delete', 'user']
---

# SQL - `DROP USER`

Removes a user from the current database.  This feature was introduced in version 2.2

**Syntax**

```sql
DROP USER <user>
```

- **`<user>`** Defines the user you want to remove.


>**NOTE**: This is a wrapper on the class `OUser`.  For more information, see [Security](Security.md).


**Examples**

- Remove the user `Foo`:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP USER Foo</code>
  </pre>

>For more information, see,
>- [`CREATE USER`](SQL-Create-User.md)
>- [SQL commands](SQL.md)

