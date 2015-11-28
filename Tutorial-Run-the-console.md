<!-- proofread 2015-11-26 SAM -->
# Running the OrientDB Console

There are various methods you can use to connect to your database server and the individual databases, once the server is running, such as the [Network Binary](Network-Binary-Protocol.md) and [HTTP/REST](OrientDB-REST.d) protocols.  In addition to these, OrientDB provides a command-line interface for connecting to and working with the database server.


## Starting the OrientDB Console

In the OrientDB installation directory, (that is, `$ORIENTDB_HOME`, where you installed the database), under `bin`, there is a file called `console.sh` on Unix-based systems and on Windows `console.bat`.

To launch the OrientDB console, run the following command after you start the database server:

<pre>
$ <code class="lang-sh userinput">cd $ORIENTDB_HOME/bin</code>
$ <code class="lang-sh userinput">./console.sh</code>

OrientDB console v.X.X.X (build 0) www.orientdb.com
Type 'HELP' to display all the commands supported.
Installing extensions for GREMLIN language v.X.X.X

orientdb>
</pre>

The OrientDB console is now running.  From this prompt you can connect to and manage any remote or local databases available to you.

## Using the `HELP` Command

In the event that you are unfamiliar with OrientDB and the available commands, or if you need help at any time, you can use the `HELP` command, or type `?` into the console prompt.

<pre>
orientdb> <code class="lang-sql userinput">HELP</code>

AVAILABLE COMMANDS:
 * alter class &lt;command-text&gt;   Alter a class in the database schema
 * alter cluster &lt;command-text&gt; Alter class in the database schema
 ...                            ...
 * help                         Print this help
 * exit                         Close the console
</pre>

For each console command available to you, `HELP` documents its basic use and what it does.  If you know the particular command and need details on its use, you can provide arguments to `HELP` for further clarification.

<pre>
orientdb> <code class="lang-sql userinput">HELP SELECT</code>

COMMAND: SELECT
- Execute a query against the database and display the results.
SYNTAX: select &lt;query-text&gt;
WHERE:
- &lt;query-text&gt;: The query to execute
</pre>

## Connecting to Server Instances

There are some console commands, such as `LIST DATABASES` or `CREATE DATABASE`, which you can run while only connected to the server instance.  For other commands, however, you must also connect to a database, before they run without error.

>Before you can connect to a fresh server instance and fully control it, you need to know the [root password](Security.md#orientdb-server-security) for the database.  The root password is located in the configuration file at `config/orientdb-server-config.xml`.  You can find it by searching for the `<users>` element.  If you want to change it, edit the configuration file and restart the server.

>```xml
>...
><users>
>    <user resources="*"
>	      password="my_root_password"
>		  name="root"/>
>	<user resources="connect,server.listDatabases,server.dblist"
>	      password="my_guest_password"
>		  name="guest"/>
></users>
>...
>```

With the required credentials, you can connect to the database server instance on your system, or establish a remote connection to one running on a different machine.

<pre>
orientdb> <code class="lang-sql userinput">CONNECT remote:localhost root my_root_password</code>

Connecting to remote Server instance [remote:localhost] with user 'root'...OK
</pre>

Once you have established a connection to the database server, you can begin to execute commands on that server, such as `LIST DATABASES` and `CREATE DATABASE`.

<pre>
orientdb> <code class="lang-sql userinput">LIST DATABASES</code>

Found 1 databases:
* GratefulDeadConcerts (plocal)
 </pre>

To connect to this database or to a different one, use the `CONNECT` command from the console and specify the server URL, username, and password.  By default, each database has an `admin` user with a password of `admin`.

>**Warning**: Always [change the default password](Security.md#word-with-suers) on production databases.

The above `LIST DATABASES` command shows a `GratefulDeadConcerts` installed on the local server.  To connect to this database, run the following command:

<pre>
orientdb> <code class="lang-sql userinput">CONNECT remote:localhost/GratefulDeadConcerts admin admin</code>

Connecting to database [remote:localhost/GratefulDeadConcerts] with user 'admin'...OK
</pre>

The `CONNECT` command takes a specific syntax for its URL.  That is, `remote:localhost/GratefulDeadConcerts` in the example.  It has three parts:

- **Protocol**: The first part of the database address is the protocol the console should use in the connection.  In the example, this is `remote`, indicating that it should use the TCP/IP protocol.

- **Address**: The second part of the database address is hostname or IP address of the database server that you want the console to connect to.  In the example, this is `localhost`, since the connection is made to a server instance running on the local file system.

- **Database**: The third part of the address is the name of the database that you want to use.  In the case of the example, this is `GratefulDeadConcerts`.


For more detailed information about the commands, see [Console Commands](Console-Commands.md).

> **Note**: The OrientDB distribution comes with the bundled database `GratefulDeadConcerts` which represents the Graph of the [Grateful Dead's](http://en.wikipedia.org/wiki/Grateful_Dead) concerts. This database can be used by anyone to start exploring the features and characteristics of OrientDB.
