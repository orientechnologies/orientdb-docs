# Console command: share database

# Share database

Share a database with another server in the cluster. This command works only inside a cluster of servers up and running. With this operation a database will be shared in another server node.

![image](http://www.orientechnologies.com/images/share-database.png)

To execute this command you need to be connected to the remote server instance where the database resides, in the picture the **Server #1**. The server user must to have the permission to the resource "database.share". The *root* user has this priviledge.

## Syntax

```
share database <db-name> <db-user> <db-password> <server-name> <mode>
```

Where:
- **db-name**        Name of the database to share
- **db-user**        Database user
- **db-password**    Database password
- **server-name**    Remote server's name as <code>&lt;address&gt;:&lt;port&gt;</code>
- **mode**           replication mode: 'synch' or 'asynch'

## Example

```java
> connect remote:localhost:2424 root FF343F35058E4D4AF7AE12910B508384C47

Connecting to remote Server instance [remote:localhost:2424] with user 'root'...OK

> share database demo admin admin 127.0.0.1:2425 synch

Database 'demo' has been shared in 'synch' mode with '127.0.0.1:2425' the server 127.0.0.1:2425
```

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
