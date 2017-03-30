---
search:
   keywords: ['Elixir', 'MarcoPolo', 'update record', 'update_record']
---

# MarcoPolo - `update_record()`

This function updates a record on the database.

## Updatating Records

When you're finished making changes to records loaded into your Elixir application, this function allows you to use the new data to update existing records on the database.


### Syntax

```
update_record(<conn>, <record-id>, <version>, 
              <data>, <update-content>, <opts>)
```


- **`<conn>`** Defines the database connection.
- **`<record-id>`** Defines the Record ID.
- **`<version>`** Defines the record version.
- **`<data>`** Defines the data you want to add.
- **`<update-content>`** Defines whether you want to update the content.
- **`<opts>`** Defines additional options for the function.  For more information on the available options, see the [Options](#options) section below.

#### Options

This function supports two additional options:

- **`:no_response`** Defines whether you want your application to wait for a response from OrientDB.  When set to `true`, it sends the update and returns `:ok` regardless of whether the operation was successful.
- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the update takes longer than the allotted time, MarcoPolo sends an exit signal to the calling process.

#### Return Values

When the operation is successful, the function returns the tuple `{:ok, version}`, where the variable is a non-negative integer indicating the updated version number on the record.  In the event that the operation fails, it returns the tuple `{:error, message}`, where the variable is the exception message.


### Example
