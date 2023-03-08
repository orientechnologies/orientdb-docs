---
search:
   keywords: ['SQL', 'command', 'create', 'database', 'CREATE DATABASE']
---

# Server Commands - `CREATE DATABASE`

Creates a database on the current environment/server

**Syntax**

CREATE DATABASE foo plocal users (foo identified by 'pippo' role admin, reader identified by ? role [reader, writer])
```sql
CREATE DATABASE <dbName> <type> [ USERS (<username> IDENTIFIED BY <password> ROLE <roleName>)*] [<configJson>]
```

- **`<dbName>`** The database name
- **`<type>`** `plocal` or `memory` 
- **`<username>`** the name of a user to add to the database
- **`<password>`** the password of a user to add to the database
- **`<roleName>`** the name of a role to assign to the user added to the database
- **`<configJson>`** the custom configuration for current db

**Examples**

- Create a DB:

  <pre>
  orientdb> <code class='lang-sql userinput'>CREATE DATABASE foo plocal</code>
  </pre>

- Create a DB with custom users:

  <pre>
  orientdb> <code class='lang-sql userinput'>CREATE DATABASE foo plocal users (foo identified by 'pippo' role admin, reader identified by ? role [reader, writer])</code>
  </pre>


- Create a DB with legacy default users:

  <pre>
  orientdb> <code class='lang-sql userinput'>CREATE DATABASE foo plocal {"config":{"security.createDefaultUsers": true}} </code>
  </pre>




