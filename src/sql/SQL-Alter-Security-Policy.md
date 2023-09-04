
# SQL - `ALTER SECURITY POLICY`

Alters an existing security policy

A security resource is a set of SQL predicates, associated to basic operations (eg. CREATE, READ and so on), that are evaluated for each record to determine if the operation is allowed or not.

**Syntax**

```
ALTER SECURITY POLICY <name> 
[

  SET
  ( [CREATE | READ | BEFORE UPDATE | AFTER UPDATE | DELETE | EXECUTE] = (<sqlPredicate>) )*
]
[ 
  REMOVE [CREATE | READ | BEFORE UPDATE | AFTER UPDATE | DELETE | EXECUTE]*
]
```
- **`<name>`** The security policy name. It is used in the GRANT statement to bind it to a role and a resource
- **`<sqlPredicate>`** a valid SQL predicate

**Examples**


- Change CREATE and READ predicates for a security policy:

  <pre>
  <code class='lang-sql userinput'>ALTER SECURITY POLICY foo SET CREATE = (name = 'foo'), READ = (TRUE)</code>
  </pre>

- Remove CREATE and READ predicates for a security policy:

  <pre>
  <code class='lang-sql userinput'>ALTER SECURITY POLICY foo REMOVE CREATE, READ</code>
  </pre>



>See also
>- [SQL Commands](SQL-Commands.md).
>- [CREATE SECURITY POLICY](SQL-Create-Security-Policy.md).


