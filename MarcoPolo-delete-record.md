---
search:
   keywords: ['Elixir', 'MarcoPolo', 'delete record', 'delete_record']
---

# MarcoPolo - `delete_record()`

This method removes a record from the database, identified by its Record ID.

## Removing Records

Occasionally, you may find you need to remove records from the database and have to decide which from within your Elixir application.  This function allows you to do so, removing records by their Record ID's.

### Syntax

```
delete_record(<conn>, <record-id>, <version>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<record-id>`** Defines the Record ID, as an [`RID`](MarcoPolo-RID.md) instance.
- **`<version>`** Defines the record version.
- **`<opts>`** Defines additional options for the function.  For more information, see the [Options](#options) section below.

#### Options

This functin provides two additional options:

- **`:no_response`** Defeines whether you want your application to wait for a response from OrientDB.  When set to `true`, it returns `:ok` on every operation, regardless of whether it's successful.

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the query takes longer than the alloted time, MarcoPolo sends an exit signal to the calling process.

#### Return Values

When this operation is successful, the function returns the tuple `{:ok, passed}`, where the `passed` variable is a boolean value indicating whether the record was successfully deleted.  In the event that the operation fails, it returns the tuple `{:error, message}`, where the variable contains the exception message.


### Example
