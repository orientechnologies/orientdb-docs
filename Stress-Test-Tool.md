### OrientDB Stress Test Tool ###
The OrientDB Stress Test Tool is an utility for very basic benchmarking of OrientDB.

## Syntax
	StressTester
		-m [plocal|memory|remote|distributed] (mandatory)
		-w <workload-name>:<workload-params>
		-c concurrency level (number of parallel threads)
		-tx operationsPerTransaction
        -o resultOutputFile
        -d plocalDirectory
		--root-password rootPassword
		--remote-ip remoteIpOrHost
		--remote-port remotePort

* the _m_ parameter sets the type of database to be stressed (distributed is not yet implemented).
* the _c_ parameter sets the concurrency level, as the number of threads that will be launched. Every thread will execute the complete operationSe. If not present, it defaults to 4.
* the _tx_ parameter sets the number of operations to be included in a transaction. This value must be lesser than the number of creates divided by the threads number and the iterations number. If the _tx_ parameter is not present, all the operations will be executed outside transactions.
* the _o_ parameter sets the filename where the results are written in JSON format.
* the _d_ parameter sets the base directory for writing the plocal database
* the _w_ parameter defines which and how many operations to execute. It is in the form of C#R#U#D#, where the '#' is a number:
 * C1000 defines 1000 Create operations
 * R1000 defines 1000 Read operations
 * U1000 defines 1000 Update operations
 * D1000 defines 1000 Delete operations
So a valid set is C1000R1000U1000D1000. 
There are two constraints: the number of reads, updates and deletes cannot be greater than the number of creates.
If not present, it defaults to C5000R5000U5000D5000.
* the _remote-ip_ parameter defines the remote host (or IP) of the server to connect to. The StressTester will fail if this parameter is not specified and mode is _remote_.
* the _remote-port_ parameter defines the port of the server to connect to. If not specified, it defaults to 2424.
* the _root-password_ parameter sets the root password of the server to connect to. If not specified and if mode is _remote_, the root password will be asked at the start of the test.


If the StressTester is launched without parameters, it fails because the _-m_ parameter is mandatory.

## How it works
The stress tester tool creates a temporary database where needed (on memory / plocal / remote) and then creates a pool of N threads (where N is the threadsNumber parameter) that - all together - execute the number of operations defined in the OperationSet.
So, if the number of Creates is 1000 and the thread number is 4, every single thread will execute 250 Creates (1000/4).
After the execution of the test (or any error) the temporary database is dropped.

## Results
This is a sample of a result:

```
OrientDB Stress Tool v.2.2.4-SNAPSHOT - Copyrights (c) 2016 OrientDB LTD
WARNING: 'tx' option not found. Defaulting to 0.
Created database [plocal:/var/folders/zc/y34429014c3bt_x1587qblth0000gn/T/stress-test-db-20160623_233800].
Starting workload CRUD - concurrencyLevel=8...
Stress test in progress 100% [Creates: 100% - Reads: 100% - Updates: 100% - Deletes: 100%]
Total execution time: 33.629 secs

Created 100000 records in 8.558 secs - Throughput: 11684.973/sec - Avg: 0.086ms/op (7th percentile) - 99th Perc: 3.577ms - 99.9th Perc: 8.148ms
Read    100000 records in 3.397 secs - Throughput: 29437.738/sec - Avg: 0.034ms/op (0th percentile) - 99th perc: 3.400ms - 99.9th Perc: 15.435ms
Updated 100000 records in 7.710 secs - Throughput: 12970.169/sec - Avg: 0.077ms/op (35th percentile) - 99th perc: 16.216ms - 99.9th Perc: 33.249ms
Deleted 100000 records in 13.720 secs - Throughput: 7288.630/sec - Avg: 0.137ms/op (2th percentile) - 99th perc: 5.970ms - 99.9th Perc: 12.395ms

Dropped database [plocal:/var/folders/zc/y34429014c3bt_x1587qblth0000gn/T/stress-test-db-20160623_233800].
```


The first part of the result is updated as long as the test is running, to give the user an idea of how long it will last. It will be deleted as soon as the test successfully terminates.
The second part shows the results of the test:
* The total time of execution
* The times of execution of every operation type, their percentiles and the throughput.

The time is computed by summing up the times of execution of all the threads and dividing it by their number; the percentile value shows where the average result is located compared to all other results: if the average is a lot higher than 50%, it means that there are a few executions with higher times that lifted up the average (and you can expect better performance in general); a high percentile can happen when, for example, the OS or another process is doing something else (either CPU or I/O intensive) during the execution of the test.


If you plan to use the results of the StressTester the _o_ option is available for writing the results in JSON format on disk. 
