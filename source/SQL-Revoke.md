# SQL - REVOKE

The **SQL REVOKE** command changes the permission of a role revoking the access to one or more resources. It works as opposite to the [SQL GRANT](SQL-Grant.md) command.

## Syntax

```
REVOKE <permission> ON <resource> FROM <role>
```

Where:
- **permission** can be:
 - `NONE`, no permission
 - `CREATE`, to create the indicated resource
 - `READ`, to read the indicated resource
 - `UPDATE`, to update the indicated resource
 - `DELETE`, to delete the indicated resource
 - `ALL`, all permissions
- **resource**, the target resource where to change the permissions
 - `database`, as the access to the whole database
 - `database.class`, as the access to the records contained in a class. Use <code>**</code> to indicate all the classes
 - `database.cluster`, as the access to the records contained in a cluster. Use <code>**</code> to indicate all the clusters
 - `database.query`, as the ability to execute query (READ is enought)
 - `database.command`, as the ability to execute SQL commands. CREATE is for [INSERT](SQL-Insert.md), READ is for [SELECT](SQL-Query.md), UPDATE for [UPDATE](SQL-Update.md) and DELETE is for [DELETE](SQL-Delete.md)
 - `database.config`, as the ability to access to the configuration. Valid permissions are READ and UPDATE
 - `database.hook.record`, as the ability to set hooks
 - `server.admin`, as the ability to access to the server resources
- **role**, the role name

## Examples

Revoke the permission to *delete* any records in any *cluster* to the *role "backoffice"*.

```
REVOKE DELETE ON database.cluster.* TO backoffice
```

To know more about other SQL commands look at [SQL commands](SQL.md).
