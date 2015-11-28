<!-- proofread 2015-11-26 SAM -->
# Running the OrientDB Server

When you finish installing OrientDB, whether you build it from source or download the binary package, you are ready to launch the database server.  You can either start it through the system daemon or through the provided server script.  This article only covers the latter.

>**Note**: If you would like to run OrientDB as a service on your system, there are some additional steps that you need to take.  This provides alternate methods for starting the server and allows you to launch it as a daemon when your system boots.  For more information on this process see:
>
>- [Install OrientDB as a Service on Unix, Linux and Mac OS X ](Unix-Service.md)
>- [Install OrientDB as a Service on Microsoft Windows](Windows-Service.md)


## Starting the Database Server

While you can run the database server as system daemon, you also have the option of starting it directly.  In the OrientDB installation directory, (that is `$ORIENTDB_HOME`), under `bin`, there is a file named `server.sh` on Unix-based systems and `server.bat` on Windows.  Executing this file starts the server.

To launch the OrientDB database server, run the following commands:

<pre>
$ <code class="lang-sh userinput">cd $ORIENTDB_HOME/bin</code>
$ <code class="lang-sh userinput">./server.sh</code>

            .
           .`        `
        ,      `:.
          `,`    ,:`
          .,.   :,,
          .,,  ,,,
     .    .,.:::::  ````
     ,`   .::,,,,::.,,,,,,`;;                      .:
     `,.  ::,,,,,,,:.,,.`  `                       .:
      ,,:,:,,,,,,,,::.   `        `         ``     .:
       ,,:.,,,,,,,,,: `::, ,,   ::,::`   : :,::`  ::::
        ,:,,,,,,,,,,::,:   ,,  :.    :   ::    :   .:
         :,,,,,,,,,,:,::   ,,  :      :  :     :   .:
   `     :,,,,,,,,,,:,::,  ,, .::::::::  :     :   .:
   `,...,,:,,,,,,,,,: .:,. ,, ,,         :     :   .:
     .,,,,::,,,,,,,:  `: , ,,  :     `   :     :   .:
       ...,::,,,,::.. `:  .,,  :,    :   :     :   .:
            ,::::,,,. `:   ,,   :::::    :     :   .:
            ,,:` `,,.
           ,,,    .,`
          ,,.     `,                      S E R V E R
        ``        `.
                  ``
                  `

2012-12-28 01:25:46:319 INFO Loading configuration from: config/orientdb-server-config.xml... [OServerConfigurationLoaderXml]
2012-12-28 01:25:46:625 INFO OrientDB Server v1.6 is starting up... [OServer]
2012-12-28 01:25:47:142 INFO -> Loaded memory database 'temp' [OServer]
2012-12-28 01:25:47:289 INFO Listening binary connections on 0.0.0.0:2424 [OServerNetworkListener]
2012-12-28 01:25:47:290 INFO Listening http connections on 0.0.0.0:2480 [OServerNetworkListener]
2012-12-28 01:25:47:317 INFO OrientDB Server v1.6 is active. [OServer]
</pre>

The database server is now running.  It is accessible on your system through ports `2424` and `2480`.
At the first startup the server will ask for the root user password. The password is stored in the config file.
 
### Stop the Server

On the console where the server is running a simple CTRL+c will shutdown the server.

The shutdown.sh (shutdown.bat) script could be used to stop the server:

<pre>
$ <code class="lang-sh userinput">cd $ORIENTDB_HOME/bin</code>
$ <code class="lang-sh userinput">./shutdown.sh -p ROOT_PASSWORD</code>
</pre>

On ***nix** systems a simple call to shutdown.sh will stop the server running on localhost:

<pre>
$ <code class="lang-sh userinput">cd $ORIENTDB_HOME/bin</code>
$ <code class="lang-sh userinput">./shutdown.sh</code>
</pre>

It is possible to stop servers running on remote hosts or even on different ports on localhost:

<pre>
$ <code class="lang-sh userinput">cd $ORIENTDB_HOME/bin</code>
$ <code class="lang-sh userinput">./shutdown.sh -h odb1.mydomain.com -P 2424-2430 -u root -p ROOT_PASSWORD</code>
</pre>

List of params

- -h | --host **HOSTNAME or IP ADDRESS** : the host or ip where OrientDB is running, default to **localhost**
- -P | --potrs **PORT or PORT RANGE** : single port value or range of ports; default to **2424-2430**
- -u | --user **ROOT USERNAME** : root's username; deafult to  **root**
- -p | --password **ROOT PASSWORD** : root's user password; **mandatory**

**NOTE**
On Windows systems password is always **mandatory** because the script isn't able to discover the pid of the OrientDB's process.

### Server Log Messages

Following the masthead, the database server begins to print log messages to standard output.  This provides you with a guide to what OrientDB does as it starts up on your system.

1. The database server loads its configuration file from the file `$ORIENTDB_HOME/config/orientdb-server-config.xml`.

   >For more information on this step, see [OrientDB Server](DB-Server.md).

1. The database server loads the `temp` database into memory.  You can use this database in storing temporary data.

1. The database server begins listening for binary connections on port `2424` for all configured networks, (`0.0.0.0`).

1. The database server begins listening for HTTP connections on port `2480` for all configured networks, (`0.0.0.0`).

## Accessing the Database Server

By default, OrientDB listens on two different ports for external connections.

- **Binary**: OrientDB listens on port `2424` for binary connections from the console and for clients and drivers that support the [Network Binary Protocol](Network-Binary-Protocol.md).

- **HTTP**: OrientDB listens on port `2480` for HTTP connections from [OrientDB Studio Web Tool](http://www.orientechnologies.com/docs/last/orientdb-studio.wiki/Home-page.html) and clients and drivers that support the [HTTP/REST protocol](OrientDB-REST.md), or similar tools, such as [cURL](http://en.wikipedia.org/wiki/cURL).

If you would like the database server to listen at different ports or IP address, you can define these values in the configuration file `config/orientdb-server-config.xml`.


