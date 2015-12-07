# Security

OrientDB is the NoSQL implementation with the greatest focus on security.

- To connect to an existing database, you need a user and password.  Users and roles are defined inside the database.  For more information on this process, see [Database Security](Database-Security.md).

- In the event that you're connecting to the OrientDB Server that is hosting the database, you can access the database using the server's user.  For more information on this process, see [Sever Security](Server-Security.md).

- Additionally, you can encrypt the database contents on disk.  For more information on this process, see [Database Encryption](Database-Encryption.md).


|   |   |
|---|---|
|![](images/warning.png)| While OrientDB Server can function as a regular Web Server, it is not recommended that you expose it directly to either the Internet or public networks.  Instead, always hide OrientDB server in private networks.|

See also:
- [Database security](Database-Security.md)
- [Server security](Server-Security.md)
- [Database Encryption](Database-Encryption.md)
- [Secure SSL connections](Using-SSL-with-OrientDB.md)
- [OrientDB Web Server](Web-Server.md)
 
