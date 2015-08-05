# Auditing
Starting from OrientDB 2.1, the Auditing component is part of the [Enterprise Edition](http://www.orientechnologies.com/orientdb-enterprise/). This page refers to the Auditing feature and how to work with it. Studio web tool provides a GUI on Auditing that makes configuration easier. Look at [Auditing page in Studio](Studio-Auditing.md).

## Configuration
To turn on auditing, create the JSON configuration file with name `auditing-config.json` under the database folder. This is the syntax for configuration:

```json
{
  "auditClassName": "<audit-class-name>",
  "classes": {
    "<class-name>" : {
      "polymorphic": <true|false>,
      "onCreateEnabled": <true|false>, "onCreateMessage": "<message>",
      "onReadEnabled": <true|false>, "onReadMessage": "<message>",
      "onUpdateEnabled": <true|false>, "onUpdateMessage": "<message>", "onUpdateChanges": <true|false>,
      "onDeleteEnabled": <true|false>, "onDeleteMessage": "<message>"
    }
  },
  "commands": {
    {
      "regex": "<regexp to match>",
      "message": "<message>"
    }
  }
}
```

Where:
- `auditClassName`: document class used for auditing records. By default is "**AuditingLog**"
- `classes`: contains the mapping per class. Wildcard `*` represents any class
- `class-name`: class name to configure
- `polymorphic`: uses this class definition also for all sub classes. By default class definition is polymorphic
- `onCreateEnabled`: enable auditing for creation of records. Default is `false`
- `onCreateMessage`: custom message to write in the auditing record on create record. It supports dynamic binding of values, look at [Auditing.md#customize_the_message]
- `onReadEnabled`: enable auditing on reading of records. Default is `false`
- `onReadMessage`: custom message to write in the auditing record on read record. It supports dynamic binding of values, look at [Auditing.md#customize_the_message]
- `onUpdateEnabled`: enable auditing on updating of records. Default is `false`
- `onUpdateMessage`: custom message to write in the auditing record on update record. It supports dynamic binding of values, look at [Auditing.md#customize_the_message]
- `onUpdateChanges`: write all the previous values per field. Default is `true` if `onUpdateEnabled` is true.
- `onDeleteEnabled`: enable auditing on deletion creation of records. Default is `false`
- `onDeleteMessage`: custom message to write in the auditing record on delete record. It supports dynamic binding of values, look at [Auditing.md#customize_the_message]
- `regexp`: is the regular expression to match in order to log the command execution
- `message`: is the optional message to log when the command is logged. It supports dynamic binding of values, look at [Auditing.md#customize_the_message]

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

## Log record structure
Auditing Log records have the following structure:
- `date`, date of execution
- `user`, use that executed the command. Can be `null` if internal user has been used
- `operation`, can be: 0=READ, 1=UPDATE, 2=DELETE, 3=CREATE, 4=COMMAND
- `note`, is the optional message
- `changes`, only for UDPATE operation, contains the map of changed fields in the form `{"from":<old-value>, "to":<new-value>}`




## Customize the message

