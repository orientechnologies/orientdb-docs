# SQL - `CREATE FUNCTION`

Creates a new Server-side function.  You can execute [Functions](Functions.md) from SQL, HTTP and Java.


**Syntax**

```sql
CREATE FUNCTION <name> <code>
                [PARAMETERS [<comma-separated list of parameters' name>]]
                [IDEMPOTENT true|false]
                [LANGUAGE <language>]
```

- **`<name>`** Defines the function name.
- **`<code>`** Defines the function code.
- **`PARAMETERS`** Defines a comma-separated list of parameters bound to the execution heap.
- **`IDEMPOTENT`** Defines whether the function can change the database status.  This is useful given that HTTP GET can call `IDEMPOTENT` functions, while others are called by HTTP POST.  By default, it is set to `FALSE`.
- **`LANGUAGE`** Defines the language to use.  By default, it is set to JavaScript.

**Examples**

- Create a function `test()` in JavaScript, which takes no parameters:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE FUNCTION test "print('\nTest!')"</code>
  </pre>

- Create a function `allUsersButAdmin` in SQL, which takes with no parameters:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE FUNCTION allUsersButAdmin "SELECT FROM ouser WHERE name <> 
            'admin'" LANGUAGE SQL</code>
  </pre>


>For more information, see
>
>- [Functions](Functions.md)
>- [SQL Commands](SQL.md)
>- [Console Commands](Console-Commands.md)
