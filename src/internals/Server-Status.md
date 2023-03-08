
# Server Status

The server status can be obtained by executing a `kill -5 <server-pid>`. The status will be written to the standard output, by default the console output of the server.
The dump contains the following information:
- Current settings
- Stack Trace of all the threads
- Replication latency (if running in HA mode)
- Replication messages statistics (if running in HA mode)
- Distributed resources locked (if running in HA mode)
- Record locks per database (if running in HA mode)

Below an example of a dump.

```
2017-08-21 16:51:25:060 WARNI Received signal: SIGTRAP [OSignalHandler]
OrientDB 2.2.27-SNAPSHOT (build b3c2429a7f0992cd650c61917a171134fa0c6794) configuration dump:
- ENVIRONMENT
  + environment.dumpCfgAtStartup = false
  + environment.concurrent = true
  + environment.lockManager.concurrency.level = 64
  + environment.allowJVMShutdown = true
...

THREAD DUMP
"SIGTRAP handler" id=226 
   java.lang.Thread.State: RUNNABLE
        at sun.management.ThreadImpl.getThreadInfo1(Native Method)
        at sun.management.ThreadImpl.getThreadInfo(ThreadImpl.java:174)
        at com.orientechnologies.common.profiler.OAbstractProfiler.threadDump(OAbstractProfiler.java:432)
        at com.orientechnologies.orient.core.OSignalHandler.handle(OSignalHandler.java:76)
        at sun.misc.Signal$1.run(Signal.java:212)
        at java.lang.Thread.run(Thread.java:745)

"Thread-176" id=224 
   java.lang.Thread.State: WAITING
        at sun.misc.Unsafe.park(Native Method)
        at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.await(AbstractQueuedSynchronizer.java:2039)
        at java.util.concurrent.ArrayBlockingQueue.take(ArrayBlockingQueue.java:403)
        at com.orientechnologies.agent.event.OEventController.run(OEventController.java:214)
...

REPLICATION LATENCY AVERAGE (in milliseconds)
+-------+-----+------+
|Servers|node1|node2*|
+-------+-----+------+
|node1  |     |      |
|node2* |47.32|      |
+-------+-----+------+

REPLICATION MESSAGE COUNTERS (servers: source on the row and destination on the column)
+-------+-----+------+-----+
|Servers|node1|node2*|TOTAL|
+-------+-----+------+-----+
|node1  |     |      |    0|
|node2* |   63|      |   63|
+-------+-----+------+-----+
|TOTAL  |   63|  null|   63|
+-------+-----+------+-----+

REPLICATION MESSAGE CURRENT NODE STATS
+-------+----------+--------+---------+---------------+-----+
|Servers|upd_db_cfg|exc_lock|deploy_db|deploy_delta_db|TOTAL|
+-------+----------+--------+---------+---------------+-----+
|node1  |          |        |         |               |    0|
|node2* |        17|      30|        1|             15|   63|
+-------+----------+--------+---------+---------------+-----+
|TOTAL  |        17|      30|        1|             15|   63|
+-------+----------+--------+---------+---------------+-----+

HA RESOURCE LOCKS FOR SERVER 'node2'

DATABASE 'foo_14' ON SERVER 'node2'
- HA RECORD LOCKS FOR DATABASE 'foo_14'
- MESSAGES IN QUEUES (8 WORKERS):
```
