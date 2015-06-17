# Security

|![](images/warning.png)|Even thought OrientDB Server is a regular Web Server, for security reasons it's not recommended to expose it directly on the Internet or public networks. We suggest to always hide OrientDB server in a private network.|
|---|---|

The security model of OrientDB is based on well known concepts built on users and roles. A database has **users**. Each [User](#User) has one or more **roles**. A [Role](#Role) is a combination of the working mode (more later) and a set of permissions.

# Database security

![Security overview](http://www.orientdb.org/images/orientdb-dbsecurity.png)

## Users

A User is an actor of the database. When you open a database you need to specify the user name and password used. Each user has his own credentials and permissions.

By convention three users are always created by default each time you create a new database. Passwords are the same as the user name. Default users are:
- `admin`, with default password "`admin`", has access to all functions without limitation.
- `reader`, with default password "`reader`", is the classic read-only user. The `reader` can read any records but can't modify or delete them and has no access to internal information such as users and roles, themselves.
- `writer`, with the default password "`writer`", is like the user `reader` but can also create, update, and delete records.

Users are themselves records stored inside the cluster "OUser". The passwords are stored in hash format using the strong algorithm [SHA-256](http://en.wikipedia.org/wiki/SHA-2).

The user status is stored in the field `status` and can be: `SUSPENDED` or `ACTIVE`. Only `ACTIVE` users can log in.

### Working with users

To browse all the database's users use:
```sql
SELECT FROM ouser
```

To create a new user use the SQL `INSERT` remembering to assign the status `ACTIVE` and a valid role as in this example:

```sql
INSERT INTO ouser SET name = 'jay', password = 'JaY', status = 'ACTIVE', roles = (SELECT FROM ORole WHERE name = 'reader')
```

To change the user name use:

```sql
UPDATE ouser SET name = 'jay' WHERE name = 'reader'
```

In the same way, to change the user password use:

```sql
UPDATE ouser SET password = 'hello' WHERE name = 'reader'
```

The password will be saved in hash format using the algorithm SHA-256. The trigger `OUserTrigger` will encrypt the password transparently before the record is saved.

To disable a user change the status from `ACTIVE` to `SUSPENDED`. In this example we disable all the users but `admin`:

```sql
UPDATE ouser SET status= 'SUSPENDED' WHERE name <> 'admin'
```

## Roles

A role determines if an operation is permitted against a resource. Mainly this decision depends on the "working mode" and by "rules". Rules work differently based on the "working mode".

### Working with roles

#### Create a new role

To create a new role use the SQL `INSERT` remembering to assign the status `ACTIVE` and a valid role as in this example:

```sql
INSERT INTO orole SET name = 'developer', mode = 0
```

#### Inherited roles

Roles can inherit permissions from other roles in an object oriented fashion. To let a role extend another add the parent role in the `inheritedRole` attribute. Example, to let the `appuser` role inherit the `writer` role settings:

```sql
UPDATE orole SET inheritedRole = (SELECT FROM orole WHERE name = 'writer') WHERE name = 'appuser'
```

#### Working modes

The supported "working modes" are:

##### 1: allow all but (the rules)

By default this is the super user mode and exceptions are specified in the rules. If no rule is found for the requested resource, then it's allowed to execute the operation. You want to use this mode mainly for power users. The `admin` default role uses this mode and has no exception rules. This mode is written as `1` in the database.

##### 0: deny all but (the rules)

By default this mode can do nothing except for what rules are specified in the exceptions. This should be the default mode for all classic users. `reader` and `writer` default roles use this mode. This mode is written as `0` in the database.

#### Operations

The supported operations are the classic CRUD operations:
- ( **C** )reate
- ( **R** )ead
- ( **U** )pdate
- ( **D** )elete

A role can have none or all of the permissions above.
Each permission is internally represented by a flag of a 4 digit bitmask.
So the above permissions are:

```
NONE:   #0000 - 0
CREATE: #0001 - 1
READ:   #0010 - 2
UPDATE: #0100 - 4
DELETE: #1000 - 8
ALL:    #1111 - 15
```

Of course you could make a combination of them.
For example, if you want to allow only the Read and Update permissions, you could use:

```
READ:               #0010 - 1
UPDATE:             #0100 - 4
Permission to use:  #0110 - 5
```

### Resources

Resources are strings bound to OrientDB concepts.

>**NOTE**: resources are case-sensitive

- `database`
- `database.class`
- `database.class.<class-name>`
- `database.cluster`
- `database.cluster.<cluster-name>`
- `database.query`
- `database.command`
- `database.config`
- `database.hook.record`
- `server.admin`

Example:

To enable the `motorcyclist`role to have access to all classes but the `Car` class do this:

```sql
UPDATE orole PUT rules = "database.class.*", 15 WHERE name = "motorcyclist"
UPDATE orole PUT rules = "database.class.Car", 0 WHERE name = "motorcyclist"
```
>**NOTE**: resources are case-sensitive

## Grant and revoke permissions

To grant and revoke permissions use the [GRANT](SQL-Grant.md) and [REVOKE](SQL-Revoke.md) commands.

## Record-level security

This is also called "horizontal security" because it doesn't act at the schema level (vertically) but per each record. Due to this, we can totally separate database records as sand-boxes where each "Restricted" record can only be accessed by authorized users.

To activate this kind of advanced security, let the [classes](Concepts.md#class) you want extend the `ORestricted` super class. If you're working with a Graph Database you should let V (Vertex) and E (Edge) classes extend ORestricted class:

``` sql
ALTER CLASS V superclass ORestricted
ALTER CLASS E superclass ORestricted
```
In this way, all the vertices and edges will inherit the record level security.

Every time a class extends the `ORestricted` class, OrientDB, by a hook, injects a check before each CRUD operation:
- `CREATE` new document: set the current database's user in the `_allow` field. To change this behavior look at [Customize on creation](#Customize_on_creation)
- `READ` a document: check if the current user or its roles are enlisted in the `_allow` or `_allowRead` fields. If not, the record is skipped. This lets each query work per user.
- `UPDATE` a document: check if the current user or its roles are enlisted in the `_allow` or `_allowUpdate` field. If not, an `OSecurityException` is thrown.
- `DELETE` a document: check if the current user or its roles are enlisted in the `_allow` or `_allowDelete` field. If not, an `OSecurityException` is thrown

The "allow" fields (`_allow`, `_allowRead`, `_allowUpdate`, `_allowDelete`) can contain instances of `OUser` and `ORole` records (both classes extend OIdentity). Use `OUser` to allow a single [user](#User) and use `ORole` to allow all the users that are part of a [role](#Role).

### Customize on creation

By default every time someone creates a Restricted record (when its class extends the `ORestricted` class) the current user is inserted in the `_allow` field. This can be changed by setting custom properties in the class schema supporting these properties:
- `onCreate.fields`, to specify the names of the fields to set. By default it is `_allow` but you can specify `_allowRead`, `_allowUpdate`, or `_allowDelete` or a combination of them. Use a comma to separate multiple fields.
- `onCreate.identityType`, to specify if the user's object will be inserted or its role (the first one). By default is set to `user`, but you can also use `role`.

Example, to prevent a user from deleting a new post:

```sql
ALTER CLASS Post custom onCreate.fields=_allowRead,_allowUpdate
```

Example, to assign a role instead of a user to the new Post instances create:

```sql
ALTER CLASS Post custom onCreate.identityType=role
```

### Bypass security constraints
Sometimes you need to create a role that can bypass such restrictions, such as for backup or administrative operations. For this reason we've created the special permission `database.bypassRestricted` to `READ`. By default, the `admin` role has this permission.

This permission is not inheritable, so if you need to give such high privilege to other roles set it on each role.

### Use case

If you want to enable this security in a blog-like application, first create the document class, like `Post` that extends `ORestricted`, then if the user Luke creates a new post and the user Steve does the same, each user can't access the other's `Post`.

```sql
CONNECT remote:localhost/blog admin admin
CREATE CLASS Post EXTENDS ORestricted

Class 'Post' created successfully
```

The user `Luke`, registered as `OUser` `luke` having `RID` of `#5:5`, logs in and creates a new `Post`:
```sql
CONNECT remote:localhost/blog luke luke
INSERT INTO Post SET title = "Yesterday in Italy"

Created document #18:0
```

``` sql
SELECT FROM Post

 +-----+--------------+-----------------------+
 | RID | _allow       | title                 |
 +-----+--------------+-----------------------+
 |#18:0| [#5:5]       | Yesterday in Italy    |
 +-----+--------------+-----------------------+
```

Then the user Steve, registered as `OUser` `steve` having `RID` of `#5:6`, logs in too and creates a new `Post`:

```sql
CONNECT remote:localhost/blog steve steve
INSERT INTO Post SET title = "My Nutella cake"

Created document #18:1
```
```sql
SELECT FROM Post
 +-----+--------------+-----------------------+
 | RID | _allow       | title                 |
 +-----+--------------+-----------------------+
 |#18:1| [#5:6]       | My Nutella cake       |
 +-----+--------------+-----------------------+
```

Each user can only see the record that he has access to. Now, to allow the user Steve (RID `#5:6`) to have access to the first Luke's post, add Steve's RID in the `_allow` field:

```sql
CONNECT remote:localhost/blog luke luke
UPDATE #18:0 ADD _allow = #5:6
```

Now if Steve executes the same query as before, the result changes:

```sql
CONNECT remote:localhost/blog steve steve
SELECT FROM Post

 +-----+--------------+-----------------------+
 | RID | _allow       | title                 |
 +-----+--------------+-----------------------+
 |#18:0| [#5:5]       | Yesterday in Italy    |
 |#18:1| [#5:6]       | My Nutella cake       |
 +-----+--------------+-----------------------+
```

Now we would like to let Steve only read posts by Luke, without the rights to modify them. So we're going to remove Steve from the generic "_allow" field and insert his RID into the "_allowRead" field.:

```sql
CONNECT remote:localhost/blog luke luke
UPDATE #18:0 REMOVE _allow = #5:6
UPDATE #18:0 ADD _allowRead = #5:6
```

Now if Steve connects and displays all the Post instances, he will continue to display Luke's posts but he can't update or delete them.

```sql
CONNECT remote:localhost/blog steve steve
SELECT FROM Post

 +-----+--------------+-----------------------+
 | RID | _allow       | title                 |
 +-----+--------------+-----------------------+
 |#18:0| [#5:5]       | Yesterday in Italy    |
 |#18:1| [#5:6]       | My Nutella cake       |
 +-----+--------------+-----------------------+

DELETE FROM #18:0

 !Error: Cannot delete record #18:0 because the access to the resource is restricted
```

You can enable this feature even on graphs. Follow this tutorial to look how to create a [partitioned graph](Partitioned-Graphs.md).

# OrientDB Server security

A single OrientDB server can manage multiple databases at a time, each one with its own users. The HTTP protocol is handled by using different realms. This is the reason why each OrientDB Server instance has its own users to handle the server instance itself.

When the OrientDB Server starts it checks to see if there is already a `root` user configured. If not, it creates the `root` user and inserts it into the `config/orientdb-server-config.xml` file with an automatically generated very long password. Feel free to change the password, but restart the server to pick up the change.

The `root` user is in a section that looks like this:

```xml
<users>
  <user name="root"
        password="FAFF343DD54DKFJFKDA95F05A"
        resources="*" />
</users>
```

Since the password is not encrypted, whoever is installing OrientDB must protect the entire directory (not only config folder) to avoid access by unauthorized users.

## Server's resources

This section contains all the available server's resources. Each user can declare which resources have access. The wildcard `*` means any resources.  The `root`server user, by default, has all the privileges, so it can access all the managed databases.

| Resources | Description |
|-----------|-------------|
|`server.info`|Retrieves the server information and statistics|
|`server.listDatabases`|Lists the available databases on the server|
|`database.create`|Creates a new database in the server|
|`database.drop`|Drops a database|
|`database.passthrough`|Starting from 1.0rc7 the server's user can access all the managed databases if it has the resource `database.passthrough` defined. Example:`<user name="replicator" password="repl" resources="database.passthrough" />`|


## SSL Secure connections

Starting from v1.7, OrientDB supports [secure SSL connections](Using-SSL-with-OrientDB.md).

## Restore admin user

If the class `OUser` has been dropped or the `admin` user has been deleted, you can follow this procedure to restore your database:

1. Ensure the database is under the OrientDB Server's databases directory (`$ORIENTDB_HOME/databases/ folder`)

1. Open the Console or Studio and login into the database using `root` and the password contained in the file `$ORIENTDB_HOME/config/orientdb-server-config.xml`

1. Execute this query:

  ```sql
  SELECT FROM OUser WHERE name = 'admin'
  ```

1. If the class OUser doesn't exist, create it by executing:

  ```sql
  CREATE CLASS OUser EXTENDS OIdentity
  ```

1. If the class `OIdentity` doesn't exist, create it by executing:

  ```sql
  CREATE CLASS OIdentity
  ```
  And then retry to create the class `OUser` (5)

1. Now execute:

  ```sql
  SELECT FROM ORole WHERE name = 'admin'
  ```

1. If the class `ORole` doesn't exist, create it by executing:

  ```sql
  CREATE CLASS ORole EXTENDS OIdentity
  ```

1. If the role `admin` doesn't exist, create it by executing the following command:

  ```sql
  INSERT INTO ORole SET name = 'admin', mode = 1, rules = {"database.bypassrestricted":15}
  ```

1. If the user "admin" doesn't exist, create it by executing the following command:

  ```sql
  INSERT INTO OUser SET name = 'admin', password = 'admin', status = 'ACTIVE',
                      roles = (select from ORole where name = 'admin')
  ```

Now your `admin` user is active again.
