# Console - CONNECT

Opens a database using a URL.

## Syntax

```
CONNECT <database-url> <user-name> <user-password>
```

Where:

- **database-url**   The url of the database to connect in the format <code>&lt;mode&gt;:&lt;path&gt;</code>
- **user**           The user name
- **user-password**  The user password

## Example: connect to a local database

To connect to a local database loading it directly into the console.

Example:
```
CONNECT plocal:../databases/GratefulDeadConcerts admin admin
```

## Example: Connect to a remote database

To connect to a local or remote database by using a Orient Server.

Example:
```
CONNECT remote:127.0.0.1/GratefulDeadConcerts admin admin
```

```java
CONNECT plocal:../databases/GratefulDeadConcerts admin

Connecting to database [plocal:../databases/GratefulDeadConcerts]...OK
```

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
