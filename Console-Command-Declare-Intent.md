# Console - DECLARE INTENT

Declares an intent on current database. Intents are a way to tell to OrientDB what you're going to do.

## Syntax

```xml
declare intent <intent-name>
```

Where:

- intent-name  The name of the intent. "null" means remove the current intent. Supported ones are:
- massiveinsert
- massiveread

## Example

```java
> declare intent massiveinsert
```

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
