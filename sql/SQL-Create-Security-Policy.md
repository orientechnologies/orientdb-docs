---
search:
   keywords: ['SQL', 'CREATE', 'SECURITY', 'POLICY']
---

# SQL - `CREATE SECURITY POLICY`

Creates a security policy that can be bound to one or more security resources, for one or more roles.  

A security resource is a set of SQL predicates, associated to basic operations (eg. CREATE, READ and so on), that are evaluated for each record to determine if the operation is allowed or not.

**Syntax**

```
CREATE SECURITY POLICY <name> 
[
  SET
  ( [CREATE | READ | BEFORE UPDATE | AFTER UPDATE | DELETE | EXECUTE] = (<sqlPredicate>) )*
```
- **`<name>`** The security policy name. I is used in the GRANT statement to bind it to a role and a resoruce
- **`<sqlPredicate>`** a valid SQL predicate

**Examples**

- Create an empty policy

  <pre>
  <code class='lang-sql userinput'>CREATE SECURITY POLICY foo</code>
  </pre>

- Create a security policy with all the predicates defined:

  <pre>
  <code class='lang-sql userinput'>CREATE SECURITY POLICY foo SET CREATE = (name = 'foo'), READ = (TRUE), BEFORE UPDATE = (name = 'foo'), AFTER UPDATE = (name = 'foo'), DELETE = (name = 'foo'), EXECUTE = (name = 'foo')</code>
  </pre>



>For more information, see
>- [SQL Commands](SQL-Commands.md).

