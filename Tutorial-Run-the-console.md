# Run the console

OrientDB provides a command line interface. It can be used to connect to and work with remote or local OrientDB servers.

You can start the command line interface by executing `console.sh` (or `console.bat` on Windows) located in the `bin/` directory:

``` console
$ cd bin
$ ./console.sh
```

You should now see a welcome message:

```
OrientDB console v.1.6 www.orientechnologies.com
Type 'HELP' to display all the commands supported.

orientdb>
```

Type the "help" or "?" command to see all available console commands:

``` sql
HELP

 AVAILABLE COMMANDS:
  * alter class <command-text>    Alter a class in the database schema
  ...
  * help                          Print this help
  * exit                          Close the console
```

### Connecting to server instance

Some console commands such as `list databases` or `create database` can be run while only connected to a server instance (you do not have to be connected to a database). Other commands require you to be connected to a database. Before you can connect to a fresh server instance and fully control it, you need to know the [root password](Security.md#orientdb-server-security). The root password is located in `config/orientdb-server-config.xml` (just search for the **users** element). If you want to change it, modify the XML file and then restart the server.

If you have the required credentials, you should now be able to connect using the following command:

```
CONNECT remote:localhost root password

 Connecting to remote Server instance [remote:localhost] with user 'root'...OK
```

Next, you can (for example) list databases using the command:

```
LIST DATABASES

 Found 1 databases:
  * GratefulDeadConcerts (plocal)
```

To connect to another database we can again use the `connect` command from the console and specify the server URL, username, and password. By default each database has an "admin" user with password "admin" ([change the default password](Security.md#work-with-users) on your real database). To connect to the *GratefulDeadConcerts* database on the local server execute the following:

```
CONNECT remote:localhost/GratefulDeadConcerts admin admin

 Connecting to database [remote:localhost/GratefulDeadConcerts] with user 'admin'...OK
```

Let's analyze the URL we have used: `remote:localhost/GratefulDeadConcerts`. The first part is the protocol, "remote" in this case, which contacts the server using the TCP/IP protocol. "localhost" is the host name or IP address where the server resides; in this case it is on the same machine. "GratefulDeadConcerts" is the name of the database to which we want to connect.

The OrientDB distribution comes with the bundled database *GratefulDeadConcerts* which represents the Graph of the [Grateful Dead's](http://en.wikipedia.org/wiki/Grateful_Dead) concerts. This database can be used by anyone to start exploring the features and characteristics of OrientDB.

For more detailed information about the commands see the [console](Console-Commands.md) page.
