# SQL - CREATE FUNCTION

The **Create Function** command creates a new [Server-Side function](Functions.md). [Functions](Functions.md) can be executed from SQL, HTTP and Java.

## Syntax

```sql
CREATE FUNCTION <name> <code>
                [PARAMETERS [<comma-separated list of parameters' name>]]
                [IDEMPOTENT true|false]
                [LANGUAGE <language>]
```

Where:
- **name** is the function name as string
- **code** is the function code as string
- **PARAMETERS**, optional, are the function parameters bound to the execution heap
- **IDEMPOTENT**, optional, means the function doesn't change the database status. This is useful because IDEMPOTENT functions can be called by HTTP GET, otherwise HTTP POST. By default is FALSE.
- **language**, optional, is the language. By default is "Javascript".

## See also
- [Functions](Functions.md)
- [SQL commands](SQL.md)
- [Console commands](Console-Commands.md)

## Examples

Create function 'test' in Javascript with no parameters:
```sql
CREATE FUNCTION test "print('\nTest!')"
```

Create function 'allUsersButAdmin' in SQL with no parameters:
```sql
CREATE FUNCTION allUsersButAdmin "SELECT FROM ouser WHERE name <> 'admin'" LANGUAGE SQL
```
