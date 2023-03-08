
# Server Commands - `ALTER SYSTEM Role`

Alters the properties of an existing system user

**Syntax**

```sql
ALTER SYSTEM ROLE <roleName> [SET POLICY <policyName ON <resource>]* [REMOVE POLICY ON <resource>] 
```

- **`<roleName>`** A system role name
- **`<policyName>`** The name of a security policy
- **`<resource>`** A database resource, eg. `database.class.AClassName`

**Examples**

  <pre>
  orientdb> <code class='lang-sql userinput'>
  alter system role Foo  set policy bar on database.class.Person 
     set policy bar on database.class.Xx remove policy on database.class.Person
  </code>
  </pre>
