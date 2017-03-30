---
search:
   keywords: []
---

# MarcoPolo - `drop_db()`

This function removes the given database from the server.

## Removing Databases

Occasionally, you may find yourself in situations where you need to remove an entire database from the server.  For instance, in cases where your application requires volatile in-memory databases for short-term use.  Using this function, you can remove a database from the server.

### Syntax

```
drop_db(<conn>, <database>, <storage-type>, <opts>)
```

- **`<conn>`** Defines the server connection.
- **`<database>`** Defines the database name.
- **`<storage-type>`** Defines the database storage-type.  Supported storage-types include,
  - *`:plocal`* Sets it to the PLocal storage-type.
  - *`:memory`* Sets it to the Memory storage-type.
- **`<opts>`** Defines additional options.  For more information on the available options, see the [Options](#options) section below.

#### Options

This function supports one additional option:

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the operation takes longer than the allotted time, MarcoPolo sends an exit signal to the calling process.

#### Return Values

When the operatin is successful, this function returns `:ok`.  In the event that it encounters an error, instead it returns the tuple `{:error, message}`, where the variable is the exception message.

### Example

Consider the use case of an application that operates with multiple databases in-memory.  These databases are ad hoc, brought online to address short term needs and then removed when the job is complete. 

