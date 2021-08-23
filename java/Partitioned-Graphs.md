
# Partitioned Graphs

You can partition graphs using the [Record-level Security](../security/Database-Security.md#record-level-security) feature.  This allows you to separate database records as sandboxes, where "restricted" records are inaccessible to unauthorized users. For more information about other solution for Multi-Tenant applications, look at [Multi-Tenant](../datamodeling/Multi-Tenant.md).

This tutorial provides a demonstration of sandboxing with the Graph API and the [TinkerPop](Graph-Database-Tinkerpop.md) stack.  Partitioned Graph Databases allow you to build [Multi-tenant](http://en.wikipedia.org/wiki/Multitenancy) applications.

>**Requirements**:
>- OrientDB 1.2.0-SNAPSHOT or higher
>- TinkerPop Blueprints 2.2.0 or higher


## Creating a Graph Database

To create a Partitioned Graph Database, you first need to create a database in which to partition.  For instance, the example below covers creating a `blog` database of the Graph type on the local file system:

<pre>
$ <code class="lang-sh userinput">cd $ORIENTDB_HOME/bin</code>
$ <code class="lang-sh userinput">./console.sh</code>
OrientDB console v.1.2.0-SNAPSHOT www.orientechnologies.com
Type 'help' to display all the commands supported.

Installing extensions for GREMLIN language v.2.2.0-SNAPSHOT

orientdb> <code class="lang-sql userinput">CREATE DATABASE local::../databases/blog 
          admin admin_passwd local graph</code>
Creating database [local:../databases/blog] using the storage type [local]...
Database created successfully.

Current database is: local:../databases/blog
</pre>



## Enabling Partitioned Graphs

Once you have created the Graph Database instance, you need to enable partitioning.  Alter the `V` and `E` classes to extend the `ORestricted`.  Doing so allows you to restrict vertex and edge instances.

<pre>
orientdb {db=blog}> <code class="lang-sql userinput">ALTER CLASS V SUPERCLASS ORestricted</code>
Class updated successfully

orientdb {db=blog}> <code class="lang-sql userinput">ALTER CLASS E SUPERCLASS ORestricted</code>
Class updated successfully
</pre>

## Create Users

With the database online and the vertex and edge classes altered to restricted, create two test users, (`luca` and `steve`), to use in exploring how sandboxing works on a Partioned Graph Database.

These users represent users who blog on the application you're building.  Their level of permissions and authorization relates to the `writer` role.  First, ensure that the `writer` role exists on your database:

<pre>
orientdb {db=blog}> <code class="lang-sql userinput">SELECT RID, name, rules FROM ORole 
                    WHERE name = "writer"</code>

---+------+--------+-----------------------------------------------
 # | RID  | name   | rules
---+------+--------+-----------------------------------------------
 0 | #4:2 | writer | {database=2, database.schema=7, 
   |      |        | database.cluster.internal=2,
   |      |        | database.cluster.orole=2, 
   |      |        | database.cluster.ouser=2,
   |      |        | database.class.*=15, database.cluster.*=15,
   |      |        | database.command=15, database.hook.record=15}
---+------+--------+-----------------------------------------------

3 item(s) found. Query executed in 0.045 sec(s).
</pre>

Running these commands shows that you do in fact have a `writer` role configured on your database and that it uses a Record ID of `#4:2`.  You can now create the users.  There are two methods available to you, depending on which version of OrientDB you use.

### Creating Users

Beginning with version 2.1, OrientDB now features a [`CREATE USER`](../sql/SQL-Create-User.md) command. This allows you to create a new user in the current database, as opposed to inserting the credentials into the `OUser` and `ORole` classes.

To create users for Luca and Steve, run the following commands:

<pre>
orientdb {db=blog}> <code class="lang-sql userinput">CREATE USER luca IDENTIFIED BY luca_passwd
                    ROLE writer</code>

orientdb {db=blog}> <code class="lang-sql userinput">CREATE USER steve IDENTIFIED BY steve_passwd 
                    ROLE writer</code>
</pre>

The users are now active on your database as `luca` and `steve`.

### Inserting Users

For older implementations of OrientDB, there is no [`CREATE USER`](../sql/SQL-Create-User.md) command available to you.  To add users before version 2.1, you need to use [`INSERT`](../sql/SQL-Insert.md) statements to add the new values into the `OUser` class, using the record ID for the `writer` role, which you found above as `#4:2`:


<pre>
orientdb {db=blog}> <code class="lang-sql userinput">INSERT INTO OUser SET name = 'luca', 
                    status = 'ACTIVE', password = 'luca_passwd', 
					roles = [#4:2]</code>

Inserted record 'OUser#5:4{name:luca,password: {SHA-256}D70F47790F
689414789EEFF231703429C7F88A10210775906460EDBF38589D90,roles:[1]} 
v1' in 0,001000 sec(s).

orientdb {db=blog}> <code class="lang-sql userinput">INSERT INTO OUser SET name = 'steve', 
                    status = 'ACTIVE', password = 'steve_passwd', 
					roles = [#4:2]</code>

Inserted record 'OUser#5:3{name:steve,password: {SHA-256}F148389D0
80CFE85952998A8A367E2F7EAF35F2D72D2599A5B0412FE4094D65C,roles:[1]}
v1' in 0,001000 sec(s).
</pre>


## Creating Graphs

In order to work with the partition, you need to create graphs for each user on the database.  This requires that you log out from the `admin` user and log back in as Luca and then Steve, then create vertexes and edges with which to work.


### Create a Graph for Luca

First, using [`DISCONNECT`](../console/Console-Command-Disconnect.md) and [`CONNECT`](../console/Console-Command-Connect.md) disconnect from your admin session on the `blog` database and reconnect as Luca's user.

<pre>
orientdb {db=blog}> <code class="lang-sql userinput">DISCONNECT</code>
Disconnecting from the database [blog]...OK

orientdb> <code class="lang-sql userinput">CONNECT local:../databases/blog luca luca_passwd</code>
Connecting to database [local:../databases/blog] with user 'luca'...OK

orientdb {db=blog}>
</pre>

Now that you're logged in under Luca's user, using the [`CREATE VERTEX`](../sql/SQL-Create-Vertex.md) command, create two vertices: one for restaurants and one for pizza.

<pre>
orientdb {db=blog}> <code class="lang-sql userinput">CREATE VERTEX SET label = 'food', 
                    name = 'Pizza'</code>
Created vertex 'V#9:0{label:food,name:Pizza,_allow:[1]} v0' in 0,001000 sec(s).

orientdb {db=blog}> <code class="lang-sql userinput">CREATE VERTEX SET label = 'restaurant', 
                    name = "Dante's Pizza"</code>
Created vertex 'V#9:1{label:restaurant,name:Dante's Pizza,_allow:[1]} v0' in 0,000000 sec(s).
</pre>

