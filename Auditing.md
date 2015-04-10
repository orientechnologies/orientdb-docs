# Auditing
Starting from OrientDB 2.1, the Auditing component is part of the [Enterprise Edition](http://www.orientechnologies.com/orientdb-enterprise/).

## Configuration
Auditing can be configurable by using the following syntax:

```json
{
  "auditClassName": "<audit-class-name>",
  "classes": {
    "<class-name>" : {
      "polymorphic": true,
      "onCreateEnabled": true, "onCreateMessage": "<message>",
      "onReadEnabled": true, "onReadMessage": "<message>",
      "onUpdateEnabled": true, "onUpdateMessage": "<message>",
      "onDeleteEnabled": true, "onDeleteMessage": "<message>"
    }
  }
}
```

Where:
- `auditClassName`: document class used for auditing records. By default is "AuditingLog"
- `classes`: contains the mapping per class. Wildcard `*` represents any class
- `class-name`: class name to configure
- `polymorphic`: uses this class definition also for all sub classes. By default class definition is polymorphic


Example:
```json
{
  "classes": {
    "V" : {
      "onCreateEnabled": true, "onCreateMessage": "Created vertex of class ${field.@class}",
      "onReadEnabled": true, "onReadMessage": "Read vertex of class ${field.@class}",
      "onUpdateEnabled": true, "onUpdateMessage": "Updated vertex of class ${field.@class}",
      "onDeleteEnabled": true, "onDeleteMessage": "Deleted vertex of class ${field.@class}"
    }
  }
}
```

