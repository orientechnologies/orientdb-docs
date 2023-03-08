
# SQL - `GRANT`

Changes the permission of a role, granting it access to one or more resources.  To remove access to a resource from the role, see the [`REVOKE`](SQL-Revoke.md) command.

**Syntax**

```
GRANT [ <permission> | POLICY <policyName> ] ON <resource> TO <role>
```

- **`<permission>`** Defines the permission you want to grant to the role.
- **`<policyName>`** Defines the name of a security policy
- **`<resource>`** Defines the resource on which you want to grant the permissions.
- **`<role>`** Defines the role you want to grant the permissions.

**Examples**

- Grant permission to update any record in the cluster `account` to the role `backoffice`:

  <pre>
  orientdb> <code class="lang-sql userinput">GRANT UPDATE ON database.cluster.account TO backoffice</code>
  </pre>
  
- Bind a security policy called `policy1` to Person class records, for the role `backoffice`:

  <pre>
  orientdb> <code class="lang-sql userinput">GRANT POLICY policy1 ON database.class.Person TO backoffice</code>
  </pre>  

>For more information, see
>- [`REVOKE](SQL-Revoke.md)
>- [SQL Commands](SQL-Commands.md)


## Supported Permissions

Using this command, you can grant the following permissions to a role.

| Permission | Description |
|---|---|
| `NONE` | Grants no permissions on the resource. |
| `CREATE` | Grants create permissions on the resource, such as the [`CREATE CLASS`](SQL-Create-Class.md) or [`CREATE CLUSTER`](SQL-Create-Cluster.md) commands.  |
| `READ` | Grants read permissions on the resource, such as the [`SELECT`](SQL-Query.md) query. |
| `UPDATE` | Grants update permissions on the resource, such as the [`UPDATE`](SQL-Update.md) or [`UPDATE EDGE`](SQL-Update.md) commands. |
| `DELETE` | Grants delete permissions on the resource, such as the [`DROP INDEX`](SQL-Drop-Index.md) or [`DROP SEQUENCE`](SQL-Drop-Sequence.md) commands. |
| `ALL` | Grants all permissions on the resource. |


## Supported Resources

Using this command, you can grant permissions on the following resources.

| Resource | Description |
|---|---|
| `database` | Grants access on the current database. |
| `database.class.<class>` | Grants access on records contained in the indicated class.  Use `**` to indicate all classes. |
| `database.class.<class>.<property>` | Grants access on a single property in the indicated class.  Use `**` to indicate all classes and/or all properties (this is intended only for security policies) |
| `database.cluster.<cluster>` | Grants access to records contained in the indicated cluster.  Use `**` to indicate all clusters.|
| `database.query` | Grants the ability to execute a query, (`READ` is sufficient).|
| `database.command.<command>` | Grants the ability to execute the given command.  Use `CREATE` for [`INSERT`](SQL-Insert.md), `READ` for [`SELECT`](SQL-Query.md), `UPDATE` for [`UPDATE`](SQL-Update.md) and `DELETE` for [`DELETE`](SQL-Delete.md).|
| `database.config.<permission>` | Grants access to the configuration.  Valid permissions are `READ` and `UPDATE`.|
| `database.hook.record` | Grants the ability to set hooks. |
| `server.admin` | Grants the ability to access server resources.|


Policy assignment is supported for records only, so you can assign security policies to `class` and `property` resources 