Connect these vertices with an edge for menus, using [`CREATE EDGE`](../sql/SQL-Create-Edge.md):

<pre>
orientdb {db=blog}> <code class="lang-sql userinput">CREATE EDGE FROM #9:0 TO #9:1 SET label = 'menu'</code>
Created edge '[E#10:0{out:#9:0,in:#9:1,label:menu,_allow:[1]} 
v1]' in 0,003000 sec(s).
</pre>

You can check the status using [`SELECT`](../sql/SQL-Query.md) against these vertices:


<pre>
orientdb {db=blog}> <code class="lang-sql userinput">SELECT FROM V</code>

 ---+------+------------+---------------+-----------------
  # | RID  | label      | name          | _allow | out
 ---+------+------------+---------------+--------+--------
  0 | #9:0 | food       | Pizza         | [1]    | [1]
  1 | #9:1 | restaurant | Dante's Pizza | [1]    | null
 ---+------+------------+---------------+--------+--------
 2 item(s) found. Query executed in 0.034 sec(s).
</pre>



### Creating a Graph for Steve


Now let's connect to the database using the 'Steve' user and check if there are vertices:

<pre>
orientdb {db=blog}> <code class="lang-sql userinput">DISCONNECT</code>
Disconnecting from the database [blog]...OK

orientdb> <code class="lang-sql userinput">CONNECT local:../databases/blog steve steve_passwd</code>
Connecting to database [local:../databases/blog] with user 'steve'...OK

