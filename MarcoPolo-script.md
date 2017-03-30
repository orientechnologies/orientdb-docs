---
search:
   keywords: ['Elixir', 'MarcoPolo', 'script']
---

# MarcoPolo - `script()`

This method executes a script on the database.

>**NOTE**: In order for this to work, you must first enable scripting on OrientDB.  For more information, see [JavaScript](Javascript-COmmand.md).

## Scripting the Database

OrientDB provides support for scripting operations in JavaScript and other languages. This allows you to develop a repository of common operations or to share functions between applications developed in different languages. 

### Syntax

```
script(<conn>, <language>, <script>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<language>`** Defines the language of the script.
- **`<script>`** Defines the script to execute.
- **`<opts>`** Defines additional options for the function.

#### Options

This function only provides on additional option:

- **`:timeout`** Defines the timeout value in milliseconds.  In the event that the script takes longer than the allotted time to finish, MarcoPolo sends an exit signal to the calling process.

#### Return Values

When the script is successful, it returns the tuple `{:ok, record}`, where the variable is the last record the script operates on.  In the event that the operation fails, it returns the tuple `{:error, message}` where the variable is the exception message.

### Example
