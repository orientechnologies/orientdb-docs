### OrientDB Stress Test Tool ###
The OrientDB Stress Test Tool is an utility for very basic benchmarking of OrientDB.

## Syntax
	StressTester
		-m [plocal|memory|remote|distributed] (mandatory)
		-n iterationsNumber
		-s operationSet
		-t threadsNumber
		--root-password rootPassword (optional)
		--remote-ip remoteIpOrHost (optional)
		--remote-port remotePort (optional)

* the _m_ parameter sets the type of database to be stressed (distributed is not yet implemented).
* the _t_ parameter sets the number of threads that will be launched. Every thread will execute the complete operationSe. If not present, it defaults to 4.
* the _n_ parameter sets the number of iterations to execute (where every iteration is a whole OperationSet executed by _n_ executors). If not present, it defaults to 10.
* the _s_ parameter defines which and how many operations to execute. It is in the form of C#R#U#D#, where the '#' is a number:
 * C1000 defines 1000 Create operations
 * R1000 defines 1000 Read operations
 * U1000 defines 1000 Update operations
 * D1000 defines 1000 Delete operations
So a valid set is C1000R1000U1000D1000. 
There are two constraints: both the number of reads and deletes must be greater than the number of creates. 
If not present, it defaults to C5000R5000U5000D5000.
* the _remote-ip_ parameter defines the remote host (or IP) of the server to connect to. The StressTester will fail if this parameter is not specified and mode is _remote_.
* the _remote-port_ parameter defines the port of the server to connect to. If not specified, it defaults to 2424.
* the _root-password_ parameter sets the root password of the server to connect to. If not specified and if mode is _remote_, the root password will be asked at the start of the test.


If the StressTester is launched without parameters, it fails because the _-m_ parameter is mandatory.

## How it works
The stress tester tool creates the specified database 
The stress tester tool creates a pool of N threads (where N is the threadsNumber parameter) that - all together - execute the number of operations defined in the OperationSet.
So, if the number of Creates is 1000, the iteration number is 10 and the thread number is 2, every single thread will execute 500 Creates (1000/2), divided in 10 iterations of 50 Creates each.

## Results
This is a sample of a result:

	Starting execution.
	Stress test in progress 100% [Creates: 100% - Reads: 100% - Updates: 100% - Deletes: 100%]

    OrientDB Stress Test v0.1
    Mode: PLOCAL, Threads: 4, Iterations: 10, Operations: [Creates: 1000 - Reads: 1000 - Updates: 500 - Deletes: 500]
    
    Total execution time: 4.59 seconds.
    Average time for 250 Creates: 0.06 secs [65th percentile] - Throughput: 4,149/s.
    Average time for 250 Reads: 0.05 secs [57th percentile] - Throughput: 4,992/s.
    Average time for 250 Updates: 0.08 secs [62th percentile] - Throughput: 1,516/s.
    Average time for 250 Deletes: 0.09 secs [95th percentile] - Throughput: 1,453/s.

The first part of the result is updated as long as the test is running, to give the user an idea of how long it will last. It will be deleted as soon as the test successfully terminates.
The second part shows the results of the test:
* The total time of execution
* The average times of execution of every operation, their percentiles and the throughput.


The average time is computed by averaging all the iterations (of all the threads) for that operation; the percentile value shows where the average result is located compared to all other results: if the average is a lot higher than 50%, it means that there are a few executions with higher times that lifted up the average (and you can expect better performance in general); a high percentile can happen when, for example, the OS or another process is doing something else (either CPU or I/O intensive) during the execution of the test.
