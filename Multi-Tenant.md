# Multi Tenant

There are at many ways to build multi-tenant applications on top of OrientDB, in this page we are going to analyze pros and cons of three of the most used approaches.

## One database per tenant

With this solution, each tenant is a database. The OrientDB server allows to host multiple databases.

Pros:
- Easy to use: to create/drop a new tenant, simply create/drop the database
- Easy to scale up by moving the database on different servers

Cons:
- Hard to create reports and analytics cross tenant, it requires to execute the same query against all the databases

## Specific clusters per tenant

With this solution, each tenant is stored in one or more clusters of the same database. For example, the class `Product` could have the following clusters: `Product_ClientA`, `Product_ClientB`, `Product_ClientC`. In this way a query against a specific cluster will be used to retrieve data from one tenant only. Example: `select * from cluster:Product_ClientC where date >= '2016-01-01' order by date desc`. Instead, a query against the class `Product` will return a cross-tenant result. Example: `select * from Product where date >= '2016-01-01' order by date desc`

Pros:
- Easy to create reports and analytics cross tenant, because it's just one database
- It's possible to scale up on multiple servers by using sharding

Cons:
- The maximum number of clusters per database is 32,768. To bypass this limitation, use multiple databases
- No security out of the box, it's entirely up to the application to isolate access between tenants

## Use Partitioned Graphs

By using the OrientDB's record level security, it's possible to have multiple partitions of graphs accessible by different users. For more information look at [Partitioned Graphs](Partitioned-Graphs.md).

Pros:
- Easy to create reports and analytics cross tenant, because it's just one database

Cons:
- Performance: record level security has an overhead, specially with queries
- Scales worse than "One database per tenant" solution, because the database will end up to be much bigger
- Sharding is not possible because records of multiple tenants are mixed on the same clusters
- Hard to guarantee a predictable level of service for all the users, because users connect to a tenant impact the other tenants

