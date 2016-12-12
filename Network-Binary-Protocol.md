---
search:
   keywords: ['Network Binary Protocol', 'binary protocol']
---

# Binary Protocol

Current protocol version for 2.1.x: **32**. Look at [Compatibility](#compatibility) for retro-compatibility.

# Introduction

The OrientDB binary protocol is the fastest way to interface a client application to an OrientDB Server instance. The aim of this page is to provide a starting point from which to build a language binding, maintaining high-performance.

If you'd like to develop a new binding, please take a look to the available ones before starting a new project from scratch: [Existent Drivers](Programming-Language-Bindings.md).

Also, check the available [REST implementations](OrientDB-REST.md).

Before starting, please note that:
- **[Record](Concepts.md#wiki-record)** is an abstraction of **[Document](Concepts.md#wiki-document)**. However, keep in mind that in OrientDB you can handle structures at a lower level than Documents. These include positional records, raw strings, raw bytes, etc.

For more in-depth information please look at the Java classes:
- Client side: [OStorageRemote.java](https://github.com/nuvolabase/orientdb/tree/master/client/src/main/java/com/orientechnologies/orient/client/remote/OStorageRemote.java)
- Server side: [ONetworkProtocolBinary.java](https://github.com/nuvolabase/orientdb/tree/master/server/src/main/java/com/orientechnologies/orient/server/network/protocol/binary/ONetworkProtocolBinary.java)
- Protocol constants: [OChannelBinaryProtocol.java](https://github.com/nuvolabase/orientdb/tree/master/enterprise/src/main/java/com/orientechnologies/orient/enterprise/channel/binary/OChannelBinaryProtocol.java)

## Connection

*(Since 0.9.24-SNAPSHOT Nov 25th 2010)* Once connected, the server sends a short number (2 byte) containing the binary protocol number. The client should check that it supports that version of the protocol. Every time the protocol changes the version is incremented.

## Getting started

After the connection has been established, a client can <b>Connect</b> to the server or request the opening of a database <b>Database Open</b>. Currently, only TCP/IP raw sockets are supported. For this operation use socket APIs appropriate to the language you're using. After the <b>Connect</b> and <b>Database Open</b> all the client's requests are sent to the server until the client closes the socket. When the socket is closed, OrientDB Server instance frees resources the used for the connection.

The first operation following the socket-level connection must be one of:
- [Connect to the server](#connect) to work with the OrientDB Server instance
- [Open a database](#db_open) to open an existing database

In both cases a [Session-Id](#session-id) is sent back to the client. The server assigns a unique Session-Id to the client. This value must be used for all further operations against the server. You may open a database after connecting to the server, using the same Session-Id

## Session
The session management supports two modes: stateful and stateless:
- the stateful is based on a [Session-id](#session-id)
- the stateless is based on a [Token](#token)

The session mode is selected at open/connect operation.

## Session-Id

All the operations that follow the open/connect must contain, as the first parameter, the client **Session-Id** (as Integer, 4 bytes) and it will be sent back on completion of the request just after the result field.

*NOTE: In order to create a new server-side connection, the client must send a negative number into the open/connect calls.*

This **Session-Id** can be used into the client to keep track of the requests if it handles multiple session bound to the same connection. In this way the client can implement a sharing policy to save resources. This requires that the client implementation handle the response returned and dispatch it to the correct caller thread.

|    |    |
|----|----|
|![](images/warning.png)|Opening multiple TCP/IP sockets against OrientDB Server allows to parallelize requests. However, pay attention to use one Session-id per connection. If multiple sockets use the same Session-Id, requests will not be executed concurrently on the server side.|

## Token

All the operation in a stateless session are based on the token, the token is a byte[] that contains all the information for the interaction with the server, the token is acquired at the moment of open or connect, and need to be resend for each request. the session id used in the stateful requests is still there and is used to associate the request to the response. in the response can be resend a token in case of expire renew.

# Enable debug messages on protocol

To make the development of a new client easier it's strongly suggested to activate debug mode on the binary channel. To activate this, edit the file `orientdb-server-config.xml` and configure the new parameter `network.binary.debug` on the "binary" or "distributed" listener. E.g.:

```
...
<listener protocol="distributed" port-range="2424-2430"
ip-address="127.0.0.1">
  <parameters>
    <parameter name="network.binary.debug" value="true" />
  </parameters>
</listener>
...
```

In the log file (or the console if you have configured the `orientdb-server-log.properties` file)
all the packets received will be printed.

# Exchange

This is the typical exchange of messages between client and server sides:
```
+------+ +------+
|Client| |Server|
+------+ +------+
| TCP/IP Socket connection |
+-------------------------->|
| DB_OPEN |
+-------------------------->|
| RESPONSE (+ SESSION-ID) |
+<--------------------------+
... ...
| REQUEST (+ SESSION-ID) |
+-------------------------->|
| RESPONSE (+ SESSION-ID) |
+<--------------------------+
... ...
| DB_CLOSE (+ SESSION-ID) |
+-------------------------->|
| TCP/IP Socket close |
+-------------------------->|
```
# Network message format

In explaining the network messages these conventions will be used:
- fields are bracketed by parenthesis and contain the name and the type separated by ':'. E.g. <code>(length:int)</code>

# Supported types

The network protocol supports different types of information:
<table>
<tbody>
<tr><th>Type</th><th>Minimum length in bytes</th><th>Maximum length in bytes</th><th>Notes</th><th>Example</th></tr>
<tr><th>boolean</th><td>1</td><td>1</td><td>Single byte: 1 = true, 0 = false</td><td>1</td></tr>
<tr><th>byte</th><td>1</td><td>1</td><td>Single byte, used to store small numbers and booleans</td><td>1</td></tr>
<tr><th>short</th><td>2</td><td>2</td><td>Signed short type</td><td>01</td></tr>
<tr><th>int</th><td>4</td><td>4</td><td>Signed integer type</td><td>0001</td></tr>
<tr><th>long</th><td>8</td><td>8</td><td>Signed long type</td><td>00000001</td></tr>
<tr><th>bytes</th><td>4</td><td>N</td><td>Used for binary data. The format is <code>(length:int)[(bytes)]</code>. Send -1 as NULL</td><td><code>000511111</code></td></tr>
<tr><th>string</th><td>4</td><td>N</td><td>Used for text messages.The format is: <code>(length:int)[(bytes)](content:&lt;length&gt;)</code>. Send -1 as NULL</td><td><code>0005Hello</code></td></tr>
<tr><th>record</th><td>2</td><td>N</td><td>An entire record serialized. The format depends if a RID is passed or an entire record with its content. In case of null record then -2 as short is passed. In case of RID -3 is passes as short and then the RID: <code>(-3:short)(cluster-id:short)(cluster-position:long)</code>. In case of record: <code>(0:short)(record-type:byte)(cluster-id:short)(cluster-position:long)(record-version:int)(record-content:bytes)</code></td><td></td></tr>
<tr><th>strings</th><td>4</td><td>N</td><td>Used for multiple text messages. The format is: <code>(length:int)[(Nth-string:string)]</code></td><td><code>00020005Hello0007World!</code></td></tr>
</tbody>
</table>

**Note** when the type of a field in a response depends on the values of the previous fields, that field will be written without the type (e.g., `(a-field)`). The type of the field will be then specified based on the values of the previous fields in the description of the response.

# Record format
The record format is choose during the [CONNECT](#request_connect) or [DB_OPEN](#request_db_open) request, the formats available are:

[CSV](Record-CSV-Serialization.md) (serialization-impl value "ORecordDocument2csv")
[Binary](Record-Schemaless-Binary-Serialization.md) (serialization-impl value "ORecordSerializerBinary")

The CSV format is the default for all the versions 0.* and 1.* or for any client with Network Protocol Version < 22

# Request

Each request has own format depending of the operation requested. The operation requested is indicated in the first byte:
- *1 byte* for the operation. See [Operation types](#Operation_types) for the list
- **4 bytes** for the [Session-Id](#session-id) number as Integer
- **N bytes** optional token bytes only present if the REQUEST_CONNECT/REQUEST_DB_OPEN return a token.
- **N bytes** = message content based on the operation type

## Operation types

<table>
<tr><th>Command</th><th>Value as byte</th><th>Description</th><th>Async</th><th>Since</th></tr>

<tr><td colspan="5"><h3>Server <i>(CONNECT Operations)</i></h3></td></tr>
<tr><td><a href="#request_shutdown">REQUEST_SHUTDOWN</a></td><td>1</td><td>Shut down server.</td><td>no</td><td></td></tr>
<tr><td><a href="#request_connect">REQUEST_CONNECT</a></td><td>2</td><td>Required initial operation</b> to access to server commands.</td><td>no</td><td></td></tr>
<tr><td><a href="#request_db_open">REQUEST_DB_OPEN</a></td><td>3</td><td><b>Required initial operation</b> to access to the database.</td><td>no</td><td></td></tr>
<tr><td><a href="#request_db_create">REQUEST_DB_CREATE</a></td><td>4</td><td>Add a new database.</td><td>no</td><td></td></tr>
<tr><td><a href="#request_db_exist">REQUEST_DB_EXIST</a></td><td>6</td><td>Check if database exists.</td><td>no</td><td></td></tr>
<tr><td><a href="#request_db_drop">REQUEST_DB_DROP</a></td><td>7</td><td>Delete database.</td><td>no</td><td></td></tr>
<tr><td>REQUEST_CONFIG_GET</td><td>70</td><td>Get a configuration property.</td><td>no</td><td></td></tr>
<tr><td>REQUEST_CONFIG_SET</td><td>71</td><td>Set a configuration property.</td><td>no</td><td></td></tr>
<tr><td>REQUEST_CONFIG_LIST</td><td>72</td><td>Get a list of configuration properties.</td><td>no</td><td></td></tr>
<tr><td>REQUEST_DB_LIST<td>74</td><td>Get a list of databases.</td><td>no</td><td>1.0rc6</td></tr>

<tr><td colspan="5"><h3>Database <i>(DB_OPEN Operations)</i></h3></td></tr>
<tr><td><a href="#request_db_close">REQUEST_DB_CLOSE</a></td><td>5</td><td>Close a database.</td><td>no</td><td></td></tr>

<tr><td><a href="#request_db_size">REQUEST_DB_SIZE</a></td><td>8</td><td>Get the size of a database (in bytes).</td><td>no</td><td>0.9.25</td></tr>
<tr><td><a href="#request_db_countrecords">REQUEST_DB_COUNTRECORDS</a></td><td>9</td><td>Get total number of records in a database.</td><td>no</td><td>0.9.25</td></tr>
<tr><td><a href="#request_datacluster_add">REQUEST_DATACLUSTER_ADD (deprecated)</a></td><td>10</td><td>Add a data cluster.</td><td>no</td><td></td></tr>
<tr><td><a href="#request_datacluster_drop">REQUEST_DATACLUSTER_DROP (deprecated)</a><td>11</td><td>Delete a data cluster.</td><td>no</td><td></td></tr>
<tr><td><a href="#request_datacluster_count">REQUEST_DATACLUSTER_COUNT (deprecated)</a></td><td>12</td><td>Get the total number of data clusters.</td><td>no</td><td></td></tr>
<tr><td><a href="#request_datacluster_datarange">REQUEST_DATACLUSTER_DATARANGE (deprecated)</a></td><td>13</td><td>Get the data range of data clusters.</td><td>no</td><td></td></tr>
<tr><td>REQUEST_DATACLUSTER_COPY</td><td>14</td><td>Copy a data cluster.</td><td>no</td><td></td></tr>
<tr><td>REQUEST_DATACLUSTER_LH_CLUSTER_IS_USED</td><td>16</td><td></td><td>no</td><td>1.2.0</td></tr>
<tr><td>REQUEST_RECORD_METADATA</td><td>29</td><td>Get metadata from a record.</td><td>no</td><td>1.4.0</td></tr>
<tr><td><a href="#request_record_load">REQUEST_RECORD_LOAD</a></td><td>30</td><td>Load a record.</td><td>no</td><td></td></tr>
<tr><td><a href="#request_record_load_if_version_not_latest">REQUEST_RECORD_LOAD_IF_VERSION_NOT_LATEST</a></td><td>44</td><td>Load a record.</td><td>no</td><td>2.1-rc4</td></tr>

<tr><td><a href="#request_record_create">REQUEST_RECORD_CREATE</a></td><td>31</td><td>Add a record.</td><td>yes</td><td></td></tr>
<tr><td><a href="#request_record_update">REQUEST_RECORD_UPDATE</a></td><td>32</td><td><Update a record./td><td>yes</td><td></td></tr>
<tr><td><a href="#request_record_delete">REQUEST_RECORD_DELETE</a></td><td>33</td><td>Delete a record.</td><td>yes</td><td></td></tr>
<tr><td>REQUEST_RECORD_COPY</td><td>34</td><td>Copy a record.</td><td>yes</td><td></td></tr>
<tr><td>REQUEST_RECORD_CLEAN_OUT</td><td>38</td><td>Clean out record.</td><td>yes</td><td>1.3.0</td></tr>
<tr><td>REQUEST_POSITIONS_FLOOR</td><td>39</td><td>Get the last record.</td><td>yes</td><td>1.3.0</td></tr>
<tr><td>REQUEST_COUNT <i>(DEPRECATED)</i></td><td>40</td><td>See REQUEST_DATACLUSTER_COUNT</td><td>no</td><td></td></tr>
<tr><td><a href="#request_command">REQUEST_COMMAND</a></td><td>41</td><td>Execute a command.</td><td>no</td><td></td></tr>
<tr><td>REQUEST_POSITIONS_CEILING</td><td>42</td><td>Get the first record.</td><td>no</td><td>1.3.0</td></tr>
<tr><td><a href="#request_tx_commit">REQUEST_TX_COMMIT</a></td><td>60</td><td>Commit transaction.</td><td>no</td><td></td></tr>
<tr><td><a href="#request_db_reload">REQUEST_DB_RELOAD</a></td><td>73</td><td>Reload database.</td><td>no</td><td>1.0rc4</td></tr>
<tr><td>REQUEST_PUSH_RECORD<td>79</td><td></td><td>no</td><td>1.0rc6</td></tr>
<tr><td>REQUEST_PUSH_DISTRIB_CONFIG<td>80</td><td></td><td>no</td><td>1.0rc6</td></tr>
<tr><td><a href="#request_push_live_query">REQUEST_PUSH_LIVE_QUERY</a><td>81</td><td></td><td>no</td><td>2.1-rc2</td></tr>
<tr><td>REQUEST_DB_COPY<td>90</td><td></td><td>no</td><td>1.0rc8</td></tr>
<tr><td>REQUEST_REPLICATION<td>91</td><td></td><td>no</td><td>1.0</td></tr>
<tr><td>REQUEST_CLUSTER<td>92</td><td></td><td>no</td><td>1.0</td></tr>
<tr><td>REQUEST_DB_TRANSFER<td>93</td><td></td><td>no</td><td>1.0.2</td></tr>
<tr><td>REQUEST_DB_FREEZE<td>94</td><td></td><td>no</td><td>1.1.0</td></tr>
<tr><td>REQUEST_DB_RELEASE<td>95</td><td></td><td>no</td><td>1.1.0</td></tr>
<tr><td>REQUEST_DATACLUSTER_FREEZE (deprecated)<td>96</td><td></td><td>no</td><td></td></tr>
<tr><td>REQUEST_DATACLUSTER_RELEASE (deprecated)<td>97</td><td></td><td>no</td><td></td></tr>
<tr><td>REQUEST_CREATE_SBTREE_BONSAI<td>110</td><td>Creates an sb-tree bonsai on the remote server</td><td>no</td><td>1.7rc1</td></tr>
<tr><td>REQUEST_SBTREE_BONSAI_GET<td>111</td><td>Get value by key from sb-tree bonsai</td><td>no</td><td>1.7rc1</td></tr>
<tr><td>REQUEST_SBTREE_BONSAI_FIRST_KEY<td>112</td><td>Get first key from sb-tree bonsai</td><td>no</td><td>1.7rc1</td></tr>
<tr><td>REQUEST_SBTREE_BONSAI_GET_ENTRIES_MAJOR<td>113</td><td>Gets the portion of entries greater than the specified one. If returns 0 entries than the specified entrie is the largest</td><td>no</td><td>1.7rc1</td></tr>
<tr><td>REQUEST_RIDBAG_GET_SIZE<td>114</td><td>Rid-bag specific operation. Send but does not save changes of rid bag. Retrieves computed size of rid bag.</td><td>no</td><td>1.7rc1</td></tr>
<tr><td>REQUEST_INDEX_GET<td>120</td><td>Lookup in an index by key</td><td>no</td><td>2.1rc4</td></tr>
<tr><td>REQUEST_INDEX_PUT<td>121</td><td>Create or update an entry in an index</td><td>no</td><td>2.1rc4</td></tr>
<tr><td>REQUEST_INDEX_REMOVE<td>122</td><td>Remove an entry in an index by key</td><td>no</td><td>2.1rc4</td></tr>
<tr><td>REQUEST_INCREMENTAL_RESTORE</td><td> Incremental restore </td><td>no</td><td>2.2-rc1</td></tr>
</table>

# Response

Every request has a response unless the command supports the asynchronous mode (look at the table above).
- **1 byte**: Success status of the request if succeeded or failed (0=OK, 1=ERROR)
- **4 bytes**: [Session-Id](#session-id) (Integer)
- **N bytes** optional token, is only present for token based session (REQUEST_CONNECT/REQUEST_DB_OPEN return a token) and is usually empty(N=0) is only filled up by the server when renew of an expiring token is required.
- **N bytes**: Message content depending on the operation requested

# Push Request

A push request is a message sent by the server without any request from the client, it has a similar structure of a response and is distinguished using the respose status byte:

- **1 byte**: Success status has value 3 in case of push request
- **4 bytes**: [Session-Id](#session-id) has everytime MIN_INTEGER value (-2^31)
- **1 byte**: Push command id
- **N bytes**: Message content depending on the push massage, this is written as a `(content:bytes)` having inside the details of the specific message.


## Statuses

Every time the client sends a request, and the command is not in asynchronous mode (look at the table above), client must read the one-byte response status that indicates OK or ERROR. The rest of response bytes depends on this first byte.
```
* OK = 0;
* ERROR = 1;
* PUSH_REQUEST = 3
```


**OK response bytes are depends for every request type. ERROR response bytes sequence described below.**

## Errors

The format is: `[(1)(exception-class:string)(exception-message:string)]*(0)(serialized-exception:bytes)`

The pairs exception-class and exception-message continue while the following byte is 1. A 0 in this position indicates that no more data follows.

E.g. (parentheses are used here just to separate fields to make this easier to read: they are not present in the server response):
```
(1)(com.orientechnologies.orient.core.exception.OStorageException)(Can't open the storage 'demo')(0)
```
Example of 2 depth-levels exception:
```
(1)(com.orientechnologies.orient.core.exception.OStorageException)(Can't open the storage 'demo')(1)(com.orientechnologies.orient.core.exception.OStorageException)(File not found)(0)
```

Since 1.6.1 we also send serialized version of exception thrown on server side. This allows to preserve full
stack trace of server exception on client side but this feature can be used by Java clients only.

# Operations

This section explains the *request* and *response* messages of all suported operations.

## REQUEST_SHUTDOWN

Shut down the server. Requires "shutdown" permission to be set in *orientdb-server-config.xml* file.

```
Request: (user-name:string)(user-password:string)
Response: empty
```
Typically the credentials are those of the OrientDB server administrator. This is not the same as the *admin* user for individual databases.


## REQUEST_CONNECT

This is the first operation requested by the client when it needs to work with the server instance. This operation returns the [Session-Id](#session-id) of the new client to reuse for all the next calls.

```
Request: (driver-name:string)(driver-version:string)(protocol-version:short)(client-id:string)(serialization-impl:string)(token-session:boolean)(support-push)(collect-stats)(user-name:string)(user-password:string)
Response: (session-id:int)(token:bytes)
```

#### Request

- client's **driver-name** - the name of the client driver. Example: "OrientDB Java client"
- client's **driver-version** - the version of the client driver. Example: "1.0rc8-SNAPSHOT"
- client's **protocol-version** - the version of the protocol the client wants to use. Example: 30
- client's **client-id** - can be null for clients. In clustered configurations it's the distributed node ID as TCP `host:port`. Example: "10.10.10.10:2480"
- client's **serialization-impl** - the [serialization format](#record-format) required by the client
- **token-session** - true if the client wants to use a token-based session, false otherwise
- **support-push** - supports push messages from the server (starting from v34)
- **collect-stats** - collects statistics for the connection (starting from v34)
- **user-name** - the username of the user on the server. Example: "root"
- **user-password** - the password of the user on the server. Example: "37aed6392"

Typically the credentials are those of the OrientDB server administrator. This is not the same as the *admin* user for individual databases.


#### Response

- **session-id** - the new session id or a match id in case of token authentication.
- **token** - the token for token-based authentication. If the clients sends **token-session** as false in the request or the server doesn't support token-based authentication, this will be an empty `byte[]`.


## REQUEST_DB_OPEN

This is the first operation the client should call. It opens a database on the remote OrientDB Server. This operation returns the [Session-Id](#session-id) of the new client to reuse for all the next calls and the list of configured [clusters](Concepts.md#wikiCluster) in the opened databse.

```
Request: (driver-name:string)(driver-version:string)(protocol-version:short)(client-id:string)(serialization-impl:string)(token-session:boolean)(support-push:boolean)(collect-stats:boolean)(database-name:string)(user-name:string)(user-password:string)
Response: (session-id:int)(token:bytes)(num-of-clusters:short)[(cluster-name:string)(cluster-id:short)](cluster-config:bytes)(orientdb-release:string)
```

#### Request

- client's **driver-name** - the name of the client driver. Example: "OrientDB Java client".
- client's **driver-version** - the version of the client driver. Example: "1.0rc8-SNAPSHOT"
- client's **protocol-version** - the version of the protocol the client wants to use. Example: 30.
- client's **client-id** - can be null for clients. In clustered configurations it's the distributed node ID as TCP `host:port`. Example: "10.10.10.10:2480".
- client's **serialization-impl** - the [serialization format](#record-format) required by the client.
- **token-session** - true if the client wants to use a token-based session, false otherwise.
- **support-push** - true if the client support push request
- **collect-stats** - true if this connection is to be counted on the server stats, normal client should use true
- **database-name** - the name of the database to connect to. Example: "demo".
- **user-name** - the username of the user on the server. Example: "root".
- **user-password** - the password of the user on the server. Example: "37aed6392".

#### Response

- **session-id** - the new session id or a match id in case of token authentication.
- **token** - the token for token-based authentication. If the clients sends **token-session** as false in the request or the server doesn't support token-based authentication, this will be an empty `byte[]`.
- **num-of-clusters** - the size of the array of clusters in the form `(cluster-name:string)(cluster-id:short)` that follows this number.
- **cluster-name**, **cluster-id** - the name and id of a cluster.
- **cluster-config** - it's usually null unless running in a server clustered configuration.
- **orientdb-release** - contains the version of the OrientDB release deployed on the server and optionally the build number. Example: "1.4.0-SNAPSHOT (build 13)".

## REQUEST_DB_REOPEN

Used on new sockets for associate the specific socket with the server side session for the specific client, can be used exclusively with the token authentication

```
Request:empty 
Response:(session-id:int)
```


## REQUEST_DB_CREATE

Creates a database in the remote OrientDB server instance.

```
Request: (database-name:string)(database-type:string)(storage-type:string)(backup-path)
Response: empty
```

#### Request

- **database-name** - the name of the database to create. Example: "MyDatabase".
- **database-type** - the type of the database to create. Can be either `document` or `graph` (since version 8). Example: "document".
- **storage-type** - specifies the storage type of the database to create. It can be one of the [supported types](Concepts.md#wiki-Database_URL):
  - `plocal` - persistent database
  - `memory` - volatile database
- **backup-path** - path of the backup file to restore located on the server's file system (since version 36). This is used when a database is created starting from a previous backup

**Note**: it doesn't make sense to use `remote` in this context.


## REQUEST_DB_CLOSE

Closes the database and the network connection to the OrientDB server instance. No response is expected.

```
Request: empty
Response: no response, the socket is just closed at server side
```


## REQUEST_DB_EXIST

Asks if a database exists in the OrientDB server instance.

```
Request: (database-name:string)(server-storage-type:string)
Response: (result:boolean)
```

#### Request

- **database-name** - the name of the target database. *Note* that this was empty before `1.0rc1`.
- **storage-type** - specifies the storage type of the database to be checked for existence. Since `1.5-snapshot`. It can be one of the [supported types](Concepts.md#wiki-Database_URL):
  - `plocal` - persistent database
  - `memory` - volatile database

#### Response

- **result** - true if the given database exists, false otherwise.


## REQUEST_DB_RELOAD

Reloads information about the given database. Available since `1.0rc4`.

```
Request: empty
Response: (num-of-clusters:short)[(cluster-name:string)(cluster-id:short)]
```

#### Response

- **num-of-clusters** - the size of the array of clusters in the form `(cluster-name:string)(cluster-id:short)` that follows this number.
- **cluster-name**, **cluster-id** - the name and id of a cluster.


## REQUEST_DB_DROP

Removes a database from the OrientDB server instance. This operation returns a successful response if the database is deleted successfully. Otherwise, if the database doesn't exist on the server, it returns an error (an `OStorageException`).

```
Request: (database-name:string)(storage-type:string)
Response: empty
```

#### Request

- **database-name** - the name of the database to remove.
- **storage-type** - specifies the storage type of the database to create. Since `1.5-snapshot`. It can be one of the [supported types](Concepts.md#wiki-Database_URL):
  - `plocal` - persistent database
  - `memory` - volatile database


## REQUEST_DB_SIZE

Returns the size of the currently open database.

```
Request: empty
Response: (size:long)
```

#### Response

- **size** - the size of the current database.


## REQUEST_DB_COUNTRECORDS

Returns the number of records in the currently open database.

```
Request: empty
Response: (count:long)
```

#### Response

- **count** - the number of records in the current database.


## REQUEST_DATACLUSTER_ADD

Add a new data cluster. Deprecated.
```
Request: (name:string)(cluster-id:short - since 1.6 snapshot)
Response: (new-cluster:short)
```
Where: type is one of "PHYSICAL" or "MEMORY".
If cluster-id is -1 (recommended value) new cluster id will be generated.

## REQUEST_DATACLUSTER_DROP

Remove a cluster. Deprecated.
```
Request: (cluster-number:short)
Response: (delete-on-clientside:byte)
```

Where:
- **delete-on-clientside** can be 1 if the cluster has been successfully removed and the client has to remove too, otherwise 0

## REQUEST_DATACLUSTER_COUNT

Returns the number of records in one or more clusters. Deprecated.
```
Request: (cluster-count:short)(cluster-number:short)*(count-tombstones:byte)
Response: (records-in-clusters:long)
```
Where:
- **cluster-count** the number of requested clusters
- **cluster-number** the cluster id of each single cluster
- **count-tombstones** the flag which indicates whether deleted records should be taken in account. It is applicable for autosharded storage only, otherwise it is ignored.
- **records-in-clusters** is the total number of records found in the requested clusters

### Example

Request the record count for clusters 5, 6 and 7. Note the "03" at the beginning to tell you're passing 3 cluster ids (as short each). 1,000 as long (8 bytes) is the answer.
```
Request: 03050607
Response: 00001000
```

## REQUEST_DATACLUSTER_DATARANGE

Returns the range of record ids for a cluster. Deprecated.
```
Request: (cluster-number:short)
Response: (begin:long)(end:long)
```
### Example

Request the range for cluster 7. The range 0-1,000 is returned in the response as 2 longs (8 bytes each).
```
Request: 07
Response: 0000000000001000
```
## REQUEST_RECORD_LOAD

Loads a record by its [RecordID](Concepts.md#RecordID), according to a [fetch plan](Fetching-Strategies.md).

```
Request: (cluster-id:short)(cluster-position:long)(fetch-plan:string)(ignore-cache:boolean)(load-tombstones:boolean)
Response: [(payload-status:byte)[(record-type:byte)(record-version:int)(record-content:bytes)]*]+
```

#### Request

- **cluster-id**, **cluster-position** - the RecordID of the record.
- **fetch-plan** - the [fetch plan](Fetching-Strategies.md) to use or an empty string.
- **ignore-cache** - if true tells the server to ignore the cache, if false tells the server to not ignore the cache. Available since protocol v.9 (introduced in release 1.0rc9).
- **load-tombstones** - a flag which indicates whether information about deleted record should be loaded. The flag is applied only to autosharded storage and ignored otherwise.

#### Response

- **payload-status** - can be:
  - `0`: no records remain to be fetched.
  - `1`: a record is returned as resultset.
  - `2`: a record is returned as pre-fetched to be loaded in client's cache only. It's not part of the result set but the client knows that it's available for later access. This value is not currently used.
- **record-type** - can be:
  - `d`: document
  - `b`: raw bytes
  - `f`: flat data


## REQUEST_RECORD_LOAD_IF_VERSION_NOT_LATEST

Loads a record by [RecordID](Concepts.md#RecordID), according to a [fetch plan](Fetching-Strategies.md). The record is only loaded if the persistent version is more recent of the version specified in the request.

```
Request: (cluster-id:short)(cluster-position:long)(version:int)(fetch-plan:string)(ignore-cache:boolean)
Response: [(payload-status:byte)[(record-type:byte)(record-version:int)(record-content:bytes)]*]*
```

#### Request

- **cluster-id**, **cluster-position** - the RecordID of the record.
- **version** - the version of the record to fetch.
- **fetch-plan** - the [fetch plan](Fetching-Strategies.md) to use or an empty string.
- **ignore-cache** - if true tells the server to ignore the cache, if false tells the server to not ignore the cache. Available since protocol v.9 (introduced in release 1.0rc9).

#### Response

- `payload-status` - can be:
  - `0`: no records remain to be fetched.
  - `1`: a record is returned as resultset.
  - `2`: a record is returned as pre-fetched to be loaded in client's cache only. It's not part of the result set but the client knows that it's available for later access. This value is not currently used.
- `record-type` - can be:
  - `d`: document
  - `b`: raw bytes
  - `f`: flat data


## REQUEST_RECORD_CREATE

Creates a new record. Returns the RecordID of the newly created record.. New records can have version > 0 (since `1.0`) in case the RecordID has been recycled.

```
Request: (cluster-id:short)(record-content:bytes)(record-type:byte)(mode:byte)
Response: (cluster-id:short)(cluster-position:long)(record-version:int)(count-of-collection-changes)[(uuid-most-sig-bits:long)(uuid-least-sig-bits:long)(updated-file-id:long)(updated-page-index:long)(updated-page-offset:int)]*
```

#### Request

- **cluster-id** - the id of the cluster in which to create the new record.
- **record-content** - the record to create serialized using the appropriate [serialization format](#record-format) chosen at connection time.
- **record-type** - the type of the record to create. It can be:
  - `d`: document
  - `b`: raw bytes
  - `f`: flat data
- **mode** - can be:
  - `0` - **synchronous**. It's the default mode which waits for the answer before the response is sent.
  - `1` - **asynchronous**. The response is identical to the synchronous response, but the driver is encouraged to manage the answer in a callback.
  - `2` - **no-response**. Don't wait for the answer (*fire and forget*). This mode is useful on massive operations since it reduces network latency.

In versions before `2.0`, the response started with an additional **datasegment-id**, the segment id to store the data (available since version 10 - `1.0-SNAPSHOT`), with -1 meaning default one.

#### Response

- **cluster-id**, **cluster-position** - the RecordID of the newly created record.
- **record-version** - the version of the newly created record.

The last part of response (from `count-of-collection-changes` on) refers to [RidBag](RidBag.md) management. Take a look at [the main page](RidBag.md) for more details.


## REQUEST_RECORD_UPDATE

Updates the record identified by the given [RecordID](Concepts.md#RecordID). Returns the new version of the record.

```
Request: (cluster-id:short)(cluster-position:long)(update-content:boolean)(record-content:bytes)(record-version:int)(record-type:byte)(mode:byte)
Response: (record-version:int)(count-of-collection-changes)[(uuid-most-sig-bits:long)(uuid-least-sig-bits:long)(updated-file-id:long)(updated-page-index:long)(updated-page-offset:int)]*
```

#### Request

- **cluster-id**, **cluster-position** - the RecordID of the record to update.
- **update-content** - can be:
  - true - the content of the record has been changed and should be updated in the storage.
  - false - the record was modified but its own content has not changed: related collections (e.g. RidBags) have to be updated, but the record version and its contents should not be updated.
- **record-content** - the new contents of the record serialized using the appropriate [serialization format](#record-format) chosen at connection time.
- **record-version** - the version of the record to update.
- **record-type** - the type of the record to create. It can be:
  - `d`: document
  - `b`: raw bytes
  - `f`: flat data
- **mode** - can be:
  - `0` - **synchronous**. It's the default mode which waits for the answer before the response is sent.
  - `1` - **asynchronous**. The response is identical to the synchronous response, but the driver is encouraged to manage the answer in a callback.
  - `2` - **no-response**. Don't wait for the answer (*fire and forget*). This mode is useful on massive operations since it reduces network latency.

#### Response

- **record-version** - the new version of the updated record

The last part of response (from `count-of-collection-changes` on) refers to [RidBag](RidBag.md) management. Take a look at [the main page](RidBag.md) for more details.


## REQUEST_RECORD_DELETE

Delete a record identified by the given [RecordID](Concepts.md#RecordID). During the optimistic transaction the record will be deleted only if the given version and the version of the record on the server match. This operation returns true if the record is deleted successfully, false otherwise.

```
Request: (cluster-id:short)(cluster-position:long)(record-version:int)(mode:byte)
Response: (has-been-deleted:boolean)
```

#### Request

- **cluster-id**, **cluster-position** - the RecordID of the record to delete.
- **record-version** - the version of the record to delete.
- **mode** - can be:
  - `0` - **synchronous**. It's the default mode which waits for the answer before the response is sent.
  - `1` - **asynchronous**. The response is identical to the synchronous response, but the driver is encouraged to manage the answer in a callback.
  - `2` - **no-response**. Don't wait for the answer (*fire and forget*). This mode is useful on massive operations since it reduces network latency.

#### Response

- **has-been-deleted** - true if the record is deleted successfully, false if it's not or if the record with the given RecordID doesn't exist.


## REQUEST_COMMAND

Executes remote commands.

```
Request: (mode:byte)(command-payload-length:int)(class-name:string)(command-payload)
Response:
- synchronous commands: [(synch-result-type:byte)[(synch-result-content:?)]]+
- asynchronous commands: [(asynch-result-type:byte)[(asynch-result-content:?)]*](pre-fetched-record-size.md)[(pre-fetched-record)]*+
```

#### Request

- **mode** - it can assume one of the following values:
  - `a` - asynchronous mode
  - `s` - synchronous mode
  - `l` - live mode
- **command-payload-length** - the length of the **class-name** field plus the length of the **command-payload** field.
- **class-name** - the class name of the command implementation. There are some short forms for the most common commands, which are:
  - `q` - stands for "query" as idempotent command (e.g., `SELECT`). It's like passing `com.orientechnologies.orient.core.sql.query.OSQLSynchquery`.
  - `c` - stands for "command" as non-idempotent command (e.g., `INSERT` or `UPDATE`). It's like passing `com.orientechnologies.orient.core.sql.OCommandSQL`.
  - `s` - stands for "script" (for server-side scripting using languages like [JavaScript](Javascript-Command.md)). It's like passing `com.orientechnologies.orient.core.command.script.OCommandScript`.
  - any other string - the string is the class name of the command. The command will be created via reflection using the default constructor and invoking the `fromStream()` method against it.
- **command-payload** - is the payload of the command as specified in [the "Commands" section](Network-Binary-Protocol-Commands.md).

#### Response

Response is different for synchronous and asynchronous request:
- **synchronous**:
- **synch-result-type** can be:
 - 'n', means null result
 - 'r', means single record returned
 - 'l', list of records. The format is:
    - an integer to indicate the collection size. Starting form v32, size can be -1 to stream a resultset. Last item will be null
    - all the records and each entry is typed with a short that can be:
       - '0' a record in the next bytes
       - '-2' no record and is considered as a null record
       - '-3' only a recordId in the next bytes
 - 's', set of records. The format is:
    - an integer to indicate the collection size. Starting form v32, size can be -1 to stream a resultset. Last item will be null
    - all the records and each entry is typed with a short that can be:
       - '0' a record in the next bytes
       - '-2' no record and is considered as a null record
       - '-3' only a recordId in the next bytes
 - 'w', is a simple result wrapped inside a single record, deserialize the record as the `r` option and unwrap the real result reading the field `result` of the record.
 - 'i', iterable of records
   - the result records will be streamed, no size as start is given, each entry has a flag at the start(same as **asynch-result-type**)
     - 0: no record remain to be fetched
     - 1: a record in the next bytes
     - 2: a recordin the next bytes to be loaded in client's cache only. It's not part of the result set but
- **synch-result-content**, can only be a record
- **pre-fetched-record-size**, as the number of pre-fetched records not directly part of the result set but joined to it by fetching
- **pre-fetched-record** as the pre-fetched record content
- **asynchronous**:
- **asynch-result-type** can be:
 - 0: no records remain to be fetched
 - 1: a record is returned as a resultset
 - 2: a record is returned as pre-fetched to be loaded in client's cache only. It's not part of the result set but the client knows that it's available for later access
- **asynch-result-content**, can only be a record


## REQUEST_TX_COMMIT

Commits a transaction. This operation flushes all the pending changes to the server side.

```
Request: (transaction-id:int)(using-tx-log:boolean)(tx-entry)*(0-byte indicating end-of-records)
Response: (created-record-count:int)[(client-specified-cluster-id:short)(client-specified-cluster-position:long)(created-cluster-id:short)(created-cluster-position:long)]*(updated-record-count:int)[(updated-cluster-id:short)(updated-cluster-position:long)(new-record-version:int)]*(count-of-collection-changes:int)[(uuid-most-sig-bits:long)(uuid-least-sig-bits:long)(updated-file-id:long)(updated-page-index:long)(updated-page-offset:int)]*
```

#### Request

- **transaction-id** - the id of the transaction. Read the "Transaction ID" section below for more information.
- **using-tx-log** - tells the server whether to use the transaction log to recover the transaction or not. Use `true` by default to ensure consistency. *Note*: disabling the log could speed up the execution of the transaction, but it makes impossible to rollback the transaction in case of errors. This could lead to inconsistencies in indexes as well, since in case of duplicated keys the rollback is not called to restore the index status.
- **tx-entry** - a list of elements (terminated by a 0 byte) with the form described below.

##### Transaction entry

Each transaction entry can specify one out of three actions to perform: create, update or delete.

The general form of a transaction entry (**tx-entry** above) is:

```
(1:byte)(operation-type:byte)(cluster-id:short)(cluster-position:long)(record-type:byte)(entry-content)
```

The first byte means that there's another entry next. The values of the rest of these attributes depend directly on the operation type.

##### Update

- **operation-type** - has the value 1.
- **cluster-id**, **cluster-position** - the RecordID of the record to update.
- **record-type** - the type of the record to update (`d` for document, `b` for raw bytes and `f` for flat data).
- **entry-content** - has the form `(version:int)(update-content:boolean)(record-content:bytes)` where:
  - **update-content** - can be:
    - true - the content of the record has been changed and should be updated in the storage.
    - false - the record was modified but its own content has not changed: related collections (e.g. RidBags) have to be updated, but the record version and its contents should not be updated.
  - **version** - the version of the record to update.
  - **record-content** - the new contents of the record serialized using the appropriate [serialization format](#record-format) chosen at connection time.

###### Delete

- **operation-type** - has the value 2.
- **cluster-id**, **cluster-position** - the RecordID of the record to update.
- **record-type** - the type of the record to update (`d` for document, `b` for raw bytes and `f` for flat data).
- **entry-content** - has the form `(version:int)` where:
  - **version** - the version of the record to delete.

###### Create

- **operation-type** - has the value 3.
- **cluster-id**, **cluster-position** - when creating a new record, set the cluster id to `-1`. The cluster position must be an integer `< -1`, unique in the scope of the transaction (meaning that if two new records are being created in the same transaction, they should have two different ids both `< -1`).
- **record-type** - the type of the record to update (`d` for document, `b` for raw bytes and `f` for flat data).
- **entry-content** - has the form `(record-content:bytes)` where:
  - **record-content** - the new contents of the record serialized using the appropriate [serialization format](#record-format) chosen at connection time.

##### Transaction ID

Each transaction must have an ID; the client is responsible for assigning an ID to each transaction. The ID must be unique in the scope of each session.

#### Response

The response contains two parts:

- a map of "temporary" client-generated record ids to "real" server-provided record ids for each **created** record (not guaranteed to have the same order as the records in the request).
- a map of **updated** record ids to update record versions.

If the version of a created record is not `0`, then the RecordID of the created record will also appear in the list of "updated" records, along with its new version. This is a [known bug](https://github.com/orientechnologies/orientdb/issues/4660).

Look at [Optimistic Transaction](Transactions.md#wiki-Optimistic_Transaction) to know how temporary [RecordID](Concepts.md#RecordID)s are managed.

The last part of response (from `count-of-collection-changes` on) refers to [RidBag](RidBag.md) management. Take a look at [the main page](RidBag.md) for more details.


## REQUEST_INDEX_GET

Lookups in an index by key.

```
Request: (index-name:string)(key:document)(fetch-plan:string)
Response: (result-type:byte)
```

#### Request

- **index-name** - the name of the index.
- **key** - a document whose `"key"` field contains the key.
- **fetch-plan** - the [fetch plan](Fetching-Strategies.md) to use or an empty string.

#### Response

- **key** - is stored in the field named "key" inside the document
- **result-type** can be:
 - 'n', means null result
 - 'r', means single record returned
 - 'l', list of records. The format is:
  - an integer to indicate the collection size
  - all the records one by one
 - 's', set of records. The format is:
  - an integer to indicate the collection size
  - all the records one by one
 - 'a', serialized result, a byte[] is sent
- **synch-result-content**, can only be a record
- **pre-fetched-record-size**, as the number of pre-fetched records not directly part of the result set but joined to it by fetching
- **pre-fetched-record** as the pre-fetched record content


## REQUEST_INDEX_PUT

Create or update an entry in index by key.

```
Request: (index-name:string)(key:document)(value:rid)
Response: no response
```

Where:
- **key** is stored in the field named "key" inside the document


## REQUEST_INDEX_REMOVE

Remove an entry by key from an index. It returns true if the entry was present, otherwise false.

```
Request: (index-name:string)(key:document)
Response: (found:boolean)
```

Where:
- **key** is stored in the field named "key" inside the document

### REQUEST_CREATE_SBTREE_BONSAI
```
Request: (clusterId:int)
Response: (collectionPointer)
```
See: [serialization of collection pointer](RidBag.md#serialization-of-collection-pointer)

Creates an sb-tree bonsai on the remote server.

### REQUEST_SBTREE_BONSAI_GET
```
Request: (collectionPointer)(key:binary)
Response: (valueSerializerId:byte)(value:binary)
```
See: [serialization of collection pointer](RidBag.md#serialization-of-collection-pointer)

Get value by key from sb-tree bonsai.

Key and value are serialized according to format of tree serializer.
If the operation is used by RidBag key is always a RID and value can be null or integer.


### REQUEST_SBTREE_BONSAI_FIRST_KEY
```
Request: (collectionPointer)
Response: (keySerializerId:byte)(key:binary)
```
See: [serialization of collection pointer](RidBag.md#serialization-of-collection-pointer)

Get first key from sb-tree bonsai. Null if tree is empty.

Key are serialized according to format of tree serializer.
If the operation is used by RidBag key is null or RID.

### REQUEST_SBTREE_BONSAI_GET_ENTRIES_MAJOR
```
Request: (collectionPointer)(key:binary)(inclusive:boolean)(pageSize:int)
Response: (count:int)[(key:binary)(value:binary)]*
```
See: [serialization of collection pointer](RidBag.md#serialization-of-collection-pointer)

Gets the portion of entries major than specified one. If returns 0 entries than the specified entry is the largest.

Keys and values are serialized according to format of tree serializer.
If the operation is used by RidBag key is always a RID and value is integer.

Default pageSize is 128.

### REQUEST_RIDBAG_GET_SIZE
```
Request: (collectionPointer)(collectionChanges)
Response: (size:int)
```
See: [serialization of collection pointer](RidBag.md#serialization-of-collection-pointer), [serialization of collection changes](RidBag.md#serialization-of-rid-bag-changes)

Rid-bag specific operation. Send but does not save changes of rid bag. Retrieves computed size of rid bag.

# Special use of LINKSET types
> NOTE. Since 1.7rc1 this feature is deprecated. Usage of RidBag is preferable.

Starting from 1.0rc8-SNAPSHOT OrientDB can transform collections of links from the classic mode:
```
[#10:3,#10:4,#10:5]
```
to:
```
(ORIDs@pageSize:16,root:#2:6)
```

For more information look at the announcement of this new feature: https://groups.google.com/d/topic/orient-database/QF52JEwCuTM/discussion

In practice to optimize cases with many relationships/edges the collection is transformed in a mvrb-tree. This is because the embedded object. In that case the important thing is the link to the root node of the balanced tree.

You can disable this behaviour by setting

*mvrbtree.ridBinaryThreshold* = -1

Where *mvrbtree.ridBinaryThreshold* is the threshold where OrientDB will use the tree instead of plain collection (as before). -1 means "hey, never use the new mode but leave all as before".

## Tree node binary structure

To improve performance this structure is managed in binary form. Below how is made:
```
+-----------+-----------+--------+------------+----------+-----------+---------------------+
| TREE SIZE | NODE SIZE | COLOR .| PARENT RID | LEFT RID | RIGHT RID | RID LIST .......... |
+-----------+-----------+--------+------------+----------+-----------+---------------------+
| 4 bytes . | 4 bytes . | 1 byte | 10 bytes ..| 10 bytes | 10 bytes .| 10 * MAX_SIZE bytes |
+-----------+-----------+--------+------------+----------+-----------+---------------------+
= 39 bytes + 10 * PAGE-SIZE bytes
```

Where:
- *TREE SIZE* as signed integer (4 bytes) containing the size of the tree. Only the root node has this value updated, so to know the size of the collection you need to load the root node and get this field. other nodes can contain not updated values because upon rotation of pieces of the tree (made during tree rebalancing) the root can change and the old root will have the "old" size as dirty.
- *NODE SIZE* as signed integer (4 bytes) containing number of entries in this node. It's always <= to the page-size defined at the tree level and equals for all the nodes. By default page-size is 16 items
- *COLOR* as 1 byte containing 1=Black, 0=Red. To know more about the meaning of this look at [Red-Black Trees](http://en.wikipedia.org/wiki/Red%E2%80%93black_tree)
- **PARENT RID** as [RID](Concepts.md#record-id) (10 bytes) of the parent node record
- **LEFT RID** as [RID](Concepts.md#record-id) (10 bytes) of the left node record
- **RIGHT RID** as [RID](Concepts.md#record-id) (10 bytes) of the right node record
- **RID LIST** as the list of [RIDs](Concepts.md#record-id) containing the references to the records. This is pre-allocated to the configured page-size. Since each [RID](Concepts.md#record-id) takes 10 bytes, a page-size of 16 means 16 x 10bytes = 160bytes

The size of the tree-node on disk (and memory) is fixed to avoid fragmentation. To compute it: 39 bytes + 10 * PAGE-SIZE bytes. For a page-size = 16 you'll have 39 + 160 = 199 bytes.

### REQUEST_PUSH_DISTRIB_CONFIG 

```
(configuration:document)
```

where:
**configuration** is and oriendb document serialized with the network [Record Format](#record-format), that contain the distributed configuration.


### REQUEST_PUSH_LIVE_QUERY

```
(message-type:byte)(message-body)
```
where:  
**message-type** is the type of message and can have as a value  
  - *RECORD* = 'r'
  - *UNSUBSCRIBE* = 'u'  

**message-body** is one for each type of message


##### Record Message Body:

```
(operation:byte)(query_token:int)(record-type:byte)(record-version:int)(cluster-id:short)(cluster-position:long)(record-content:bytes)
```
where:  
**operation** the tipe of operation happened, possible values  
  - *LOADED* = 0
  - *UPDATED* = 1 
  - *DELETED* = 2
  - *CREATED* = 3
  
**query_token** the token that identify the relative query of the push message, it match the result token of the live query command request.  
**record-type** type of the record ('d' or 'b')   
**record-version**  record version  
**cluster-id** record cluster id   
**cluster-position** record cluster position  
**record-content** record content  

##### Usubscribe Message Body:

```
(query_token:int)
```

**query_token** the token for identify the query that has been usubscribed.

# History

## version 36

add support for REQUEST_INCREMENTAL_RESTORE

## version 35

command result review:
add support for "wrapped types" on command result set, removed support for "simple types".

is now possible a new option `w` over the one already existent `r`,`s`,`l`,`i`
it consist in a document serialized in the same way of `r` that wrap the result in a field called `result`.

the old options `a` for simple results is now removed.


## version 34

Add flags `support-push` and `collect-stats` on  REQUEST_DB_OPEN.

## version 33

Removed the token data from error heandling header in case of non token session.
Removed the db-type from REQUEST_DB_OPEN
added REQUEST_DB_REOPEN

## Version 32
Added support of streamable resultset in case of sync command, added a new result of type 'i' that stream the result in the same way of async result.

## Version 31
Added new commands to manipulate idexes: REQUEST_INDEX_GET, REQUEST_INDEX_PUT and REQUEST_INDEX_REMOVE.

## Version 30
Added new command REQUEST_RECORD_LOAD_IF_VERSION_NOT_LATEST

## Version 29
Added support support of live query in REQUEST_COMMAND, added new push command REQUEST_PUSH_LIVE_QUERY

## Version 28
Since version 28 the [REQUEST_RECORD_LOAD](#request_record_load) response order is changed from:
`[(payload-status:byte)[(record-content:bytes)(record-version:int)(record-type:byte)]*]+`
to:
`[(payload-status:byte)[(record-type:byte)(record-version:int)(record-content:bytes)]*]+`

## Version 27

Since version 27 is introduced an extension to allow use a token based session, if this modality is enabled a few things change in the modality the protocol works.

* in the first negotiation the client should ask for a token based authentication using the token-auth flag
* the server will reply with a token or an empty byte array that means that it not support token based session and is using a old style session.
* if the server don't send back the token the client can fail or drop back the the old modality.
* for each request the client should send the token and the sessionId
* the sessionId is needed only for match a response to a request
* if used the token the connections can be shared between users and db of the same server, not needed to have connection associated to db and user.

protocol methods changed:

REQUEST_DB_OPEN
* request add token session flag
* response add of the token

REQUEST_CONNECT
* request add token session flag
* response add of the token

## Version 26
Added cluster-id in the REQUEST_CREATE_RECORD response.

## Version 25
Reviewd serialization of index changes in the REQUEST_TX_COMMIT for detais [#2676](https://github.com/orientechnologies/orientdb/issues/2676)
Removed double serialization of commands parameters, now the parameters are directly serialized in a document see [Network Binary Protocol Commands](Network-Binary-Protocol-Commands.md) and [#2301](https://github.com/orientechnologies/orientdb/issues/2301)

## Version 24
 - cluster-type and cluster-dataSegmentId parameters were removed from response for REQUEST_DB_OPEN, REQUEST_DB_RELOAD requests.
 - datasegment-id parameter was removed from REQUEST_RECORD_CREATE request.
 - type, location and datasegment-name parameters were removed from REQUEST_DATACLUSTER_ADD request.
 - REQUEST_DATASEGMENT_ADD  request was removed.
 - REQUEST_DATASEGMENT_DROP request was removed.

## Version 23
 - Add support of `updateContent` flag to UPDATE_RECORD and COMMIT

## Version 22
 - REQUEST_CONNECT and REQUEST_OPEN now send the document serialization format that the client require

## Version 21
- REQUEST_SBTREE_BONSAI_GET_ENTRIES_MAJOR (which is used to iterate through SBTree) now gets "pageSize" as int as last argument. Version 20 had a fixed pageSize=5. The new version provides configurable pageSize by client. Default pageSize value for protocol=20 has been changed to 128.

## Version 20
- Rid bag commands were introduced.
- Save/commit was adapted to support client notifications about changes of collection pointers.

## Version 19
- Serialized version of server exception is sent to the client.

## Version 18
- Ability to set cluster id during cluster creation was added.

## Version 17
- Synchronous commands can send fetched records like asynchronous one.

## Version 16
- Storage type is required for REQUEST_DB_FREEZE, REQUEST_DB_RELEASE, REQUEST_DB_DROP, REQUEST_DB_EXIST commands.
- This is required to support plocal storage.

## Version 15
- SET types are stored in different way then LIST. Before rel. 15 both were stored between squared braces [] while now SET are stored between <>

## Version 14
- DB_OPEN returns information about version of OrientDB deployed on server.

## Version 13
- To support upcoming auto-sharding support feature following changes were done
  - RECORD_LOAD flag to support ability to load tombstones was added.
  - DATACLUSTER_COUNT flag to support ability to count tombstones in cluster was added.

## Version 12
- DB_OPEN returns the dataSegmentId foreach cluster

## Version 11
- RECORD_CREATE always returns the record version. This was necessary because new records could have version > 0 to avoid MVCC problems on RID recycle

# Compatibility

Current release of OrientDB server supports older client versions.
- version 35: 100% compatible 2.2-SNAPSHOT
- version 34: 100% compatible 2.2-SNAPSHOT
- version 34: 100% compatible 2.2-SNAPSHOT
- version 33: 100% compatible 2.2-SNAPSHOT
- version 32: 100% compatible 2.1-SNAPSHOT
- version 31: 100% compatible 2.1-SNAPSHOT
- version 30: 100% compatible 2.1-SNAPSHOT
- version 29: 100% compatible 2.1-SNAPSHOT
- version 28: 100% compatible 2.1-SNAPSHOT
- version 27: 100% compatible 2.0-SNAPSHOT
- version 26: 100% compatible 2.0-SNAPSHOT
- version 25: 100% compatible 2.0-SNAPSHOT
- version 24: 100% compatible 2.0-SNAPSHOT
- version 23: 100% compatible 2.0-SNAPSHOT
- version 22: 100% compatible 2.0-SNAPSHOT
- version 22: 100% compatible 2.0-SNAPSHOT
- version 21: 100% compatible 1.7-SNAPSHOT
- version 20: 100% compatible 1.7rc1-SNAPSHOT
- version 19: 100% compatible 1.6.1-SNAPSHOT
- version 18: 100% compatible 1.6-SNAPSHOT
- version 17: 100% compatible. 1.5
- version 16: 100% compatible. 1.5-SNAPSHOT
- version 15: 100% compatible. 1.4-SNAPSHOT
- version 14: 100% compatible. 1.4-SNAPSHOT
- version 13: 100% compatible. 1.3-SNAPSHOT
- version 12: 100% compatible. 1.3-SNAPSHOT
- version 11: 100% compatible. 1.0-SNAPSHOT
- version 10: 100% compatible. 1.0rc9-SNAPSHOT
- version 9: 100% compatible. 1.0rc9-SNAPSHOT
- version 8: 100% compatible. 1.0rc9-SNAPSHOT
- version 7: 100% compatible. 1.0rc7-SNAPSHOT - 1.0rc8
- version 6: 100% compatible. Before 1.0rc7-SNAPSHOT
- < version 6: not compatible
