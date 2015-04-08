# Manage a remote Server instance

## Introduction

A remote server can be managed via API using the OServerAdmin class. Create it using the URL of the remote server as first parameter of the constructor.

```java
OServerAdmin serverAdmin = new OServerAdmin("remote:localhost:2480");
```

You can also use the URL of the remote database:
```java
OServerAdmin serverAdmin = new OServerAdmin("remote:localhost:2480/GratefulDeadConcerts");
```

## Connect to a remote server

```java
OServerAdmin serverAdmin = new OServerAdmin("remote:localhost:2480").connect("admin", "admin");
```

User and password are not the database accounts but the server users configured in [orientdb-server-config.xml](DB-Server.md#configuration) file.

When finished call the <code>OServerAdmin.close()</code> method to release the network connection.

## Create a database

To create a new database in a remote server you can use the console's [create database](Console-Command-Create-Database.md) command  or via API using the <code>OServerAdmin.createDatabase()</code> method.
```java
// ANY VERSION: CREATE A SERVER ADMIN CLIENT AGAINST A REMOTE SERVER
OServerAdmin serverAdmin = new OServerAdmin("remote:localhost/GratefulDeadConcerts").connect("admin", "admin");
serverAdmin.createDatabase("graph", "local");
```

```java
// VERSION >= 1.4: CREATE A SERVER ADMIN CLIENT AGAINST A REMOTE SERVER
OServerAdmin serverAdmin = new OServerAdmin("remote:localhost").connect("admin", "admin");
serverAdmin.createDatabase("GratefulDeadConcerts", "graph", "local");
```

The iStorageMode can be memory or [plocal](https://github.com/orientechnologies/orientdb/wiki/plocal-storage-engine).

## Drop a database

To drop a database from a server you can use the console's  [drop database](Console-Command-Drop-Database.md) command or via API using the <code>OServerAdmin.dropDatabase()</code> method.
```java
// CREATE A SERVER ADMIN CLIENT AGAINST A REMOTE SERVER
OServerAdmin serverAdmin = new OServerAdmin("remote:localhost/GratefulDeadConcerts").connect("admin", "admin");
serverAdmin.dropDatabase("GratefulDeadConcerts");
```

## Check if a database exists

To check if a database exists in a server via API use the <code>OServerAdmin.existsDatabase()</code> method.
```java
// CREATE A SERVER ADMIN CLIENT AGAINST A REMOTE SERVER
OServerAdmin serverAdmin = new OServerAdmin("remote:localhost/GratefulDeadConcerts").connect("admin", "admin");
serverAdmin.existsDatabase("local");
```
