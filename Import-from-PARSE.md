# Import from Parse

[Parse](https://parse.com/) is a very popular BaaS (Backend as a Service), acquired by Facebook. Parse uses MongoDB as database and allows to export the database in JSON format. The format is an array of JSON object. Example:

```json
[
    {
        "user": {
            "__type": "Pointer",
            "className": "_User",
            "objectId": "Ldlskf4mfS"
        },
        "address": {
            "__type": "Pointer",
            "className": "Address",
            "objectId": "lvkDfj4dmS"
        },
        "createdAt": "2013-11-15T18:15:59.336Z",
        "updatedAt": "2014-02-27T23:47:00.440Z",
        "objectId": "Ldk39fDkcj",
        "ACL": {
            "Lfo33mfDkf": {
                "write": true
            },
            "*": {
                "read": true
            }
        }
    }, {
        "user": {
            "__type": "Pointer",
            "className": "_User",
            "objectId": "Lflfem3mFe"
        },
        "address": {
            "__type": "Pointer",
            "className": "Address",
            "objectId": "Ldldjfj3dd"
        },
        "createdAt": "2014-01-01T18:04:02.321Z",
        "updatedAt": "2014-01-23T20:12:23.948Z",
        "objectId": "fkfj49fjFFN",
        "ACL": {
            "dlfnDJckss": {
                "write": true
            },
            "*": {
                "read": true
            }
        }
    }
]
```

Notes:
- Each object has own `objectId` that identifies the object in the entire database.
- Parse has the concept of `class`, like OrientDB
- Links are similar to OrientDB RID (but it requires a costly JOIN to be traversed), but made if an embedded object containing:
 - `className` as target class name
 - `objectIf` as target objectId
- Parse has ACL at record level, like [OrientDB](http://www.orientechnologies.com/docs/last/orientdb.wiki/Security.html#record-level-security).

In order to import a PARSE file, you need to create the ETL configuration using JSON as Extractor.

## Example
In this example we're going to import the file extracted from Parse containing all the records of `user` class. Note the creation of class `User` in OrientDB that extends `V` (Base Vertex class). We created an index against property `User.objectId` to use the same ID as for Parse. If you execute this ETL importing multiple time, the record in OrientDB will be updated thanks to the `merge`.

```json
{
  "config": {
    "log": "debug"
  },
  "source" : {
    "file": { "path": "/temp/parse-user.json", "lock" : true }
  },
  "extractor" : {
    "json": {}
  },
  "transformers" : [
   { "merge": { "joinFieldName":"objectId", "lookup":"User.objectId" } },
   { "vertex": { "class": "User"} }
  ],
  "loader" : {
    "orientdb": {
      "dbURL": "plocal:/temp/databases/parse",
      "dbUser": "admin",
      "dbPassword": "admin",
      "dbAutoCreate": true,
      "tx": false,
      "batchCommit": 1000,
      "dbType": "graph",
      "classes": [
        {"name": "User", "extends": "V"}
      ],      
      "indexes": [
        {"class":"User", "fields":["objectId:string"], "type":"UNIQUE_HASH_INDEX" }
      ]
    }
  }
}

```

Look also at - [Import from JSON](Import-from-JSON.md).
