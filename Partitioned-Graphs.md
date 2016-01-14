# Partitioned graphs

This tutorial explains step-by-step how to create partitioned graphs using the [Record Level Security](Security.md#record_level_security) feature introduced in OrientDB 1.2.0. This feature is so powerful we can totally separate database's records as sand-boxes where each "Restricted" records can't be accessed by non authorized users. This tutorial demonstrates this sand-boxes works well also with the GraphDB API and the [TinkerPop stack](Graph-Database-Tinkerpop.md). Partitioning graphs allows to build real [Multi-tenant](http://en.wikipedia.org/wiki/Multitenancy) applications in a breeze.

Requirements:
- OrientDB 1.2.0-SNAPSHOT or higher
- TinkerPop Blueprints 2.2.0 or higher.

## Create a new empty graph database

First open the console of the GraphDB Edition and create the new database "blog" of type "graph" against the local file-system:
```java
$ cd $ORIENTDB_HOME/bin
$ console.sh
OrientDB console v.1.2.0-SNAPSHOT www.orientechnologies.com
Type 'help' to display all the commands supported.

Installing extensions for GREMLIN language v.2.2.0-SNAPSHOT

orientdb> CREATE DATABASE local::../databases/blog admin admin local graph
Creating database [local:../databases/blog] using the storage type [local]...
Database created successfully.

Current database is: local:../databases/blog
```

## Enable graph partitioning

Now turn on partitioning against graph by letting classes V (Vertex) and E (Edge) to extend the éORestricted* class. In this way any access to Vertex and Edge instances can be restricted:

```sql
ALTER CLASS V superclass orestricted

Class updated successfully
```
``` sql
ALTER CLASS E superclass orestricted

Class updated successfully
```
## Create 2 users

Now let's go creating 2 users: "luca" and "steve". First ask the current roles in database to know the "writer" role's rid:
```sql
SELECT FROM orole

 ---+------+--------+------+---------------------------------------------------------------+----------------
  # | RID  | name   | mode | rules                                                         | inheritedRole
 ---+------+--------+------+---------------------------------------------------------------+-----------------
  0 | #4:0 | admin  | 1    | {}                                                            | null
  1 | #4:1 | reader | 0    | {database=2, database.schema=2, database.cluster.internal=2,  | null
    |      |        |      | {database.cluster.orole=2, database.cluster.ouser=2,          |
    |  	   |        |      | database.class.*=2, database.cluster.*=2, database.command=2, |
    |	   |        |      | database.hook.record=2                                        |
  2 | #4:2 |writer  | 0    | {database=2, database.schema=7, database.cluster.internal=2,  | null
    |      |        |      |  database.cluster.orole=2, database.cluster.ouser=2,          |
    |      |        |      |  database.class.*=15, database.cluster.*=15,                  |
    |      |        |      |  database.command=15, database.hook.record=15}                |
 ---+------+--------+------+---------------------------------------------------------------+------------------

3 item(s) found. Query executed in 0.045 sec(s).
```
Found it, it's the #4:2. Not create 2 users with as first role #4:2 (writer):

```sql
INSERT INTO ouser SET name = 'luca', status = 'ACTIVE', password = 'luca', roles = [#4:2]

Inserted record 'OUser#5:4{name:luca,password:{SHA-256}D70F47790F689414789EEFF231703429C7F88A10210775906460EDBF38589D90,roles:[1]} v1' in 0,001000 sec(s).

INSERT INTO ouser SET name = 'steve', status = 'ACTIVE', password = 'steve', roles = [#4:2]

Inserted record 'OUser#5:3{name:steve,password:{SHA-256}F148389D080CFE85952998A8A367E2F7EAF35F2D72D2599A5B0412FE4094D65C,roles:[1]} v1' in 0,001000 sec(s).

```
## Create a simple graph as user 'Luca'

Now it's time to disconnect and reconnect to the blog database using the new "luca" user:

```sql
DISCONNECT

Disconnecting from the database [blog]...OK
```
```sql
CONNECT local:../databases/blog luca luca
Connecting to database [local:../databases/blog] with user 'luca'...OK
```
Now create 2 vertices: a Restaurant and a Pizza:
```sql
CREATE VERTEX SET label = 'food', name = 'Pizza'

Created vertex 'V#9:0{label:food,name:Pizza,_allow:[1]} v0' in 0,001000 sec(s).
```
```sql
CREATE VERTEX SET label = 'restaurant', name = "Dante's Pizza"

Created vertex 'V#9:1{label:restaurant,name:Dante's Pizza,_allow:[1]} v0' in 0,000000 sec(s).
```
Now connect these 2 vertices with an edge labelled "menu":
```sql
CREATE EDGE FROM #9:0 TO #9:1 SET label = 'menu'

Created edge '[E#10:0{out:#9:0,in:#9:1,label:menu,_allow:[1]} v1]' in 0,003000 sec(s).
```
To check if everything is ok execute a select against vertices:
```sql
SELECT FROM V

 ---+------+------------+---------------+-----------------
  # | RID  | label      | name          | _allow | out
 ---+------+------------+---------------+--------+--------
  0 | #9:0 | food       | Pizza         | [1]    | [1]
  1 | #9:1 | restaurant | Dante's Pizza | [1]    | null
 ---+------+------------+---------------+--------+--------

 2 item(s) found. Query executed in 0.034 sec(s).
```
## Create a simple graph as user 'Steve'

Now let's connect to the database using the 'Steve' user and check if there are vertices:
```sql
DISCONNECT

Disconnecting from the database [blog]...OK

CONNECT local:../databases/blog steve steve
Connecting to database [local:../databases/blog] with user 'steve'...OK

SELECT FROM V

0 item(s) found. Query executed in 0.0 sec(s).
```

Ok, no vertices found. Try to create something:

```sql
CREATE VERTEX SET label = 'car', name = 'Ferrari Modena'

 Created vertex 'V#9:2{label:car,name:Ferrari Modena,_allow:[1]} v0' in 0,000000 sec(s).

CREATE VERTEX SET label = 'driver', name = 'steve'

Created vertex 'V#9:3{label:driver,name:steve,_allow:[1]} v0' in 0,000000 sec(s).

CREATE EDGE FROM #9:2 TO #9:3 SET label = 'drive'

Created edge '[E#10:1{out:#9:2,in:#9:3,label:drive,_allow:[1]} v1]' in 0,002000 sec(s).
```

Now check the graph just created:

```sql
SELECT FROM V

 ---+------+--------+----------------+--------+------
  # | RID  | label  | name           | _allow | out
 ---+------+--------+----------------+--------+------
  0 | #9:2 | car    | Ferrari Modena | [1]    | [1]
  1 | #9:3 | driver | steve          | [1]    | null 
 ---+------+--------+----------------+--------+------

2 item(s) found. Query executed in 0.034 sec(s).
```

The "Steve" user doesn't see the vertices and edges creates by other users!

What happen if we try to connect 2 vertices of different users?

```sql
CREATE EDGE FROM #9:2 TO #9:0 SET label = 'security-test'

Error: com.orientechnologies.orient.core.exception.OCommandExecutionException: Error on execution of command: OCommandSQL [text=create edge from #9:2 to #9:0 set label = 'security-test']
Error: java.lang.IllegalArgumentException: Source vertex '#9:0' does not exist
```

The partition is totally isolated and OrientDB thinks the vertex doesn't exist while it's present, but invisible to the current user.

## TinkerPop Stack

[Record Level Security](Security.md#record_level_security) feature is very powerful because acts at low level inside the OrientDB engine. This is why everything works like a charm, even the [TinkerPop stack](Graph-Database-Tinkerpop.md).

Now try to display all the vertices and edges using [Gremlin](Gremlin.md):
```sql
gremlin g.V

[v[#9:2], v[#9:3]]

Script executed in 0,448000 sec(s).

gremlin g.E

e[#10:1][#9:2-drive->#9:3]

Script executed in 0,123000 sec(s).
```

The same is using other technologies that use the !TinkerPop Blueprints: [TinkerPop Rexter](https://github.com/tinkerpop/rexster/wiki), [TinkerPop Pipes](https://github.com/tinkerpop/pipes/wiki), [TinkerPop Furnace](https://github.com/tinkerpop/furnace/wiki), [TinkerPop Frames](https://github.com/tinkerpop/frames/wiki) and [ThinkAurelius Faunus](http://thinkaurelius.github.com/faunus/).
