# Distributed Configuration Tuning

When you run distributed on multiple servers, you could face on a drop of performance you got with single node. While it's normal that replication has a cost, there are many ways to improve perormance on distributed configuration:
- [Use transactions]()

This could cause braking of edges in case of exception (like OConcurrentModificationException). Furthermore having 1 TX (=1 distributed operation) is faster than X operations (=x distributed operations) because the latency.

To speed up distributed cfg if the problem is the latency (slow network or many nodes), the "asynchronous" replication mode makes the difference.

