# SQL - CREATE USER 

(Since v2.2)

Creates a user in the current database, with the specified password and an optional role.
Note that if a role isn't specified, a default role ("writer") is used.

Note this is simply a wrapper around OUser and ORole tables; Look up [Security](Security) for more details.

## Syntax

```sql
CREATE USER <user-name> IDENTIFIED BY <password> [ROLE <role-name>]
```

WHERE:
- `role-name` is the name of the role. To specify multiple roles pass an array of names. Example: `ROLES ['author','writer']`


## Examples

### Creates a new user called 'Foo', with password 'bar', and role 'admin'

```sql
create user Foo identified by bar role admin
```

### Creates a new user called 'Bar', with password 'Foo'
```sql
crete user Bar identified by Foo
```

To know more about other SQL commands look at [SQL commands](SQL).

## References
- [SQL Drop User](SQL-Drop-User.md)

