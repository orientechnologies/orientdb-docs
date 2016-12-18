---
search:
   keywords: ['roadmap', 'road map']
---

# Roadmap

This page contains the roadmap with the main enhancements for the OrientDB product. 

### Terms
- **RC**: [Release Candidate](https://en.wikipedia.org/wiki/Software_release_life_cycle#Release_candidate), is a beta version with potential to be a final product, which is ready to release unless significant bugs emerge. In this stage of product stabilization, all product features have been designed, coded and tested through one or more beta cycles with no known showstopper-class bug. A release is called code complete when the development team agrees that no entirely new source code will be added to this release. There could still be source code changes to fix defects, changes to documentation and data files, and peripheral code for test cases or utilities. Beta testers, if privately selected, will often be credited for using the release candidate as though it were a finished product. Beta testing is conducted in a client's or customer's location and to test the software from a user's perspective.
- **GA**: [General Availability](https://en.wikipedia.org/wiki/Software_release_life_cycle#General_availability_.28GA.29), is the stage where the software has "gone live" for usage in production. Users in production are suggested to plan a migration for the current GA evaluating pros and cons of the upgrade.

## Release 3.0
```
- Development started on.: June 2016
- Expected first M1......: January 2017
- Expected first M2......: February 2017
- Expected first RC......: March 2017
- Expected final GA......: March/April 2017
```

### Status
Last update: December 14, 2016

For a more detailed an updated view, look at the [Roadmap 3.0 issue](https://github.com/orientechnologies/orientdb/issues/6005).

| Module | Feature | Status                     |
|--------|---------|----------------------------|
| Core | [Multi-Threads WAL](https://github.com/orientechnologies/orientdb/issues/2989) | 30% |
| Core | [WAL Compaction](https://github.com/orientechnologies/orientdb/issues/5277) | 30% |
| Core | [Index rebuild avoid using WAL](https://github.com/orientechnologies/orientdb/issues/4568)| 0% |
| Core | [Compression of used space on serialization](https://github.com/orientechnologies/orientdb/issues/3742)| 3%  |
| Core | Improved DISKCACHE algorithm| 60%  |
| Core | Index per cluster | 0% |
| Core | [New data structure to manage edges](https://github.com/orientechnologies/orientdb/issues/4491)| 0% |
| SQL | Distributed SQL Executor | 70% |
| SQL | Multi-line queries in batch scripts | 100% |
| Java API | New factories | 100% |
| Java API | [Improve SQL UPDATE syntax](https://github.com/orientechnologies/orientdb/issues/4814)  | 100% |
| Java API | [Support for TinkerPop 3](https://github.com/orientechnologies/orientdb/issues/2441) | 70% |
| Remote protocol | Support for server-side transactions | 10% |
| Remote protocol | Support for server-side cursors | 90% |
| Remote protocol | [Push messages on schema change](https://github.com/orientechnologies/orientdb/issues/3496) |0% |
| Remote protocol | [Push messages on record change](https://github.com/orientechnologies/orientdb/issues/3496) |0% |
| Distributed | Auto-Sharding | 10% |
| Distributed | Optimized network protocol to send only the delta between updates| 50% |


## Release 3.1
```
- Development started on.: -
- Expected first RC......: TBD
- Expected final GA......: TBD
```

### Status
Last update: April 12, 2015

| Module | Feature | Status                     |
|--------|---------|----------------------------|
| Core | [Parallel Transactions](https://github.com/orientechnologies/orientdb/issues/1677)| 0%|
| Core | Indexing of embedded properties | 0% |
| Core | Override of properties | 0% |
| Core | Enhance isolation level also for remote commands| 0% |
| Distributed | Optimized replication for cross Data Center | 0% |
| Distributed | Replication of in-memory databases | 0% |
| Lucene | Faceted search | 20% |
| Java API | [ODocument.update()](https://github.com/orientechnologies/orientdb/issues/4813)  | 0% |
| SQL | [shortestPaths() function](https://github.com/orientechnologies/orientdb/issues/4474) | 0% |
| SQL | New functions (strings, maths) | 40% |
