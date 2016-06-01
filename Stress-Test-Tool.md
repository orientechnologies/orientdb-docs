### OrientDB Stress Test Tool ###
The OrientDB Stress Test Tool is an utility for very basic benchmarking of OrientDB.

## Syntax
	StressTester
		-m [plocal|memory|remote|distributed]
		-n iterationsNumber
		-s operationSet
		-t threadsNumber
		-p rootPassword (optional)

* the _m_ parameter sets the type of database to be stressed (not yet implemented: by now it only connects to a localhost server).
* the _t_ parameter sets the number of threads that will be launched. Every thread will execute the complete operationSe. If not present, it defaults to 4.
* the _n_ parameter sets the number of iterations to execute (where every iteration is a whole OperationSet executed by _n_ executors). If not present, it defaults to 10.
* the _p_ parameter sets the root password of the server to connect to. If not specified, it will be asked at the start of the test.
* the _s_ parameter defines which and how many operations to execute. It is in the form of C#R#U#D#, where the '#' is a number:
 * C1000 defines 1000 Create operations
 * R1000 defines 1000 Read operations
 * U1000 defines 1000 Update operations
 * D1000 defines 1000 Delete operations
So a valid set is C1000R1000U1000D1000. 
There are two constraints: both the number of reads and deletes must be greater than the number of creates. 
If not present, it defaults to C1000R1000U500D500.

If launched without parameters, it connects to a localhost instance of OrientDB and sets 10 iterations, 4 thread and 'C1000R1000U500D500' as the OperationSet.

## Results
This is a sample of a result:

	Starting execution.
	Stress test in progress 100% [Creates: 100% - Reads: 100% - Updates: 100% - Deletes: 100%]

    OrientDB Stress Test v0.1
    Mode: PLOCAL, Threads: 4, Iterations: 10, Operations: [Creates: 1000 - Reads: 1000 - Updates: 500 - Deletes: 500]

    Total execution time: 19.09 seconds.
    Average time for 1,000 Creates: 0.50 secs (2,009/s).
    Average time for 1,000 Reads: 0.24 secs (4,195/s).
    Average time for 500 Updates: 0.64 secs (786/s).
    Average time for 500 Deletes: 0.37 secs (1,369/s).

The first part of the result is updated as long as the test is running, to give the user an idea of how long it will last. It will be deleted as soon as the test successfully terminates.
The second part shows the results of the test:
* The total time of execution
* The partial times of execution of every operation and the throughput
