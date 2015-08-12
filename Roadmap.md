# Roadmap

This page contains the roadmap with the main enhancement for OrientDB product. 

### Terms
- **RC**: [Release Candidate](https://en.wikipedia.org/wiki/Software_release_life_cycle#Release_candidate), is a beta version with potential to be a final product, which is ready to release unless significant bugs emerge. In this stage of product stabilization, all product features have been designed, coded and tested through one or more beta cycles with no known showstopper-class bug. A release is called code complete when the development team agrees that no entirely new source code will be added to this release. There could still be source code changes to fix defects, changes to documentation and data files, and peripheral code for test cases or utilities. Beta testers, if privately selected, will often be credited for using the release candidate as though it were a finished product. Beta testing is conducted in a client's or customer's location and to test the software from a user's perspective.
- **GA**: [General Availability](https://en.wikipedia.org/wiki/Software_release_life_cycle#General_availability_.28GA.29), is the stage whre the software has "gone live" for usage in production. Users in production are suggested to plan a migration for the current GA evaluating pros and cons of the upgrade.

## Release 2.2
```
- Development started on.: June 25th 2015
- Expected first RC......: September 2015
- Expected final GA......: October 2015
```

### Status
Last update: August 12, 2015

| Module | Feature | Status                     |
|--------|---------|----------------------------|
| OrientJS| Native unmarshaling of requests by using C code| 25% |
| Core| [Dirty Manager](https://github.com/orientechnologies/orientdb/issues/2620)| 100% |
| Core | Incremental Backup | 0% |
| Core| [Automatic minimum clusters](https://github.com/orientechnologies/orientdb/issues/4518) | 0% |
| Core | AES and DES enchryption | 100% |
| Core | [Compression of used space on serialization](https://github.com/orientechnologies/orientdb/issues/3742)| 0% |
| Core | [Increase cluster-id from short to int](https://github.com/orientechnologies/orientdb/issues/1930) | 15% |
| Distributed | Fast synchronization by using Incremental Backup | 0% |
| SQL | Pattern matching | 90% |
| SQL | Command Cache | 100% |
| SQL | Automatic parallel queries | 100% |
| SQL | Live Query -> Stable | 0% |
| SQL | New functions (strings, maths) | 40% |
| SQL | [Sequences](https://github.com/orientechnologies/orientdb/issues/367), [PR](https://github.com/orientechnologies/orientdb/pull/3744) | 80% |
| SQL | [shortestPaths() function](https://github.com/orientechnologies/orientdb/issues/4474) | 0% |
| SQL | ['Move cluster' command](https://github.com/orientechnologies/orientdb/issues/4248) | 100% |
| SQL | [Command to manage users](https://github.com/orientechnologies/orientdb/pull/4000) | 70% |
| Java API | [ODocument.eval()](https://github.com/orientechnologies/orientdb/issues/4505)  | 0% |
| Console | Dislay distributed information about [sharding](https://github.com/orientechnologies/orientdb/issues/3968) and [nodes](https://github.com/orientechnologies/orientdb/issues/3967) | 0% |
| Remote protocol | [Push messages on schema change](https://github.com/orientechnologies/orientdb/issues/3496) |0% |
| Remote protocol | [Push messages on record change](https://github.com/orientechnologies/orientdb/issues/3496) |0% |
| Lucene | Faceted search | 20% |


## Release 3.0
```
- Development started on.: September 2015
- Expected first RC......: November 2015
- Expected final GA......: December 2015
```

### Status
Last update: July 10th 2015

| Module | Feature | Status                     |
|--------|---------|----------------------------|
| Core | Override of properties | 0% |
| SQL | New SQL Executor | 5% |
| Java API | [Support fot TinkerPop 3](https://github.com/orientechnologies/orientdb/issues/2441) | 0% |
| Transactions | Enhance isolation level also for remote commands| 0% |
| Distributed | Load balancing on client | 0% |
| Distributed | Replication of in-memory databases | 0% |
| Distributed | Auto-Sharding | 0% |
| Scheduler | [Improve scheduler](https://github.com/orientechnologies/orientdb/issues/2613) | 0% |
