
## SQL Changes

### Server-level Commands

In previous versions, you can run scripts (eg. SQL) on a single database connection, and the scripts are executed on the database itself. In OrientDB v 3.2 we extended the usage of scripts to the Server level.

This adds a lot of new potential for both infrastructure management and querying.

For now, we implemented some basic Server-level commands, like `CREATE/DROP DATABASE` and `CREATE SYSTEM USER`, but the infrastructure allows for potential future extensions to all the aspects of the server and data management.


Server-level commands can be executed via navite API, via REST or via CLI

