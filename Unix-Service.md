# Install as Service on Unix/Linux

OrientDB is shipped with the script ***$ORIENTDB_HOME/bin/orientdb.sh*** that can be used to run OrientDB like a daemon. It supports the following parameters:
- start
- stop
- status

Before to install it as service open the file and change the following lines:
```
ORIENTDB_DIR="YOUR_ORIENTDB_INSTALLATION_PATH"
ORIENTDB_USER="USER_YOU_WANT_ORIENTDB_RUN_WITH"
````

By setting the installation path and the user as stated, save the script, and deploy like other scripts for the other daemon.

Different Unix, Linux and MacOSX distribution uses different ways to manage the start/stop process at the system bootstrap/shutdown.


## Other resources
To learn more about how to install OrientDB on specific environment please follow the guide below:
- [Install on Linux Ubuntu](http://famvdploeg.com/blog/2013/01/setting-up-an-orientdb-server-on-ubuntu/)
- [Install on JBoss AS](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+JBoss+AS)
- [Install on GlassFish](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+GlassFish)
- [Install on Ubuntu 12.04 VPS (DigitalOcean)](https://www.digitalocean.com/community/articles/how-to-install-and-use-orientdb-on-an-ubuntu-12-04-vps)
- [Install as service on Unix, Linux and MacOSX](Unix-Service.md)
- [Install as service on Windows](Windows-Service.md)