orientdb {db=blog}> <code class="lang-sql userinput">SELECT FROM V</code>

0 item(s) found. Query executed in 0.0 sec(s).
</pre>

This confirms that the user Steve does not have access to vertices created by Luca.  Now, create some as Steve:


<pre>
orientdb {db=blog}> <code class="lang-sql userinput">CREATE VERTEX SET label = 'car', 
                    name = 'Ferrari Modena'</code>

Created vertex 'V#9:2{label:car,name:Ferrari Modena,_allow:[1]} v0' in 0,000000 sec(s).

orientdb {db=blog}> <code class="lang-sql userinput">CREATE VERTEX SET label = 'driver', 
                    name = 'steve'</code>

Created vertex 'V#9:3{label:driver,name:steve,_allow:[1]} v0' in 0,000000 sec(s).

orientdb {db=blog}> <code class="lang-sql userinput">CREATE EDGE FROM #9:2 TO #9:3 
                    SET label = 'drive'</code>
					
Created edge '[E#10:1{out:#9:2,in:#9:3,label:drive,_allow:[1]} v1]' in 0,002000 sec(s).
</pre>

Run the [`SELECT`](../sql/SQL-Query.md) query from earlier to see the vertices you've created:


<pre>
orientdb {db=blog}> <code class="lang-sql userinput">SELECT FROM V</code>

---+------+--------+----------------+--------+------
 # | RID  | label  | name           | _allow | out
---+------+--------+----------------+--------+------
 0 | #9:2 | car    | Ferrari Modena | [1]    | [1]
 1 | #9:3 | driver | steve          | [1]    | null
---+------+--------+----------------+--------+------

2 item(s) found. Query executed in 0.034 sec(s).
</pre>

As you can see, Steve's user still can't see vertices and edged that were created by other users. For the sake of example, see what happens when you try to create an edge that connects vertices from different users:

<pre>
orientdb {db=blog}> <code class="lang-sql userinput">CREATE EDGE FROM #9:2 TO #9:0 
                    SET label = 'security-test'</code>

Error: com.orientechnologies.orient.core.exception.OCommandExecutionException: 
Error on execution of command: OCommandSQL [text=create edge from #9:2 to #
9:0 set label = 'security-test'] 
Error: java.lang.IllegalArgumentException: Source vertex '#9:0' does not exist
</pre>

The partition used by Luca remains totally isolated from the one used by Steve.  OrientDB operates on the assumption that the other partition doesn't exist, it remains invisible to the current user while still present in the database.


## TinkerPop Stack

The [Record-level Security](../security/Database-Security.md#record-level-security) feature is very powerful because it acts at a low-level within the OrientDB engine.  This allows for better integration of security features with the Java API and the [TinkerPop](Graph-Database-Tinkerpop.md) stack.


For instance, try to display all vertices and edges using [Gremlin](../gremlin/Gremlin.md):


<pre>
gremlin> <code class="lang-javascript userinput">g.V</code>
==> [v[#9:2], v[#9:3]]
Script executed in 0,448000 sec(s).

gremlin> <code class="lang-javascript userinput">g.E</code>
==> e[#10:1][#9:2-drive->#9:3]
Script executed in 0,123000 sec(s).
</pre>

>This feature works with other technologies that rely on TinkerPop Blueprints:
>
>- [TinkerPop Rexter](https://github.com/tinkerpop/rexster/wiki)
>- [TinkerPop Pipes](https://github.com/tinkerpop/pipes/wiki)
>- [TinkerPop Furnace](https://github.com/tinkerpop/furnace/wiki)
>- [TinkerPop Frames](https://github.com/tinkerpop/frames/wiki)
>- [ThinkAurelius Faunus](http://thinkaurelius.github.com/faunus/)
