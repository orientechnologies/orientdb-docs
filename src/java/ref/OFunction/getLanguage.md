
# OFunction - getLanguage()

Retrieves the language that the function uses.

## Function Language

Functions aren't just collections of OrientDB SQL statements.  They can also be written in JavaScript, which you may find more convenient for complex operations.  Using this method, you can retrieve the language that the function uses when it executes its code.  To set the language for the function, see the [`setLanguage()`](setLanguage.md) method.


### Syntax

```
String OFunction().getLanguage()
```

#### Return Type

This method returns a `String` instance, which contains the language that the function uses when it executes code.


