
# Auditing
Starting in OrientDB 2.1, the Auditing component is part of the [Enterprise Edition](http://www.orientechnologies.com/orientdb-enterprise/). This page refers to the Auditing feature and how to work with it. The Studio web tool provides a GUI for Auditing that makes configuration easier. Look at the [Auditing page in Studio](../studio/server-management/Studio-Auditing.md).

By default all the auditing logs are saved as documents of class `AuditingLog`. If your account has enough privileges, you can directly query the auditing log. Example on retrieving the last 20 logs: `select from AuditingLog order by @rid desc limit 20`.

**OrientDB 2.2**
Starting in OrientDB 2.2, all auditing logs are now stored in the [system database](../internals/System-Database.md).  The auditing log for each database is stored in a derived class of the `AuditingLog` class with this format: *databaseName*OAuditingLog.

As an example, if you have a database called *MyDB*, then the class name will be `MyDBOAuditingLog`.

Using the previous example to retrieve the last 20 log entries for a specific database, do this from within the system database:
`select from MyDBOAuditingLog order by @rid desc limit 20`

## Security First
For security reasons, no roles should be able to access the `AuditingLog` records. For this reason before using Auditing assure to revoke any privilege on the `AuditingLog` cluster. You can do that from Studio, security panel, or via SQL by using the [SQL REVOKE](../sql/SQL-Revoke.md) command. Here's an example of revoking any access to the writer and reader roles:

```sql
REVOKE ALL ON database.cluster.auditinglog FROM writer
REVOKE ALL ON database.cluster.auditinglog FROM reader
```

**OrientDB 2.2**
This is no longer required starting in 2.2, since all auditing logs are stored in the system database.  No local database user has access to the auditing logs stored in the system database.  To grant access, a [*system user*](../internals/System-Users.md) must be created in the system database with the appropriate role and permissions.

## Polymorphism
OrientDB schema is polymorphic (taken from the Object-Oriented paradigm). This means that if you have the class "Person" and the two classes "Employee" and "Provider" that extend "Person", all the auditing settings on "Person" will be inherited by "Employee" and "Provider" (if the checkbox "polymorphic" is enabled on class "Person"). 

This makes your life easier when you want to profile only certain classes. For example, you could create an abstract class "Profiled" and let all the classes you want to profile extend it. Starting from v2.1, OrientDB supports multiple inheritance, so it's not a problem extending more classes.

## security.json Configuration
There are two parts to enabling and configuring the auditing component.  Starting in OrientDB 2.2, there is a `security.json` configuration file that resides under the `config` folder.  See the [OrientDB Security Configuraton](../security/Security-Config.md) documentation for more details.

The "auditing" section of the `security.json` file must be enabled for auditing to work.

Note the additional "distributed" section of "auditing" for logging distributed node events.

## auditing-config.json Configuration
To configure auditing of a database, create a JSON configuration file with the name `auditing-config.json` under the database folder. This is the syntax for configuration:

```json
{
  "classes": {
    "<class-name>" : {
      "polymorphic": <true|false>,
      "onCreateEnabled": <true|false>, "onCreateMessage": "<message>",
      "onReadEnabled": <true|false>, "onReadMessage": "<message>",
      "onUpdateEnabled": <true|false>, "onUpdateMessage": "<message>",
      "onUpdateChanges": <true|false>,
      "onDeleteEnabled": <true|false>, "onDeleteMessage": "<message>"
    }
  },
  "commands": [
    {
      "regex": "<regexp to match>",
      "message": "<message>"
    }
  ],
  "schema": {
      "onCreateClassEnabled": <true|false>, "onCreateClassMessage": "<message>",
      "onDropClassEnabled": <true|false>, "onDropClassMessage": "<message>"
  }
}
```

### "classes"
Where:
- `classes`: contains the mapping per class. A wildcard `*` represents any class.
- `class-name`: class name to configure.
- `polymorphic`: If `true`, the auditing log also uses this class definition for all sub-classes. By default, the class definition is polymorphic.
- `onCreateEnabled`: If `true`, enables auditing of record creation events. Default is `false`.
- `onCreateMessage`: A custom message stored in the `note` field of the auditing record on create record events. It supports the dynamic binding of values, see "Customizing the Message", below.
- `onReadEnabled`: If `true`, enables auditing of record reading events. Default is `false`.
- `onReadMessage`: A custom message stored in the `note` field of the auditing record on read record events. It supports the dynamic binding of values, see "Customizing the Message", below.
- `onUpdateEnabled`: If `true`, enables auditing of record updating events. Default is `false`.
- `onUpdateMessage`: A custom message stored in the `note` field of the auditing record on update record events. It supports the dynamic binding of values, see "Customizing the Message", below.
- `onUpdateChanges`: If `true`, records all the changed field values in the `changes` property. The default is `true` if `onUpdateEnabled` is true.
- `onDeleteEnabled`: If `true`, enables auditing of delete record events. The default is `false`.
- `onDeleteMessage`: A custom message stored in the `note` field of the auditing record on delete record events. It supports the dynamic binding of values, see "Customizing the Message", below.

#### Customing the Message
- `${field.<field-name>}`, to use the field value. Example: `${field.surname}` to get the field "surname" from the current record in case of CRUD Auditing of classes.

Example to log all the delete operations (`class="*"`), and log all the CRUD operation on any vertex (`class="V" and polymorphic:true`):
```json
{
  "classes": {
    "*" : {
      "onDeleteEnabled": true, "onDeleteMessage": "Deleted record of class ${field.@class}"
    },
    "V" : {
      "polymorphic": true,
      "onCreateEnabled": true, "onCreateMessage": "Created vertex of class ${field.@class}",
      "onReadEnabled": true, "onReadMessage": "Read vertex of class ${field.@class}",
      "onUpdateEnabled": true, "onUpdateMessage": "Updated vertex of class ${field.@class}",
      "onDeleteEnabled": true, "onDeleteMessage": "Deleted vertex of class ${field.@class}"
    }
  }
}
```

### "commands"
Where:
- `regexp`: If a command is executed that matches the regular expression then the command is logged.
- `message`: The optional message that's recorded when the command is logged. It supports the dynamic binding of values, see "Customizing the Message", below.

#### Customizing the Message
- The variable `${command}` will be substituted in the specified message, if command auditing is enabled.

Example:
If you want to get all commands regarding update query, you can use standard Java regular expressions ([see documentation](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html)):
- Regex: ```^update.*```
- Message: ```Following update: ${command} executed.```


under "Command Auditing" section.

### "schema"
Where:
- `onCreateClassEnabled`: If `true`, enables auditing of class creation events. The default is `false`.
- `onCreateClassMessage`: A custom message stored in the `note` field of the auditing record on class creation events. It supports the dynamic binding of values, look at [Customize the message](Auditing.md#customizing-the-message).
- `onDropClassEnabled`: If `true`, enables auditing of class drop events. The default is `false`.
- `onDropClassMessage`: A custom message stored in the `note` field of the auditing record on drop class events. It supports the dynamic binding of values, look at [Customize the message](Auditing.md#customizing-the-message).

#### Customizing the Message
- The variable `${class}` will be substituted in the specified message, if create class or drop class auditing is enabled.


## Log record structure
Auditing Log records have the following structure:

|Field|Type|Description|Values|
|-----|----|-----------|------|
|`date`|DATE|Date of execution|-|
|`user`|LINK|User that executed the command. Can be `null` if internal user has been used|-|
|`operation`|BYTE|Type of operation|0=READ, 1=UPDATE, 2=DELETE, 3=CREATE, 4=COMMAND|
|`record`|LINK|Link to the record subject of the log|-|
|`note`|STRING|Optional message|-|
|`changes`|MAP|Only for UDPATE operation, contains the map of changed fields in the form `{"from":<old-value>, "to":<new-value>}`|-|

**OrientDB 2.2**
Starting in 2.2, the *AuditingLog* class has changed slightly.

|Field|Type|Description|Values|
|-----|----|-----------|------|
|`database`|STRING|The name of the database of the logging event.|-|
|`date`|DATE|Date of execution|-|
|`user`|STRING|The name of the user that executed the command.  This type has changed to a String and now supports system users.|-|
|`operation`|BYTE|Type of operation|0=READ, 1=UPDATE, 2=DELETE, 3=CREATE, 4=COMMAND|
|`record`|LINK|Link to the record subject of the log.|-|
|`note`|STRING|Optional message|-|
|`changes`|MAP|Only for UDPATE operation, contains the map of changed fields in the form `{"from":<old-value>, "to":<new-value>}`|-|
