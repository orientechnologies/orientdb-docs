# Working with Distributed Graphs

Once a server has joined the distributed cluster, all the clients are constantly notified about it so that in case of failure they will switch transparently to the next available server. Check this by using the console. When OrientDB runs in distributed configuration, the current cluster shape is visible with the [`info`](Console-Command-Info.md) command.

``` console
$ cd bin
$ ./console.sh

OrientDB console v.1.6 www.orientechnologies.com
Type 'help' to display all the commands supported.
Installing extensions for GREMLIN language v.2.5.0-SNAPSHOT

orientdb> CONNECT remote:localhost/GratefulDeadConcerts admin admin
 Connecting to database [remote:localhost/GratefulDeadConcerts] with user 'admin'...OK

orientdb> INFO

 Current database: GratefulDeadConcerts (url=remote:localhost/GratefulDeadConcerts)

 Cluster configuration:
```

```json
{
  "members":[{
    "name":"node1384015873680",
    "listeners":[{"protocol":"ONetworkProtocolBinary","listen":"192.168.1.179:2425"},{"protocol":"ONetworkProtocolHttpDb","listen":"192.168.1.179:2481"}],
    "id":"3bba4280-b285-40ab-b4a0-38788691c4e7",
    "startedOn":"2013-11-09 17:51:13",
    "databases":[]
    },{
    "name":"node1383734730415",
    "listeners":[{"protocol":"ONetworkProtocolBinary","listen":"192.168.1.179:2424"},{"protocol":"ONetworkProtocolHttpDb","listen":"192.168.1.179:2480"}],
    "id":"5cb7972e-ccb1-4ede-bfda-c835b0c2e5da",
    "startedOn":"2013-11-09 17:30:56",
    "databases":[]
    }],
  "localName":"_hzInstance_1_orientdb",
  "localId":"5cb7972e-ccb1-4ede-bfda-c835b0c2e5da"
}
```

Now let's create a new vertex by connecting with the console against Node1:

``` sql
CREATE VERTEX V SET node = 1
```
```
 Created vertex 'V#9:815{node:1} v1' in 0,013000 sec(s).
```
Now from another shell (Command Prompt on Windows) connect to the node2 and execute this command:


``` sql
SELECT FROM V WHERE node = 1
```
```
 ----+--------+-------
  #  | @RID   | node
 ----+--------+-------
  0  | #9:815 | 1
 ----+--------+-------
 1 item(s) found. Query executed in 0.19 sec(s).
```

The vertex has been correctly replicated on Node2. Cool! Now kill the node1 process. You will see these messages in the console of node2:

``` json
INFO [192.168.1.179]:2435 [orientdb] Removing Member [192.168.1.179]:2434 [ClusterService]
INFO [192.168.1.179]:2435 [orientdb]
Members [1] {
	Member [192.168.1.179]:2435 this
}
 [ClusterService]
WARN [node1384015873680] node removed id=Member [192.168.1.179]:2434 name=node1384014656983 [OHazelcastPlugin]
INFO [192.168.1.179]:2435 [orientdb] Partition balance is ok, no need to re-partition cluster data...  [PartitionService]
```

Node2 recognizes that Node1 is unreachable. Let's see if the console connected to the node1 reports the failure. Test it by executing a query:

``` sql
SELECT FROM V LIMIT 2
```
```
 WARN Caught I/O errors from /192.168.1.179:2425 (local socket=0.0.0.0/0.0.0.0:51512), trying to reconnect (error: java.io.IOException: Stream closed) [OStorageRemote]
 WARN Connection re-acquired transparently after 30ms and 1 retries: no errors will be thrown at application level [OStorageRemote]
 ---+------+----------------+-----------+--------------+------+-----------------+---------------+-------------+----------------
  # | @RID | name           | song_type | performances | type | out_followed_by |out_written_by | out_sung_by | in_followed_by
 ---+------+----------------+-----------+--------------+------+-----------------+---------------+-------------+----------------
  1 | #9:1 | HEY BO DIDDLEY | cover     | 5            | song | [5]             | #9:7          | #9:8        | [4]
  2 | #9:2 | IM A MAN       | cover     | 1            | song | [2]             | #9:9          | #9:9        | [2]
 ---+------+----------------+-----------+--------------+------+-----------------+---------------+-------------+----------------
```

Wow! The console auto switched to the next available node2. The warning reports that everything happens in a transparent way, so the application doesn't need to manage this.

Now, from the console connected to the Node2, create a new vertex:

``` sql
CREATE VERTEX V SET node = 2
```
```
 Created vertex 'V#9:816{node:2} v1' in 0,014000 sec(s).
```
The operation has been journaled to be synchronized to the Node1 once it comes online again. Now let's restart Node1 and see if auto re-alignment succeeds. Connect with the console against Node1 to check if the node has been aligned after the restart:

``` sql
SELECT FROM V WHERE node = 2
```
```
 ---+--------+-------
  # | @RID   | node
 ---+--------+-------
  0 | #9:816 | 2
 ---+--------+-------
 1 item(s) found. Query executed in 0.209 sec(s).
```

Aligned! You can do the same with N servers where every server is a Master. There are no limits on the number of running servers. With many servers across a not-fast network, you could tune the network timeouts to be more permissive and let a big, distributed cluster of servers do the work properly.

For more information look at [Distributed Architecture](Distributed-Architecture.md#how-does-it-work).

