# Roadmap

This page contains the roadmap with the main enhancement for OrientDB product. 

### Terms
- **RC**: [Release Candidate](https://en.wikipedia.org/wiki/Software_release_life_cycle#Release_candidate), is a beta version with potential to be a final product, which is ready to release unless significant bugs emerge. In this stage of product stabilization, all product features have been designed, coded and tested through one or more beta cycles with no known showstopper-class bug. A release is called code complete when the development team agrees that no entirely new source code will be added to this release. There could still be source code changes to fix defects, changes to documentation and data files, and peripheral code for test cases or utilities. Beta testers, if privately selected, will often be credited for using the release candidate as though it were a finished product. Beta testing is conducted in a client's or customer's location and to test the software from a user's perspective.
- **GA**: [General Availability](https://en.wikipedia.org/wiki/Software_release_life_cycle#General_availability_.28GA.29), is the stage whre the software has "gone live" for usage in production. Users in production are suggested to plan a migration for the current GA evaluating pros and cons of the upgrade.

## Release 2.2
```
- Development started on.: June 25th 2015
- Expected BETA..........: December 14th 2015
- Expected first RC......: December 21st 2015
- Expected final GA......: January 2016
```

### Status
Last update: December 14, 2015

| Module | Feature | Status                     |
|--------|---------|----------------------------|
| OrientJS| Native unmarshaling of requests by using C++ code| 100% |
| Core| [Dirty Manager](https://github.com/orientechnologies/orientdb/issues/2620)| 100% |
| Core | Incremental Backup | 100% |
| Core| [Automatic minimum clusters](https://github.com/orientechnologies/orientdb/issues/4518) | 100% |
| Core | AES and DES enchryption | 100% |
| Core | [Support SALT in passwords](https://github.com/orientechnologies/orientdb/issues/1229) | 100% |
| Distributed | Fast synchronization by using Incremental Backup | 100% |
| Distributed / Remote protocol | [Load balancing on client](https://github.com/orientechnologies/orientdb/issues/3165) | 100% |
| SQL | Pattern matching | 100% |
| SQL | Command Cache | 100% |
| SQL | Automatic parallel queries | 100% |
| SQL | Prefetching of disk pages | 100% |
| SQL | Live Query -> Stable | 100% |
| SQL | [Update Edge](https://github.com/orientechnologies/orientdb/issues/1114)| 100% |
| SQL | [Sequences](https://github.com/orientechnologies/orientdb/issues/367), [PR](https://github.com/orientechnologies/orientdb/pull/3744) | 100% |
| SQL | ['Move cluster' command](https://github.com/orientechnologies/orientdb/issues/4248) | 100% |
| SQL | [Command to manage users](https://github.com/orientechnologies/orientdb/pull/4000) | 100% |
| Java API | [ODocument.eval()](https://github.com/orientechnologies/orientdb/issues/4505)  | 100% |
| Studio | New P2P architecture, new Enterprise modules (it replaces the Enterprise Workbench) | 100% |
| Lucene | [Spatial Module] (https://github.com/orientechnologies/orientdb-spatial) New module for indexing of shapes, not only points | 100% |

## Release 3.0
```
- Development started on.: September 2015
- Expected first RC......: March 2016
- Expected final GA......: April 2016
```

### Status
Last update: December 8, 2015

| Module | Feature | Status                     |
|--------|---------|----------------------------|
| Core | [Multi-Threads WAL](https://github.com/orientechnologies/orientdb/issues/2989) | 0% |
| Core | [WAL Compaction](https://github.com/orientechnologies/orientdb/issues/5277) | 0% |)
| Core | [Index rebuild avoid using WAL](https://github.com/orientechnologies/orientdb/issues/4568)| 0% |
| Core | [Compression of used space on serialization](https://github.com/orientechnologies/orientdb/issues/3742)| 0% |
| Core | [Increase cluster-id from short to int](https://github.com/orientechnologies/orientdb/issues/1930) | 15% |
| SQL | Distributed SQL Executor | 0% |
| SQL | [shortestPaths() function](https://github.com/orientechnologies/orientdb/issues/4474) | 0% |
| SQL | New functions (strings, maths) | 40% |
| SQL | Multi-line queries in batch scripts | 0% |
| Core | Indexing of embedded properties | 0% |
| Java API | [Support fot TinkerPop 3](https://github.com/orientechnologies/orientdb/issues/2441) | 30% |
| Distributed | Replication of in-memory databases | 0% |
| Distributed | Auto-Sharding | 0% |
| Scheduler | [Improve scheduler](https://github.com/orientechnologies/orientdb/issues/2613) | 0% |
| Console | Display distributed information about [sharding](https://github.com/orientechnologies/orientdb/issues/3968) and [nodes](https://github.com/orientechnologies/orientdb/issues/3967) | 50% |


## Release 3.1
```
- Development started on.: -
- Expected first RC......: June 2016
- Expected final GA......: August 2016
```

### Status
Last update: December 8, 2015

| Module | Feature | Status                     |
|--------|---------|----------------------------|
| Core | [Parallel Transactions](https://github.com/orientechnologies/orientdb/issues/1677)| 0%|
| Core | Override of properties | 0% |
| Core | [Auto close storages](https://github.com/orientechnologies/orientdb/issues/3055) | 0% |
| Core | Enhance isolation level also for remote commands| 0% |
| Distributed | Optimized replication for cross Data Center | 0% |
| Lucene | Faceted search | 20% |
| Java API | [ODocument.update()](https://github.com/orientechnologies/orientdb/issues/4813)  | 0% |
| Java API | [Improve SQL UPDATE syntax](https://github.com/orientechnologies/orientdb/issues/4814)  | 100% |
| Remote protocol | [Push messages on schema change](https://github.com/orientechnologies/orientdb/issues/3496) |0% |
| Remote protocol | [Push messages on record change](https://github.com/orientechnologies/orientdb/issues/3496) |0% |
