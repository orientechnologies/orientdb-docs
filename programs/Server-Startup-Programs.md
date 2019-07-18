---
search:
   keywords: ['admin', 'administration', 'server']
---

# OrientDB Server 

OrientDB provides several methods of starting and managing the Server process.  These include individual scripts that initialize the Java Virtual Machine and start [OServer](../java/ref/OServer.md) and systemd and initscripts that allow you to launch and manage the Server using the `systemctl` or `service` utilities on Linux.

## Programs

There are two scripts that you can use to start the OrientDB Server directly.  Each script has two builds: a `.sh` shell script for use on Linux distributions and a `.bat` batch file for use on Windows.

| Script | Description |
|---|---|
| **dserver** | Used to start the OrientDB Server in distributed environments |
| **server** | Used to start a standalone OrientDB Server |

### Process Management

Where the above programs make it easy to start the Server on your desktop for experimentation and similar tasks, it is not very convenient for use on a production host.  In addition to the Server startup scripts, OrientDB also ships with a systemd service file and an initscript, which you can install on Linux distributions to start, stop and restart the OrientDB Server using either `systemctl` or `service` utilities.

For more information, see [OrientDB Server Process](orientdb.md).


