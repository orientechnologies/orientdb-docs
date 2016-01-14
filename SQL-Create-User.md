# SQL - `CREATE USER `

Creates a user in the current database, using the specified password and an optional role.  When the role is unspecified, it defaults to `writer`.  

The command was introduced in version 2.2.  It is a simple wrapper around the `OUser` and `ORole` classes.  More information is available at [Security](Security.md).

**Syntax**

```sql
CREATE USER <user> IDENTIFIED BY <password> [ROLE <role>]
```

- **`<user>`** Defines the logical name of the user you want to create.
- **`<password>`** Defines the password to use for this user.
- **`ROLE`** Defines the role you want to set for the user.  For multiple roles, use the following syntax: `['author', 'writer']`.

**Examples**

- Create a new admin user called `Foo` with the password `bar`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE USER Foo IDENTIFIED BY bar ROLE admin</code>
  </pre>

- Create a new user called `Bar` with the password `foo`:

  <pre>
  orientdb> <code class='lang-sql userinput'>CREATE USER Bar IDENTIFIED BY Foo</code>
  </pre>

>For more information, see
>
>- [Security](Security.md)
>- [`DROP USER`](SQL-Drop-User.md)
>- [SQL Commands](SQL.md)
