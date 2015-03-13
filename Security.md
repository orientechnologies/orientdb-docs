# Security

The security model of OrientDB is based on well known concepts built on users and roles. A database has **"users"**. Each [User](#User) has one or more **"roles"**. [Role](#Role) is compound by the mode of working (more later) and the set of permission rules.

# Database security

![Security overview](http://www.orientdb.org/images/orientdb-dbsecurity.png)

## Users

A User is an actor of the database. When you open a database you need to specify the user name and password used. Each user has own credentials and permissions.

By convention 3 users are always created by default every time you create a new database. Passwords are the same as the user name. Default users are:
- **admin**, with default password "admin", has access to all the functions without limitation
- **reader**, with default password "reader", is the classic read-only user. Can read any records but can't modify or delete them. Can't access to internal information such as user and role themselves.
- **writer**, with the default password "writer", is like the "reader" but can also create, update and delete records.

Users are themselves records stored inside the cluster "OUser". The passwords are stored in hash format using the strong algorithm [SHA-256](http://en.wikipedia.org/wiki/SHA-2).

The user status is stored in the field "status" and can be: "SUSPENDED" and "ACTIVE". Only ACTIVE users can log in.

### Work with users

To browse all the database's users use:
```sql
select from ouser
```

To create a new user use the SQL INSERT remembering to assign the status 'ACTIVE' and a valid role as in this example:
```sql
insert into ouser set name = 'jay', password = 'JaY', status = 'ACTIVE', roles = (select from ORole where name = 'reader')
```

To change the user name use:
```sql
update ouser set name = 'jay' where name = 'reader'
```

In the same way to change the user password use:
```sql
update ouser set password = 'hello' where name = 'reader'
```

The password will be saved in hash format using the algorithm SHA-256. The trigger "OUserTrigger" will encrypt the password transparently before the record is saved.

To disable a user change the status from 'ACTIVE' to 'SUSPENDED'. In this example we disable all the users but "admin":
```sql
update ouser set status= 'SUSPENDED' where name <> 'admin'
```

## Roles

A role decides if it's allowed to execute an operation against a resource. Mainly this decision depends by the "working mode" and by the "rules". Rules work differently based on the "working mode".

### Working with roles

#### Create a new role

To create a new role use the SQL INSERT remembering to assign the status 'ACTIVE' and a valid role as in this example:
```sql
insert into orole set name = 'developer', mode = 0
```

#### Inherited roles
Roles can inherit permissions from other roles in a Object Oriented fashion. To let a role extend another one add the parent role in the "inheritedRole" attribute. Example to let "appuser" role to inherit the "writer" role settings:

```sql
update orole set inheritedRole = (select from orole where name = 'writer') where name = 'appuser'
```

#### Working modes

The supported "working modes" are:

##### 1: allow all but (the rules)

By default is a super user and exceptions are enlisted in the rules. If no rule is found for the requested resource, then it's allowed to execute the operation. Use this mainly for power users. "Admin" default role uses this mode and has no exception rules. This mode is written as "1" in database.

##### 0: deny all but (the rules)

By default it can't make nothing but the exceptions enlisted in the rules. This should be the default mode for all classic users. "Reader" and "Writer" default roles use this mode. This mode is written as "0" in database.

#### Operations

The supported operations are the classic CRUD operations:
- ( **C** )reate
- ( **R** )ead
- ( **U** )pdate
- ( **D** )elete

A role can have none or all the permissions above.
Each permission is internally represented by a flag of a 4 digit bitmask.
So the above permissions are:

    NONE:   #0000 - 0
    CREATE: #0001 - 1
    READ:   #0010 - 2
    UPDATE: #0100 - 4
    DELETE: #1000 - 8
    ALL:    #1111 - 15


Of course you could make a combination of them.
For example, if you want to allow only the Read and Update permissions, you could use

    READ:               #0010 - 1
    UPDATE:             #0100 - 4
    Permission to use:  #0110 - 5

### Resources

Resources are strings bound to OrientDB concepts. _Note: resources are case sensitive_:
- <code>database</code>
- <code>database.class</code>
- <code>database.class.&lt;class-name&gt;</code>
- <code>database.cluster</code>
- <code>database.cluster.&lt;cluster-name&gt;</code>
- <code>database.query</code>
- <code>database.command</code>
- <code>database.config</code>
- <code>database.hook.record</code>
- <code>server.admin</code>

Example:

Enable to the role "motorcyclist" the access to all the classes but the "Car" class:
```sql
update orole put rules = "database.class.*", 15 where name = "motorcyclist"
update orole put rules = "database.class.Car", 0 where name = "motorcyclist"
```
_Note: resources are case sensitive_

## Grant and revoke permissions

To grant and revoke permissions use the [SQLGrant](SQL-Grant.md) and [SQLRevoke](SQL-Revoke.md) commands.

## Record level security

This is also called "horizontal security" because it doesn't act at schema level (vertically), but per each record. Due to this, we can totally separate the database records as sand-boxes where each "Restricted" records can't be accessed by non authorized users.

To activate this kind of advanced security, let the [classes](Concepts.md#class) you want extend the **ORestricted** super class. If you're working with a Graph Database you should let V (Vertex) and E (Edge) classes extend ORestricted class:

    alter class V superclass ORestricted
    alter class E superclass ORestricted

In this way, all the vertices and edges will inherit the record level security.

Every time a class extends the **ORestricted** class, OrientDB, by a hook, injects a check before each CRUD operation:
- **CREATE** new document: set the current database's user in the **<code>_allow</code>** field. To change this behavior look at [Customize on creation](#Customize_on_creation)
- **READ** a document: check if the current user or its roles are enlisted in the **<code>_allow</code>** or **<code>_allowRead</code>** fields. If not the record is skipped. This let each queries to work per user basis
- **UPDATE** a document: check if the current user or its roles are enlisted in the **<code>_allow</code>** or **<code>_allowUpdate</code>** field. If not a OSecurityException is thrown
- **DELETE** a document: check if the current user or its roles are enlisted in the **<code>_allow</code>** or **<code>_allowDelete</code>** field. If not a OSecurityException is thrown

The "allow" fields (**<code>_allow</code>**, **<code>_allowRead</code>**, **<code>_allowUpdate</code>**, **<code>_allowDelete</code>**) can contain instances of **OUser** and **ORole** records (both classes extends OIdentity). Use **OUser** to allow single [users](#User) and **ORole** to allow all the users that are part of these [roles](#Role).

### Customize on creation

By default everytime someone creates a Restricted record (when its class extends the ORestricted class) the current user is inserted in the "<code>_allow</code>" field. This can be changed by setting custom properties in the class schema supporting these properties:
- **onCreate.fields**, to specify the names of the fields to set. By default is "<code>_allow</code>" but you can specify here "<code>_allowRead</code>", "<code>_allowUpdate</code>" and "<code>_allowDelete</code>" or a combination of them. Use the comma to separate multiple fields
- **onCreate.identityType**, to specify if the user's object will be inserted or its role (the first one). By default is set "user", but you can also use "role"

Example to avoid the user can delete a new post:
```sql
orientdb> alter class Post custom onCreate.fields=_allowRead,_allowUpdate
```

Example to assign its role instead of user to the new Post instances created:
```sql
orientdb> alter class Post custom onCreate.identityType=role
```

### Bypass security constraints
Sometimes you need to create a role that can bypass such restrictions, such as backup or administrative operations. For such reason we've created the special permission `database.bypassRestricted` to READ. By default, the "admin" role has such permission.

This permission is not inheritable, so if you need to give such high privilege to other roles set it to each role.

### Use case

You want to enable this security in a BLOG like application. First create the document class, like "Post" that extends "ORestricted". Then if the user "Luke" creates a new post and the user "Steve" does the same, each user can't access the Post instances created by each other.

```sql
orientdb> connect remote:localhost/blog admin admin
orientdb> create class Post extends ORestricted
Class 'Post' created successfully
```

The user "Luke", registered as OUser "luke" having RID #5:5, logs in and create a new Post:
```sql
orientdb> connect remote:localhost/blog luke luke
orientdb> insert into Post set title = "Yesterday in Italy"
Created document #18:0

orientdb> select from Post
+-----+--------------+-----------------------+
| RID | _allow       | title                 |
+-----+--------------+-----------------------+
|#18:0| [#5:5]       | Yesterday in Italy    |
+-----+--------------+-----------------------+
```

Then the user Steve, registered as OUser "steve" having RID #5:6, logs in too and create a new Post:
```sql
orientdb> connect remote:localhost/blog steve steve
orientdb> insert into Post set title = "My Nutella cake"
Created document #18:1

orientdb> select from Post
+-----+--------------+-----------------------+
| RID | _allow       | title                 |
+-----+--------------+-----------------------+
|#18:1| [#5:6]       | My Nutella cake       |
+-----+--------------+-----------------------+
```

Each user can see only the record where they have access. Now try to allow the user Steve (rid #5:6) to access to the first Luke's post adding the Steve's RID in the **<code>_allow</code>** field:

```sql
orientdb> connect remote:localhost/blog luke luke
orientdb> update #18:0 add _allow = #5:6
```

Now if Steve executes the same query as before, the result changes:
```sql
orientdb> connect remote:localhost/blog steve steve
orientdb> select from Post
+-----+--------------+-----------------------+
| RID | _allow       | title                 |
+-----+--------------+-----------------------+
|#18:0| [#5:5]       | Yesterday in Italy    |
|#18:1| [#5:6]       | My Nutella cake       |
+-----+--------------+-----------------------+
```

Now we would like to let Steve only read posts by Luke, without the rights to modify them. So we're going to remove Steve from the generic "_allow" field to insert into the "_allowRead":

```sql
orientdb> connect remote:localhost/blog luke luke
orientdb> update #18:0 remove _allow = #5:6
orientdb> update #18:0 add _allowRead = #5:6
```

Now if Steve connects and displays all the Post instances he will continue to display the Luke's post but can't update or delete them.

```sql
orientdb> connect remote:localhost/blog steve steve
orientdb> select from Post
+-----+--------------+-----------------------+
| RID | _allow       | title                 |
+-----+--------------+-----------------------+
|#18:0| [#5:5]       | Yesterday in Italy    |
|#18:1| [#5:6]       | My Nutella cake       |
+-----+--------------+-----------------------+

orientdb> delete from #18:0
!Error: Cannot delete record #18:0 because the access to the resource is restricted
```

You can enable this feature even on graphs. Follow this tutorial to look how to create a [partitioned graph](Partitioned-Graphs.md).

# OrientDB Server security

A single OrientDB server can manage several databases per time, each one with its users. In HTTP protocol is handled by using different realms. This is the reason why OrientDB Server instance has its own users to handle the server instance itself.

When the OrientDB Server starts check if there is configured the "root" user. If not creates it into the config/orientdb-server-config.xml file with an automatic generated very long password. Feel free to change the password, but restart the server to get the changes.

It is in a section that should look like this:

`<users>
   <user name="root"
         password="FAFF343DD54DKFJFKDA95F05A"
         resources="*" />
 </users>`

Since the passwords are in clear, who is installing OrientDB have to protect the entire directory (not only config folder) to avoid any access to the not authorized users.
<a name="serverResources"/>
## Server's resources

This section contains all the available server's resources. Each user can declare which resources have access. Wildcard <code>*</code> means any resources. **root** server user, by default, has all the privileges, so it can access to all the managed databases.

<table>
  <tr><th>Resource</th><th>Description</th></tr>
  <tr><td>server.info</td><td>Retrieves the server information and statistics</td></tr>
  <tr><td>server.listDatabases</td><td>Lists the available databases on the server</td></tr>
  <tr><td>database.create</td><td>Creates a new database in the server</td></tr>
  <tr><td>database.drop</td><td>Drops a database</td></tr>
  <tr><td>database.passthrough</td><td>Starting from 1.0rc7 the server's user can access to all the managed databases if has the resource **database.passthrough** defined. Example:<code>&lt;user name="replicator" password="repl" resources="database.passthrough" /&gt;</code></td></tr>
</table>

## SSL Secure connections

Starting from v1.7 OrientDB support [secure SSL connections](Using-SSL-with-OrientDB.md).

## Restore admin user

If the class OUser has been dropped or the "admin" user has been deleted, you can follow this procedure to restore your database:

1) Assure the database is under the OrientDB Server's databases directory ($ORIENTDB_HOME/databases/ folder)

2) Open the Console or Studio and login into the database using "root" and the password contained in file $ORIENTDB_HOME/config/orientdb-server-config.xml

3) Execute this query:
```sql
select from OUser where name = 'admin'
```

4) If the class OUser doesn't exist, create it by executing:
```sql
create class OUser extends OIdentity
```

5) If the class OIdentity doesn't exist, create it by executing:
```sql
create class OIdentity
```
And then retry to create the class OUser (5)

6) Now execute:

```sql
select from ORole where name = 'admin'
```

7) If the class ORole doesn't exist, create it by executing:
```sql
create class ORole extends OIdentity
```

8) If the role "admin" doesn't exist, create it by executing the following command:
```sql
insert into ORole set name = 'admin', mode = 1, rules = {"database.bypassrestricted":15}
```

9) If the user "admin" doesn't exist, create it by executing the following command:
```sql
insert into OUser set name = 'admin', password = 'admin', status = 'ACTIVE',
                      roles = (select from ORole where name = 'admin')
```

Now your "admin" user is active again.
