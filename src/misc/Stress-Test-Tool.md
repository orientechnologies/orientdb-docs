
# OrientDB Stress Test Tool

The OrientDB Stress Test Tool is an utility for very basic benchmarking of OrientDB.

## Syntax
	StressTester
		-m [plocal|memory|remote] (mandatory)
		-w <workload-name>:<workload-params>*
		-c <concurrency level> (number of parallel threads)
		-tx <operationsPerTransaction>
        -o <resultOutputFile>
        -d <plocalDirectory>
        -chk true|false
        -k true|false
	--root-password <rootPassword>
	--remote-ip <remoteIpOrHost>
	--remote-port <remotePort>
	--ha-metrics true|false

* the **m** parameter sets the type of database to be stressed.
* the **c** parameter sets the concurrency level, as the number of threads that will be launched. Every thread will execute the complete operationSe. If not present, it defaults to 4.
* the **tx** parameter sets the number of operations to be included in a transaction. This value must be lesser than the number of creates divided by the threads number and the iterations number. If the **tx** parameter is not present, all the operations will be executed outside transactions.
* the **w** parameter defines the workloads. To specify multiple workloads, use the comma (`,`) to separate them, but do not use any space. Workloads are pluggable, the available ones are:
	* **CRUD**, executes, in order, (C)reate, (R)ead, (U)pdate and (D)elete operations. The `<workload-params>` must follow the format `C#R#U#D#`, where the '#' is a number:
		* C1000 defines 1000 Create operations
		* R1000 defines 1000 Read operations
		* U1000 defines 1000 Update operations
		* D1000 defines 1000 Delete operations
		
   		So a valid set is C1000R1000U1000D1000. There is only one constraint: the number of reads, updates and deletes cannot be greater than the number of creates. If not present, it defaults to C5000R5000U5000D5000.
	* **GINSERT**, Insert a graph where all the nodes are connected with each others. The `<workload-params>` must follow the format `V#F#`, where the '#' is a number:
		* V1000 creates 1000 vertices
		* F10 Each vertex has 10 edges
	* **GSP**, Executes a shortest path between all the vertices against all the other vertices. The `<workload-params>` must follow the format `L#`, where the '#' is a number::
		* L1000 set the limit to 1000 vertices only. Optional.
* the **o** parameter sets the filename where the results are written in JSON format.
* the **d** parameter sets the base directory for writing the plocal database
* the **k** keeps the database at the end of workload. By default is `false`, so the database is dropped.
* the **chk** Checks the database created by the workload at the end of the test. Default is `false`.
* the **remote-ip** parameter defines the remote host (or IP) of the server to connect to. The StressTester will fail if this parameter is not specified and mode is **remote**.
* the **remote-port** parameter defines the port of the server to connect to. If not specified, it defaults to 2424.
* the **root-password** parameter sets the root password of the server to connect to. If not specified and if mode is **remote**, the root password will be asked at the start of the test.
* the **ha-metrics** (since v2.2.7) setting dumps the HA metrics at the end of each workload


If the StressTester is launched without parameters, it fails because the **-m** parameter is mandatory.

## How it works

The stress tester tool creates a temporary database where needed (on memory / plocal / remote) and then creates a pool of N threads (where N is the threadsNumber parameter) that - all together - execute the number of operations defined in the OperationSet.
So, if the number of Creates is 1000 and the thread number is 4, every single thread will execute 250 Creates (1000/4).
After the execution of the test (or any error) the temporary database is dropped.

## Example with CRUD workload

Executing a CRUD workload by inserting, reading, updating and deleting 100,000 records by using a connection of type "plocal" and 8 parallel threads:

```
cd bin
./stresstester -m plocal -c 8 -w crud:C100000R100000U100000D100000
```

This is the result:

