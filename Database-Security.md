# Database Security

OrientDB uses a security model based on well-known concepts of users and roles.  That is, a database has its own users.  Each [User](#user) has on ore more roles.  [Roles](#roles) are a combination of the working mode and a set of permissions.

![Security overview](http://www.orientdb.org/images/orientdb-dbsecurity.png)


>For more information on security, see:
>- [Server security](Server-Security.md)
>- [Database Encryption](Database-Encryption.md)
>- [Secure SSL connections](Using-SSL-with-OrientDB.md)
>- [Record Level Security](Database-Security.md#record-level-security)



## Users

A user is an actor on the database.  When you open a database, you need to specify the user name and the password to use.  Each user has its own credentials and permissions.

By convention, each time you create a new database OrientDB creates three default users.  The passwords for these users are the same as the usernames.  That is, by default the `admin` user has a password of `admin`.
- `admin` This user has access to all functions on the database without limitation.
- `reader` This user is a read-only user.  The `reader` can query any records in the database, but can't modify or delete them.  It has no access to internal information, such as the users and roles themselves.
- `writer` This user is the same as the user `reader`, but it can also create, update and delete records.

The users themselves are records stored inside the cluster `ouser`.  OrientDB stores passwords in hash.  From version 2.2 on, OrientDB uses the [PBKDF2](https://en.wikipedia.org/wiki/PBKDF2) algorithm.  Prior releases relied on [SHA-256](https://en.wikipedia.org/wiki/SHA-2).  For more information on passwords, see [Password Management](Database-Security.md#password-management).

OrientDB stores the user status in the field `status`.  It can either be `SUSPENDED` or `ACTIVE`.  Only `ACTIVE` users can log in.

### Working with Users

When you are connected to a database, you can query the current users on the database by using [`SELECT`](SQL-Query.md) queries on the `OUser` class.

<pre>
orientdb> <code class="lang-sql userinput">SELECT RID, name, status FROM OUser</code>

---+--------+--------+--------
#  | @CLASS | name   | status
---+--------+--------+--------
0  | null   | admin  | ACTIVE
1  | null   | reader | ACTIVE
2  | null   | writer | ACTIVE
---+--------+--------+--------
3 item(s) found. Query executed in 0.005 sec(s).
</pre>

#### Creating a New User

To create a new user, use the [`INSERT`](SQL-Insert.md) command.  Remember in doing so, that you must set the status to `ACTIVE` and give it a valid role.

<pre>
orientdb> <code class="lang-sql userinput">INSERT INTO OUser SET name = 'jay', password = 'JaY', status = 'ACTIVE',
          roles = (SELECT FROM ORole WHERE name = 'reader')</code>
</pre>

#### Updating Users

You can change the name for the user with the [`UPDATE`](SQL-Update.md) statement:

<pre>
orientdb> <code class="lang-sql userinput">UPDATE OUser SET name = 'jay' WHERE name = 'reader'</code>
</pre>

In the same way, you can also change the password for the user:

<pre>
orientdb> <code class="lang-sql userinput">UPDATE OUser SET password = 'hello' WHERE name = 'reader'</code>
</pre>

OrientDB saves the password in a hash format.  The trigger `OUserTrigger` encrypts the password transparently before it saves the record.

#### Disabling Users

To disable a user, use [`UPDATE`](SQL-Update.md) to switch its status from `ACTIVE` to `SUSPENDED`.  For instance, if you wanted to disable all users except for `admin`:

<pre>
orientdb> <code class="lang-sql userinput">UPDATE OUser SET status = 'SUSPENDED' WHERE name <> 'admin'</code>
</pre>


## Roles

A role determines what operations a user can perform against a resource.  Mainly, this decision depends on the working mode and the rules.  The rules themselves work differently, depending on the working mode.

### Working with Roles


When you are connected to a database, you can query the current roles on the database using [`SELECT`](SQL-Query.md) queries on the `ORole` class.

<pre>
orientdb> <code class="lang-sql userinput">SELECT RID, mode, name, rules FROM ORole</code>

--+------+----+--------+----------------------------------------------------------
# |@CLASS|mode| name   | rules
--+------+----+--------+----------------------------------------------------------
0 | null | 1  | admin  | {database.bypassRestricted=15}
1 | null | 0  | reader | {database.cluster.internal=2, database.cluster.orole=0...
2 | null | 0  | writer | {database.cluster.internal=2, database.cluster.orole=0...
--+------+----+--------+----------------------------------------------------------
3 item(s) found.  Query executed in 0.002 sec(s).
</pre>

#### Creating New Roles

To create a new role, use the [`INSERT`](SQL-Insert.md) statement.

<pre>
orientdb> <code class="lang-sql userinput">INSERT INTO ORole SET name = 'developer', mode = 0</code>
</pre>

#### Role Inheritance

Roles can inherit permissions from other roles in an object-oriented fashion.  To let a role extend another, add the parent role in the `inheritedRole` attribute.  For instance, say you want users with the role `appuser` to inherit settings from the role `writer`.

<pre>
orientdb> <code class="lang-sql userinput">UPDATE ORole SET inheritedRole = (SELECT FROM ORole WHERE name = 'writer')
          WHERE name = 'appuser'</code>
</pre>

### Working with Modes

Where rules determine what users belonging to certain roles can do on the databases, working modes determine how OrientDB interprets these rules.  There are two types of working modes, designating by `1` and `0`.

- **Allow All But (Rules)** By default is the super user mode.  Specify exceptions to this using the rules.  If OrientDB finds no rules for a requested resource, then it allows the user to execute the operation.  Use this mode mainly for power users and administrators.  The default role `admin` uses this mode by default and has no exception rules.  It is written as `1` in the database.

- **Deny All But (Rules)** By default this mode allows nothing.  Specify exceptions to this using the rules.  If OrientDB finds rules for a requested resource, then it allows the user to execute the operation.  Use this mode as the default for all classic users.  The default roles `reader` and `writer` use this mode.  It is written as `0` in the database.

#### Operations

The supported operations are the classic CRUD operations.  That is, **C**reate, **R**ead, **U**pdate, **D**elete.  Roles can have none of these permissions or all of them.  OrientDB represents each permission internally by a 4-digit bitmask flask.

```
NONE:   #0000 - 0
CREATE: #0001 - 1
READ:   #0010 - 2
UPDATE: #0100 - 4
DELETE: #1000 - 8
ALL:    #1111 - 15
```

In addition to these base permissions, you can also combine them to create new permissions.  For instance, say you want to allow only the Read and Update permissions:

```
READ:               #0010 - 1
UPDATE:             #0100 - 4
Permission to use:  #0110 - 5
```

### Resources

Resources are strings bound to OrientDB concepts.

>**NOTE**: Resource entries are case-sensitive.

- `database`, checked on accessing to the database
- `database.class.<class-name>`, checked on accessing on specific class
- `database.cluster.<cluster-name>`, checked on accessing on specific cluster
- `database.query`, checked on query execution 
- `database.command`, checked on command execution 
- `database.schema`, checked to access to the schema
- `database.function`, checked on function execution
- `database.config`, checked on accessing at database configuration
- `database.hook.record`
- `server.admin`, checked on accessing to remote server administration

For instance, say you have a role `motorcyclist` that you want to have access to all classes except for the class `Car`.

<pre>
orientdb> <code class="lang-sql userinput">UPDATE ORole PUT rules = "database.class.*", 15 WHERE name = "motorcyclist"</code>

orientdb> <code class="lang-sql userinput">UPDATE ORole PUT rules = "database.class.Car", 0 WHERE name = "motorcyclist"</code>
</pre>

### Granting and Revoking Permissions

To grant and revoke permissions from a role, use the [GRANT](SQL-Grant.md) and [REVOKE](SQL-Revoke.md) commands.

<pre>
orientdb> <code class="lang-sql userinput">GRANT UPDATE ON database.cluster.Car TO motorcyclist</code>
</pre>



## Record-level Security

The sections above manage security in a vertical fashion at the schema-level, but in OrientDB you can also manage security in a horizontal fashion, that is: per record.  This allows you to completely separate database records as sandboxes, where only authorized users can access restricted records.

To active record-level security, create classes that extend the `ORestricted` super class.  In the event that you are working with a Graph Database, set the `V` and `E` classes (that is, the vertex and edge classes) themselves to extend `ORestricted`.  

<pre>
orientdb> <code class='lang-sql userinput'>ALTER CLASS V SUPERCLASS ORestricted</code>

orientdb> <code class="lang-sql userinput">ALTER CLASS E SUPERCLASS ORestricted</code>
</pre>

This causes all vertices and edges to inherit the record-level security.  Beginning with version 2.1, OrientDB allows you to use multiple inheritances, to cause only certain vertex or edge calsses to be restricted.  

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Order EXTENDS V, ORestricted</code>
</pre>

Whenever a class extends the class `ORestricted`, OrientDB uses special fields to type-set `_<OIdentifiable>` to store authorization on each record.
- `_allow` Contains the users that have full access to the record, (that is, all CRUD operations).
- `_allowRead` Contains the users that can read the record.
- `_allowUpdate` Contains the users that can update the record.
- `_allowDelete` Contains the users that can delete the record.

To allow full control over a record to a user, add the user's RID to the `_allow` set.  To provide only read permissions, use `_allowRead`.  In the example below, you allow the user with the RID `#5:10` to read record `#43:22`:

<pre>
orientdb> <code class='lang-sql userinput'>UPDATE #43:22 ADD _allowRead #5:10</code>
</pre>

If you want to remove read permissions, use the following command:


<pre>
orientdb> <code class='lang-sql userinput'>UPDATE #43:22 REMOVE _allowRead #5:10</code>
</pre>



### Run-time Checks

OrientDB checks record-level security using a hook that injects the check before each CRUD operation:
- **Create Documents**: Sets the current database's user in the `_allow` field.  To change this behavior, see [Customize on Creation](#customize-on-creation).
- **Read Documents**: Checks if the current user, or its roles, are listed in the `_allow` or `_allowRead` fields.  If not, OrientDB skips the record.  This allows each query to work per user.
- **Update Documents**: Checks if the current user, or its roles, are listed in the `_allow` or `_allowUpdate` field.  If not, OrientDB raises an `OSecurityException` exception.
- **Delete Documents**: Checks if the current user, or its roles, are listed in the `_allow` or `_allowDelete` field.  If not, OrientDB raises an `OSecurityException` exception.

The allow fields, (that is, `_allow`, `_allowRead`, `_allowUpdate`, and `_allowDelete`) can contain instances of `OUser` and `ORole` records, as both classes extend `OIdentity`.  Use the class `OUser` to allow single [users](#user) and use the class `ORole` to allow all users that are a part of that [role](#role).

### Using the API

In addition to managing record-level security features through the OrientDB console, you can also configure it through the Graph and Document API's.

- **Graph API**
  ```java
  OrientVertex v = graph.addVertex("class:Invoice");
  v.setProperty("amount", 1234567);
  graph.getRawGraph().getMetadata().getSecurity().allowUser(
        v.getRecord(), ORestrictedOperation.ALLOW_READ, "report");
  v.save();
  ```

- **Document API**
  ```java
  ODocument invoice = new ODocument("Invoice").field("amount", 1234567);
  database.getMetadata().getSecurity().allowUser(
        invoice, ORestrictedOperation.ALLOW_READ, "report");
  invoice.save();
  ```


### Customize on Creation

By default, whenever you create a restricted record, (that is, create a class that extends the class `ORestricted`), OrientDB inserts the current suer into the `_allow` field.  You can change this using custom properties in the class schema:
- `onCreate.fields` Specifies the names of the fields it sets.  By default, these are `_allow`, but you can also specify `_allowRead`, `_allowUpdate`, `_allowDelete` or a combination of them as an alternative.  Use commas to separate multiple fields.
- `onCreate.identityType` Specifies whether to insert the user's object or its role (the first one).  By default, it is set to `user`, but you can also set it to use its `role`.

For instance, say you wanted to prevent a user from deleting new posts:

<pre>
orientdb> <code class='lang-sql userinput'>ALTER CLASS Post CUSTOM onCreate.fields=_allowRead,_allowUpdate</code>
</pre>

Consider another example, where you want to assign a role instead of a user to new instances of `Post`.

<pre>
orientdb> <code class="lang-sql userinput">ALTER CLASS Post CUSTOM onCreate.identityType=role</code>
</pre>


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

## Restore the admin user

In case your database is corrupted or you need to re-install the "admin" user, look at [Restore the admin user](Server-Security.md#restore-the-admin-user).

## Password management

User passwords are stored in OUser records by using the [PBKDF2](https://en.wikipedia.org/wiki/PBKDF2) HASH algorithm using a random 24 bit length Salt per user for a configurable number of iterations (by default is 65,536). Using a higher iteration count makes any attack slower, but it slows down also the OrientDB authentication. To change the SALT iteration count, change the global configuration `security.userPasswordSaltIterations`.

>**NOTE**: Before OrientDB v2.2 a simple [SHA-256](https://en.wikipedia.org/wiki/SHA-2) was used.

In order to speedup the hashing of password, OrientDB uses a password cache implemented as a LRU with maximum 500 entries. To change this setting, set the global configuration `security.userPasswordSaltCacheSize` to the entries to cache. Use `0` to completely disable the cache.

>**NOTE**: If an attacker have access to the JVM memory dump, he could access to this map containing all the passwords. If you want to protect against this attack, disable the in memory password cache.
