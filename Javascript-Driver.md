---
search:
   keywords: ['JavaScript', 'JavaScript API', 'JavaScript Driver']
---

# Javascript API

 
|   |   |
|---|---|
|![](images/warning.png)|This API has been deprecated, please use HTTP calls from the browser by using the [HTTP RESTful protocol](OrientDB-REST.md).|
 

------------

This driver wraps the most common use cases in database usage. All parameters required by methods or constructor are Strings. This library works on top of [HTTP RESTful protocol](OrientDB-REST.md).

*Note: Due to cross-domain XMLHttpRequest restriction this API works, for now, only placed in the server deployment. To use it with cross-site look at [Cross-site scripting](Javascript-Driver.md#cross-site-scripting).*

The full source code is available here: **[oriendb-api.js](https://github.com/nuvolabase/orientdb/blob/master/server/src/site/js/orientdb-api.js)**.

## See also
- [Javascript-Command](Javascript-Command.md)

## Example
```javascript
var database = new ODatabase('http://localhost:2480/demo');
databaseInfo = database.open();
queryResult = database.query('select from Address where city.country.name = \'Italy\'');
if (queryResult["result"].length == 0){
  commandResult = database.executeCommand('insert into Address (street,type) values (\'Via test 1\',\'Tipo test\')');
} else {
  commandResult = database.executeCommand('update Address set street = \'Via test 1\' where city.country.name = \'Italy\'');
}
database.close();
```

## API
### ODatabase object

ODatabase object requires server URL and database name:

Syntax: <code>new ODatabase(http://<host>:<port>/<databaseName>)</code>

Example:
```javascript
var orientServer = new ODatabase('http://localhost:2480/demo');
```

Once created database instance is ready to be used. Every method return the operation result when it succeeded, null elsewhere. <br/>
In case of null result the database instance will have the error message obtainable by the [getErrorMessage()](#errors) method.

### Open

Method that connects to the server, it returns database information in JSON format.<br/>

#### Browser Authentication

Syntax: <code>&lt;databaseInstance&gt;.open()</code><br/>
*Note: This implementation asks to the browser to provide user and password.*

Example:
```javascript
orientServer = new ODatabase('http://localhost:2480/demo');
databaseInfo = orientServer.open();
```

#### Javascript Authentication

Syntax: <code>&lt;databaseInstance&gt;.open(username,userpassword)</code>

Example:
```javascript
orientServer = new ODatabase('http://localhost:2480/demo');
databaseInfo = orientServer.open('admin','admin');
```

Return Example:
```json
{"classes": [
    {
      "id": 0,
      "name": "ORole",
      "clusters": [3],
      "defaultCluster": 3, "records": 3,
      "properties": [
        {
        "id": 0,
        "name": "mode",
        "type": "BYTE",
        "mandatory": false,
        "notNull": false,
        "min": null,
        "max": null,
        "indexed": false
      },
        {
        "id": 1,
        "name": "rules",
        "linkedType": "BYTE",
        "type": "EMBEDDEDMAP",
        "mandatory": false,
        "notNull": false,
        "min": null,
        "max": null,
        "indexed": false
      }
  ]},
],
"dataSegments": [
    {"id": -1, "name": "default", "size": 10485760, "filled": 1380391, "maxSize": "0", "files": "[${STORAGE_PATH}/default.0.oda]"}
  ],

"clusters": [
    {"id": 0, "name": "internal", "type": "PHYSICAL", "records": 4, "size": 1048576, "filled": 60, "maxSize": "0", "files": "[${STORAGE_PATH}/internal.0.ocl]"},
],

"txSegment": [
    {"totalLogs": 0, "size": 1000000, "filled": 0, "maxSize": "50mb", "file": "${STORAGE_PATH}/txlog.otx"}
  ], "users": [
    {"name": "admin", "roles": "[admin]"},
    {"name": "reader", "roles": "[reader]"},
    {"name": "writer", "roles": "[writer]"}
  ],

  "roles": [
    {"name": "admin", "mode": "ALLOW_ALL_BUT",
      "rules": []
    },
    {"name": "reader", "mode": "DENY_ALL_BUT",
      "rules": [{
        "name": "database", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.cluster.internal", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.cluster.orole", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.cluster.ouser", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.class.*", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.cluster.*", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.query", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.command", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.hook.record", "create": false, "read": true, "update": false, "delete": false
        }]
    },
],

  "config":{
    "values": [
      {"name": "dateFormat", "value": "yyyy-MM-dd"},
      {"name": "dateTimeFormat", "value": "yyyy-MM-dd hh:mm:ss"},
      {"name": "localeCountry", "value": ""},
      {"name": "localeLanguage", "value": "en"},
      {"name": "definitionVersion", "value": 0}
    ],
    "properties": [
    ]
  }
}
```

### Query

Method that executes the query, it returns query results in JSON format.

Syntax: <code>&lt;databaseInstance&gt;.query(&lt;queryText&gt;, [limit], [fetchPlan])</code>

Limit and [fetchPlan](Fetching-Strategies.md) are optional.

Simple Example:
```javascript
queryResult = orientServer.query('select from Address where city.country.name = \'Italy\'');
```

Return Example:
```json
{ "result": [{
      "@rid": "12:0", "@class": "Address",
      "street": "Piazza Navona, 1",
      "type": "Residence",
      "city": "#13:0"
    }, {
      "@rid": "12:1", "@class": "Address",
      "street": "Piazza di Spagna, 111",
      "type": "Residence",
      "city": "#13:0"
    }
  ]
}
```

Fetched Example: fetching of all fields except "type"
```javascript
queryResult = orientServer.query('select from Address where city.country.name = \'Italy\'',null,'*:-1 type:0');
```

Return Example 1:
```json
{ "result": [{
      "@rid": "12:0", "@class": "Address",
      "street": "Piazza Navona, 1",
      "city":{
        "@rid": "13:0", "@class": "City",
        "name": "Rome",
        "country":{
          "@rid": "14:0", "@class": "Country",
          "name": "Italy"
        }
      }
    }, {
      "@rid": "12:1", "@version": 1, "@class": "Address",
      "street": "Piazza di Spagna, 111",
      "city":{
        "@rid": "13:0", "@class": "City",
        "name": "Rome",
        "country":{
          "@rid": "14:0", "@class": "Country",
          "name": "Italy"
        }
      }
    }
  ]
}
```

Fetched Example: fetching of all fields except "city" (Class)
```javascript
queryResult = orientServer.query('select from Address where city.country.name = \'Italy\'',null,'*:-1 city:0');
```

Return Example 2:
```json
{ "result": [{
       "@rid": "12:0", "@class": "Address",
       "street": "Piazza Navona, 1",
       "type": "Residence"
     }, {
       "@rid": "12:1", "@version": 1, "@class": "Address",
       "street": "Piazza di Spagna, 111",
       "type": "Residence"
    }
  ]
}
```

Fetched Example: fetching of all fields except "country" of City class
```javascript
queryResult = orientServer.query('select from Address where city.country.name = \'Italy\'',null,'*:-1 City.country:0');
```

Return Example 3:
```json
{ "result": [{
      "@rid": "12:0", "@class": "Address",
      "street": "Piazza Navona, 1",
      "type": "Residence",
      "city":{
          "@rid": "13:0", "@class": "City",
          "name": "Rome"
      }
    }
  ]
}
```

### Execute Command

Method that executes arbitrary commands, it returns command result in text format.

Syntax: <code>&lt;databaseInstance&gt;.executeCommand(&lt;commandText&gt;)</code>

Example 1 (insert):
```javascript
commandResult = orientServer.executeCommand('insert into Address (street,type) values (\'Via test 1\',\'Tipo test\')');
```

Return Example 1 (created record):
```javascript
Address@14:177{street:Via test 1,type:Tipo test}
```

<br/>
Example 2 (delete):
```javascript
commandResult = orientServer.executeCommand('delete from Address where street = \'Via test 1\' and type = \'Tipo test\'');
```

Return Example 2 (records deleted):
```json
{ "value" : 5 }
```

*Note: Delete example works also with update command*

### Load

Method that loads a record from the record ID, it returns the record informations in JSON format.

Syntax: `<databaseInstance>.load(<recordID>, [fetchPlan]);

Simple Example:
```javascript
queryResult = orientServer.load('12:0');
```

Return Example:
```json
{
"@rid": "12:0", "@class": "Address",
      "street": "Piazza Navona, 1",
      "type": "Residence",
      "city": "#13:0"
    }
```

Fetched Example: all fields fetched except "type"
```javascript
queryResult = orientServer.load('12:0', '*:-1 type:0');
```

Return Example 1:
```json
{
"@rid": "12:0", "@class": "Address",
      "street": "Piazza Navona, 1",
      "city":{
         "@rid": "13:0",
         "name": "Rome",
         "country":{
         "@rid": "14:0",
             "name": "Italy"
          }
      }
    }
```

### Class Info

Method that retrieves information of a class, it returns the class informations in JSON format.

Syntax: <code>&lt;databaseInstance&gt;.classInfo(&lt;className&gt;)</code>

Example:
```javascript
addressInfo = orientServer.classInfo('Address');
```

Return Example:
```json
{ "result": [{
      "@rid": "14:0", "@class": "Address",
      "street": "WA 98073-9717",
      "type": "Headquarter",
      "city": "#12:1"
    }, {
      "@rid": "14:1", "@class": "Address",
      "street": "WA 98073-9717",
      "type": "Headquarter",
      "city": "#12:1"
    }
  ]
}
```

### Browse Cluster

Method that retrieves information of a cluster, it returns the class informations in JSON format.

Syntax: <code>&lt;databaseInstance&gt;.browseCluster(&lt;className&gt;)</code>

Example:
```javascript
addressInfo = orientServer.browseCluster('Address');
```

Return Example:
```json
{ "result": [{
      "@rid": "14:0", "@class": "Address",
      "street": "WA 98073-9717",
      "type": "Headquarter",
      "city": "#12:1"
    }, {
      "@rid": "14:1", "@class": "Address",
      "street": "WA 98073-9717",
      "type": "Headquarter",
      "city": "#12:1"
    }
  ]
}
```

### Server Information

Method that retrieves server informations, it returns the server informations in JSON format.

>**Note**: Server information needs the root username and password.  For more information, see [OrientDB Server Security](Server-Security.md). 

Syntax: <code>&lt;databaseInstance&gt;.serverInfo()</code>

Example:
```javascript
serverInfo = orientServer.serverInfo();
```

Return Example:
```json
{
  "connections": [{
    "id": "64",
    "id": "64",
    "remoteAddress": "127.0.0.1:51459",
    "db": "-",
    "user": "-",
    "protocol": "HTTP-DB",
    "totalRequests": "1",
    "commandInfo": "Server status",
    "commandDetail": "-",
    "lastCommandOn": "2010-12-23 12:53:38",
    "lastCommandInfo": "-",
    "lastCommandDetail": "-",
    "lastExecutionTime": "0",
    "totalWorkingTime": "0",
    "connectedOn": "2010-12-23 12:53:38"
    }],
  "dbs": [{
    "db": "demo",
    "user": "admin",
    "open": "open",
    "storage": "OStorageLocal"
    }],
  "storages": [{
    "name": "temp",
    "type": "OStorageMemory",
    "path": "",
    "activeUsers": "0"
    }, {
    "name": "demo",
    "type": "OStorageLocal",
    "path": "/home/molino/Projects/Orient/releases/0.9.25-SNAPSHOT/db/databases/demo",
    "activeUsers": "1"
    }],
    "properties": [
      {"name": "server.cache.staticResources", "value": "false"
      },
      {"name": "log.console.level", "value": "info"
      },
      {"name": "log.file.level", "value": "fine"
      }
    ]
}
```

### Schema

Method that retrieves database Schema, it returns an array of classes (JSON parsed Object).

Syntax: <code>&lt;databaseInstance&gt;.schema()</code>

Example:
```javascript
schemaInfo = orientServer.schema();
```

Return Example:
```json
{"classes": [
    {
      "id": 0,
      "name": "ORole",
      "clusters": [3],
      "defaultCluster": 3, "records": 3,
      "properties": [
        {
        "id": 0,
        "name": "mode",
        "type": "BYTE",
        "mandatory": false,
        "notNull": false,
        "min": null,
        "max": null,
        "indexed": false
      },
        {
        "id": 1,
        "name": "rules",
        "linkedType": "BYTE",
        "type": "EMBEDDEDMAP",
        "mandatory": false,
        "notNull": false,
        "min": null,
        "max": null,
        "indexed": false
      }
  ]},
]
}
```

### getClass()

Return a schema class from the schema.

Syntax: <code>&lt;databaseInstance&gt;.getClass(&lt;className&gt;)</code>

Example:
```javascript
var customerClass = orientServer.getClass('Customer');
```

Return Example:
```json
{
  "id": 0,
  "name": "Customer",
  "clusters": [3],
  "defaultCluster": 3, "records": 3,
  "properties": [
    {
      "id": 0,
      "name": "name",
      "type": "STRING",
    },
    {
      "id": 1,
      "name": "surname",
      "type": "STRING",
    }
  ]
}
```

### Security

#### Roles

Method that retrieves database Security Roles, it returns an array of Roles (JSON parsed Object).

Syntax: <code>&lt;databaseInstance&gt;.securityRoles()</code>

Example:
```javascript
roles = orientServer.securityRoles();
```

Return Example:
```json
{ "roles": [
    {"name": "admin", "mode": "ALLOW_ALL_BUT",
      "rules": []
    },
    {"name": "reader", "mode": "DENY_ALL_BUT",
      "rules": [{
        "name": "database", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.cluster.internal", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.cluster.orole", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.cluster.ouser", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.class.*", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.cluster.*", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.query", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.command", "create": false, "read": true, "update": false, "delete": false
        }, {
        "name": "database.hook.record", "create": false, "read": true, "update": false, "delete": false
        }]
    }
  ]
}
```

#### Users

Method that retrieves database Security Users, it returns an array of Users (JSON parsed Object).

Syntax: <code>&lt;databaseInstance&gt;.securityUsers()</code>

Example:
```javascript
users = orientServer.securityUsers();
```

Return Example:
```json
{ "users": [
    {"name": "admin", "roles": "[admin]"},
    {"name": "reader", "roles": "[reader]"},
    {"name": "writer", "roles": "[writer]"}
  ]
}
```

### close()

Method that disconnects from the server.

Syntax: <code>&lt;databaseInstance&gt;.close()</code>

Example:
```javascript
orientServer.close();
```

### Change server URL

Method that changes server URL in the database instance.<br/>
You'll need to call the [open](#open) method to reconnect to the new server.

Syntax: <code>&lt;databaseInstance&gt;.setDatabaseUrl(&lt;newDatabaseUrl&gt;)</code>

Example:
```javascript
orientServer.setDatabaseUrl('http://localhost:3040')
```

### Change database name

Method that changes database name in the database instance.<br/>
You'll need to call the [open](#open) method to reconnect to the new database.

Syntax: <code>&lt;databaseInstance&gt;.setDatabaseName(&lt;newDatabaseName&gt;)</code>

Example:
```javascript
orientServer.setDatabaseName('demo2');
```

### Setting return type

This API allows you to chose the return type, Javascript Object or JSON plain text. Default return is Javascript Object.

**Important**: the javascript object is not always the evaluation of JSON plain text: for each document (identified by its Record ID) the JSON file contains only one expanded object, all other references are just its Record ID as String, so the API will reconstruct the real structure by re-linking all references to the matching javascript object.

Syntax: <code>orientServer.setEvalResponse(&lt;boolean&gt;)</code>

Examples:
```javascript
orientServer.setEvalResponse(true);
```
Return types will be Javascript Objects.

```javascript
orientServer.setEvalResponse(false);
```
Return types will be JSON plain text.

### Cross-site scripting

To invoke OrientDB cross-site you can use the `query` command in GET and the JSONP protocol. Example:
```xml
<script type="text/javascript" src='http://127.0.0.1:2480/query/database/sql/select+from+XXXX?jsoncallback=var datajson='></script>
```

This will put the result of the query ***<code>select from XXXX&lt;/code&gt;*** into the ***&lt;code&gt;datajson</code>*** variable.

### Errors

In case of errors the error message will be stored inside the database instance, retrievable by getErrorMessage() method.

Syntax: <code>&lt;databaseInstance&gt;.getErrorMessage()</code>

Example:
```javascript
if (orientServer.getErrorMessage() != null){
       //write error message
}
```
