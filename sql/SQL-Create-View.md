---
search:
   keywords: ['SQL', 'command', 'create', 'view', 'CREATE VIEW']
---

# SQL - `CREATE VIEW`

Creates a new materialized view in the schema.

**Syntax**

```sql
CREATE VIEW <viewName> 
FROM (<query>) 
[ 
   METADATA {
     [updateIntervalSeconds: <number> ],
     [watchClasses: ["className1", "classNameN"] ] 
     [nodes: ["nodeName1", "nodeNameN"] ],
     [indexes: [
        {
           type:"indexType", 
           [engine:"indexEngineName"], 
           properties: {propertyName1:"propertyType1", propertyNameN:"propertyTypeN"}
        }*
      ]
     ]
     [
        updatable: (true | false), 
        originRidField: "fieldName"
     ],
     

   } 
]
```

- **`<viewName>`**: Defines the name of the view you want to create.  You must use a letter, underscore or dollar for the first character, for all other characters you can use alphanumeric characters, underscores and dollar.
- **`<query>`**: A SQL query whose results will be stored as the view content.
- **`updateIntervalSeconds`**: by default, a view content is updated at fixed intervals, re-executing the query. 
You can change this interval, setting this parameter
- **`watchClasses`**: by default, a view is updated at fixed intervals, regardless of the fact that the original data changed or not. 
By setting `watchClasses`, you give OrientDB some information to avoid that the view is updated when there is no need for that: if you
set this parameter, the view is updated only when one or more records in the watched classes are inserted/updated/deleted, otherwise the 
view is not refreshed.
- **`nodes`**: in a distributed configuration, by default, the view is deployed on all the nodes. Setting the `nodes` attributes you can specify
in which nodes you want the view to be populated (in the other nodes the view will still be present, but it will be empty).
- **`indexes`**: you can define one or more indexes on a view, they will be used to optimize queries. `type` is the index type, eg. "NOTUNIQUE" or 
"FULLTEXT"; `engine` (optional) is the index engine to be used (eg. "LUCENE"); `properties` is the set of properties (name:type, eg. `surname:"STRING"`) to be indexed, they have to 
be defined in the exact order you want them to appear in the index definition. 
- **`updatable` and `originRidField`**: By default, a view is a read-only object, that means that you cannot manually change its content directly.
You can configure a view to be updatable, so that you can change its content manually (updating records) and the changes are reflected to the original
records. `originRidField` is a field in the view that will contain the RID of the document that is the origin of a single entry in the view.
Updatable views cannot be created from aggregate queries.

**Examples**

- create the view `Manager`: suppose you have a class called Employee, with a boolean property `isManager` that defines whether the
employee is a manager or not

```SQL
CREATE VIEW Manager FROM (SELECT FROM Employee WHERE isManager = true)
```

- create a view that is updated only every two hours

```SQL
CREATE VIEW Manager FROM (SELECT FROM Employee WHERE isManager = true) METADATA {updateIntervalSeconds:2*60*60}
```

