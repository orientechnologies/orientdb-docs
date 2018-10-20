# OrientDB Server Process

Using the [`server`](service.md) or [`dserver`](dserver.md) shell scripts or batch files you can manually start the OrientDB Server. While this is often sufficient for testing or experimentation, however, in production environments it is preferable to user process and service management tools, like init and systemd.


## Service Installation

In order to manage OrientDB through process or service management tools, you first need to install it on your system.  The `bin/` directory of your OrientDB installation contains an `orientdb.sh` script that you need to modify and install at `/etc/init.d/orientdb`.

For instance,

```
# cp $ORIENTDB_HOME/bin/orientdb.sh /etc/init.d/orientdb
```

Once you have the file in place, edit it and modify the two script variables at the top of the file.

| Variable | Description |
|---|---|
| `ORIENTDB_HOME` | Defines the path where you've installed OrientDB |
| `ORIENTDB_USER` | Defines the system user you want the script to switch to before it starts the server |


### Service File

In cases where your host uses systemd for service and process management, you also need to copy the `orientdb.service` file.

```
# cp $ORIENTDB_HOME/bin/orientdb.service /etc/systemd/system
```

Once this is done, edit the service file to update values on the following fields:

| Field | Description |
|---|---|
| `User` | Set to the user you want to switch to when running the OrientDB Server |
| `Group` | Set to the group you want to switch to when running the OrientDB Server |
| `ExecStart` | Set to the path to `orientdb` init script copied above, `/etc/init.d/orientdb` |


## Usage

On operating systems that use init for process management, copying the OrientDB script and setting the variables is enough to manage it using the `service` command.  On hosts that utilize systemd, you also need to copy over the `orientdb.service` file.  

### Usage with init

When working with a host that uses init, you can manage the OrientDB Server using the following commands:

To start the OrientDB Server:

```
# service orientdb start
```

To stop the OrientDB Server

```
# service orientdb stop
```

To start OrientDB when the server boots:

```
# service orientdb enable
```

### Usage with systemd


When working with a host that uses systemd, you can manage the OrientDB Server using the following commands:

To start the OrientDB Server:

```
# systemctl start orientdb 
```

To stop the OrientDB Server

```
# systemctl stop orientdb 
```

To start OrientDB when the server boots:

```
# systemctl enable orientdb 
```






