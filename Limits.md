# Limits

Below are the limitations of the OrientDB engine:
- **Databases**: There is no limit to the number of databases per server or embedded. Users reported no problem with 1000 databases open
- **Clusters**: each database can have a maximum of 32,767 clusters (2^15-1)
- **Records** per cluster (**Documents**, **Vertices** and **Edges** are stored as records): can be up to 9,223,372,036,854,780,000 (2^63-1), namely 9,223,372 Trillion records
- **Records** per database (**Documents**, **Vertices** and **Edges** are stored as records): can be up to 302,231,454,903,000,000,000,000 (2^78-1), namely 302,231,454,903 Trillion records
- **Record size**: up to 2GB each, even if we suggest avoiding the creation of records larger than 10MB. They can be split into smaller records, take a look at [Binary Data](Binary-Data.md)
- **Document Properties** can be:
 - up to 2 Billion per database for schema-full properties
 - there is no limitation regarding the number of properties in schema-less mode. The only concrete limit is the size of the Document where they can be stored. Users have reported no problems working with documents made of 15,000 properties
- **Indexes** can be up to 2 Billion per database. There are no limitations regarding the number of indexes per class
- **Queries** can return a maximum of 2 Billion rows, no matter the number of the properties per record
- **Concurrency level**: in order to guarantee atomicity and consistency, OrientDB acquire an exclusive lock on the storage during transaction commit. This means transactions are serialized. Giving this limitation, _the OrientDB team is already working on improving parallelism to achieve better scalability on multi-core machines by optimizing internal structure to avoid exclusive locking._

## Limitations running distributed
OrientDB has some limitations you should notice when you work in Distributed Mode:
- `hotAlignment:true` could bring the database status as inconsistent. Please set it always to 'false`, the default
- creation of a database on multiple nodes could cause synchronization problems when clusters are automatically created. Please create the databases before to run in distributed mode
- split network case: this is not well managed and in case you setup 4 nodes and the network is split between 2 nodes on the left, and 2 nodes on the right, each partition will think to be the only survived and on rejoin database could be inconsistent. Please always setup an odd number of nodes, so there will always be a majority in quorum
- Constraints with distributed databases could cause problems because some operations are executed at 2 steps: create + update. For example in some circumstance edges could be first created, then updated, but constraints like MANDATORY and NOTNULL against fields would fail at the first step making the creation of edges not possible on distributed mode.