```
OrientDB Stress Tool v.2.2.4-SNAPSHOT - Copyrights (c) 2016 OrientDB LTD
WARNING: 'tx' option not found. Defaulting to 0.
Created database [plocal:/var/folders/zc/y34429014c3bt_x1587qblth0000gn/T/stress-test-db-20160701_165901].

Starting workload CRUD (concurrencyLevel=8)...
- Workload in progress 100% [Creates: 100% - Reads: 100% - Updates: 100% - Deletes: 100%]
- Total execution time: 27.602 secs
- Created 1000000 records in 26.464 secs
  - Throughput: 37787.184/sec - Avg: 0.026ms/op (0th percentile) - 99th Perc: 0.799ms - 99.9th Perc: 5.769ms
- Read 1000 records in 0.096 secs
  - Throughput: 10416.667/sec - Avg: 0.096ms/op (0th percentile) - 99th Perc: 2.597ms - 99.9th Perc: 6.860ms
- Updated 1000 records in 0.043 secs
  - Throughput: 23255.814/sec - Avg: 0.043ms/op (0th percentile) - 99th Perc: 1.404ms - 99.9th Perc: 3.505ms
- Deleted 1000 records in 0.107 secs
  - Throughput: 9345.794/sec - Avg: 0.107ms/op (0th percentile) - 99th Perc: 3.175ms - 99.9th Perc: 5.664ms

Dropped database [plocal:/var/folders/zc/y34429014c3bt_x1587qblth0000gn/T/stress-test-db-20160701_165901].
```

The first part of the result is updated as long as the test is running, to give the user an idea of how long it will last. It will be deleted as soon as the test successfully terminates.
The second part shows the results of the test:
* The total time of execution
* The times of execution of every operation type, their percentiles and the throughput.

The time is computed by summing up the times of execution of all the threads and dividing it by their number; the percentile value shows where the average result is located compared to all other results: if the average is a lot higher than 50%, it means that there are a few executions with higher times that lifted up the average (and you can expect better performance in general); a high percentile can happen when, for example, the OS or another process is doing something else (either CPU or I/O intensive) during the execution of the test.

If you plan to use the results of the StressTester the **o** option is available for writing the results in JSON format on disk. 

## Example with Graph workloads

Insert 100 vertices with 10 edges each (all connected), then execute a shortest path between all of them and checks the database integrity at the end.

```
cd bin
./stresstester -m plocal -c 16 -w GINSERT:V100F10,GSP -chk true
```

This is the result:

```
OrientDB Stress Tool v.2.2.4-SNAPSHOT - Copyrights (c) 2016 OrientDB LTD
WARNING: 'tx' option not found. Defaulting to 0.
Created database [plocal:/var/folders/zc/y34429014c3bt_x1587qblth0000gn/T/stress-test-db-20160701_170356].

Starting workload GINSERT (concurrencyLevel=16)...
- Workload in progress 100% [Vertices: 100 - Edges: 84]
- Total execution time: 0.068 secs
- Created 100 vertices and 84 edges in 0.052 secs
- Throughput: 1923.077/sec - Avg: 0.520ms/op (0th percentile) - 99th Perc: 15.900ms - 99.9th Perc: 15.900ms
- Checking database...
   - Repair of graph 'plocal:/var/folders/zc/y34429014c3bt_x1587qblth0000gn/T/stress-test-db-20160701_170356' is started ...
   - Scanning 99 edges...
   - Scanning edges completed
   - Scanning 100 vertices...
   - Scanning vertices completed
   - Repair of graph 'plocal:/var/folders/zc/y34429014c3bt_x1587qblth0000gn/T/stress-test-db-20160701_170356' completed in 0 secs
   -  scannedEdges.....: 99
   -  removedEdges.....: 0
   -  scannedVertices..: 100
   -  scannedLinks.....: 198
   -  removedLinks.....: 0
   -  repairedVertices.: 0
- Check completed

Starting workload GSP (concurrencyLevel=16)...
- Workload in progress 100% [Shortest paths blocks (block size=100) executed: 100/100]
- Total execution time: 2.065 secs
- Executed 100 shortest paths in 2.060 secs
- Path depth: maximum 18, average 8.135, not connected 0
- Throughput: 48.544/sec - Avg: 20.600ms/op (0th percentile) - 99th Perc: 650.284ms - 99.9th Perc: 650.284ms
- Checking database...
   - Repair of graph 'plocal:/var/folders/zc/y34429014c3bt_x1587qblth0000gn/T/stress-test-db-20160701_170356' is started ...
   - Scanning 99 edges...
   - Scanning edges completed
   - Scanning 100 vertices...
   - Scanning vertices completed
   - Repair of graph 'plocal:/var/folders/zc/y34429014c3bt_x1587qblth0000gn/T/stress-test-db-20160701_170356' completed in 0 secs
   -  scannedEdges.....: 99
   -  removedEdges.....: 0
   -  scannedVertices..: 100
   -  scannedLinks.....: 198
   -  removedLinks.....: 0
   -  repairedVertices.: 0
- Check completed

Dropped database [plocal:/var/folders/zc/y34429014c3bt_x1587qblth0000gn/T/stress-test-db-20160701_170356].
```
