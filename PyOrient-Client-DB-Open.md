# PyOrient Client - `db_open()`

This method opens a database on the OrientDB Server.

## Opening Databases

When you have the name of the database that you want to use, as well as the relevant authentication credentials, you can open this database within your client.  

**Syntax**

```
client.db_open(<name>, <username>, <user-passwd>, <db-type>, <client-id>)
```

- **`<name>`** Defines the database you want to open.
- **`<username>`** Defines the database user name.
- **`<user-passwd>`** Defines the database user password.
- **`<db-type>`** Defines the database type, (optional).
  - *`pyorient.DB_TYPE_DOCUMENT`* Opens it as a Document Database.
  - *`pyorient.DB_TYPE_GRAPH`* Opens it as a Graph Database.
- **`<client-id>`** With distributed deployments, use this argument to define the distributed node.

**Example**

In the case of the example smart home database, say that after various sanity checks you're ready to start working on the database itself.  You might use a line like the one below to open the database, so that you can start using it:

```py
client.db_open("tinkerhome", "nodeuser", "node_passwd")
```

This opens the `tinkerhome` database on the PyOrient Client.  Commands issued through this object now operate on that database.
