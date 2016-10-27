# Multi Tenant

There are at least two ways to build multi-tenant applications on top of OrientDB.

## One database per tenant



Pros:
- Easy to use: to create/drop a new tenant, simply create/drop the database
- Easy to scale up by moving the database on different servers

Cons:
- Hard to create reports and analytics cross tenant, it requires to execute the same query against all the databases

## Use Partitioned Graphs

By using the OrientDB's record level security, it's possible to have multiple partitions of graphs accessible by different users. For more information look at [Partitioned Graphs](Partitioned-Graphs.md).

Pros:
- Easy to create reports and analytics cross tenant, because it's just one database
- It's possible to scale up on multiple servers by using sharding

Cons:
- Performance: record level security has an overhead, specially with queries
- Scales worse than "One database per tenant" solution, because the database will end up to be much bigger
- Hard to guarantee a predictable level of service for all the users, because users connect to a tenant impact the other tenants

