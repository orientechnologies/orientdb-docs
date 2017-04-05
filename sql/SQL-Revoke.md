---
search:
   keywords: ['SQL', 'REVOKE', 'revoke']
---

# SQL - `REVOKE`

Changes permissions of a role, revoking access to one or more resources.  To give access to a resource to the role, see the [`GRANT`](SQL-Grant.md) command.

**Syntax**

```
REVOKE <permission> ON <resource> FROM <role>
```
- **`<permission>`** Defines the permission you want to revoke from the role.
- **`<resource>`** Defines the resource on which you want to revoke the permissions.
- **`<role>`** Defines the role you want to revoke the permissions.

**Examples**

- Revoke permission to delete records on any cluster to the role `backoffice`:

  <pre>
  orientdb> <code class='lang-sql userinput'>REVOKE DELETE ON database.cluster.* FROM backoffice</code>
  </pre>


>For more information, see
>- [SQL Commands](SQL-Commands.md).


## Supported Permissions

Using this command, you can grant the following permissions to a role.

| Permission | Description |
|---|---|
| `NONE` | Revokes no permissions on the resource. |
| `CREATE` | Revokes create permissions on the resource, such as the [`CREATE CLASS`](SQL-Create-Class.md) or [`CREATE CLUSTER`](SQL-Create-Cluster.md) commands.  |
| `READ` | Revokes read permissions on the resource, such as the [`SELECT`](SQL-Query.md) query. |
| `UPDATE` | Revokes update permissions on the resource, such as the [`UPDATE`](SQL-Update.md) or [`UPDATE EDGE`](SQL-Update.md) commands. |
| `DELETE` | Revokes delete permissions on the resource, such as the [`DROP INDEX`](SQL-Drop-Index.md) or [`DROP SEQUENCE`](SQL-Drop-Sequence.md) commands. |
| `ALL` | Revokes all permissions on the resource. |


## Supported Resources

Using this command, you can grant permissions on the following resources.

| Resource | Description |
|---|---|
| `database` | Revokes access on the current database. |
| `database.class.<class>` | Revokes access on records contained in the indicated class.  Use `**` to indicate all classes. |
| `database.cluster.<cluster>` | Revokes access to records contained in the indicated cluster.  Use `**` to indicate all clusters.|
| `database.query` | Revokes the ability to execute a query, (`READ` is sufficient).|
| `database.command.<command>` | Revokes the ability to execute the given command.  Use `CREATE` for [`INSERT`](SQL-Insert.md), `READ` for [`SELECT`](SQL-Query.md), `UPDATE` for [`UPDATE`](SQL-Update.md) and `DELETE` for [`DELETE`](SQL-Delete.md).|
| `database.config.<permission>` | Revokes access to the configuration.  Valid permissions are `READ` and `UPDATE`.|
| `database.hook.record` | Revokes the ability to set hooks. |
| `server.admin` | Revokes the ability to access server resources.|

