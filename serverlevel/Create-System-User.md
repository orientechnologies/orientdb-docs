---
search:
   keywords: ['SQL', 'command', 'alter', 'class', 'ALTER CLASS']
---

# Server Commands - `CREATE SYSTEM USER`

Creates a System user 

**Syntax**

```sql
CREATE SYSTEM USER <userName> IDENTIFIED BY <password> ROLE <role>
```

- **`<userName>`** the user name
- **`<password>`** the password
- **`<role>`** an existing role name

**Examples**

- Create a system user with one role:

  <pre>
  orientdb> <code class='lang-sql userinput'>CREATE SYSTEM USER test IDENTIFIED BY 'foo' ROLE admin</code>
  </pre>
  
- Create a system user with multiple roles:

  <pre>
  orientdb> <code class='lang-sql userinput'>CREATE SYSTEM USER test IDENTIFIED BY 'foo' ROLE [reader, writer] </code>
  </pre>
