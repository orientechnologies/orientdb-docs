<!-- proofread 2015-11-26 SAM -->

# Install as Service on Unix/Linux

OrientDB ships with a script, which will allow you to run the database server as a daemon.  You can find it in the `bin/` directory of your installation, (that is, at `$ORIENTDB_HOME/bin/orientdb.sh`.

The script supports three parameters:

- `start`
- `stop`
- `status`


## Configuring the Script

Before you install the script on your system, you need to edit the file to define two variables: the path to the OrientDB installation directory and the user you want to run the the database server with.

```sh
$ vi $ORIENTDB_HOME/bin/orientdb.sh

#!/bin/sh
# OrientDB service script
#
# Copyright (c) Orient Technologies LTD (http://www.orientechnologies.com)

# chkconfig: 2345 20 80
# description: OrientDb init script
# processname: orientdb.sh

# You have to SET the OrientDB installation directory here
ORIENTDB_DIR="YOUR_ORIENTDB_INSTALLATION_PATH"
ORIENTDB_USER="USER_YOU_WANT_ORIENTDB_RUN_WITH"
```

The path to the installation directory, `ORIENTDB_DIR`, tells OrientDB where to look for all other scripts and files it needs to run.  The `ORIENTDB_USER` variable tells OrientDB the specific user it should use when running the database server on your system.


## Installing the Script

Different operating systems have different procedures to managing system daemons, as well as configuring them to start and stop during boot and shutdown.  For more information check with the documentation for your system.


### Linux Setup

For Linux and Unix distributions that rely on `init`, copy the edited system daemon file to the `/etc/init.d/`.  To make the console accessible, copy the console script file to the system binary directory `/usr/bin`

```sh
$ cp $ORIENTDB_HOME/bin/orientdb.sh /etc/init.d/orientdb
$ cp $ORIENTDB_HOME/bin/console.sh /usr/bin/orientdb
```

Doing this makes the script accessible to the `service` command.  You can now start the database server using the following command:

```sh
$ service orientdb start
```

Once the database starts, it is accessible through the console script.

<pre>
$ <code class="lang-sh userinput">orientdb</code>

OrientDB console v.1.6 www.orientechnologies.com
Type 'HELP' to display all the commands supported.

orientdb>
</pre>


### Mac OS X Setup

For Mac OS X, create an alias to OrientDB system daemon script and the console.

```sh
$ alias orientdb-server=/path/to/$ORIENTDB_HOME/bin/orientdb.sh
$ alias orientdb-console=/path/to/$ORIENTDB_HOME/bin/console.sh
```

You can now start the OrientDB database server using the following command:

```sh
$ orientdb-server start
```

Once the database starts, it is accessible through the console script.

<pre>
$ <code class="lang-sh userinput">orientdb-console</code>

OrientDB console v.1.6 www.orientechnologies.com
Type 'HELP' to display all the commands supported.

orientdb>
</pre>


## Other resources

To learn more about how to install OrientDB on specific environment please follow the guide below:
- [Install on Linux Ubuntu](http://famvdploeg.com/blog/2013/01/setting-up-an-orientdb-server-on-ubuntu/)
- [Install on JBoss AS](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+JBoss+AS)
- [Install on GlassFish](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+GlassFish)
- [Install on Ubuntu 12.04 VPS (DigitalOcean)](https://www.digitalocean.com/community/articles/how-to-install-and-use-orientdb-on-an-ubuntu-12-04-vps)
- [Install as service on Unix, Linux and MacOSX](Unix-Service.md)
- [Install as service on Windows](Windows-Service.md)
