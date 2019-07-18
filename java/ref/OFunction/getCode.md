---
search:
   keywords: ['java', 'ofunction', 'getcode']
---

# OFunction - getCode()

Retrieves the function code. 

## Function Code

Functions refer to stored operations written in JavaScript or OrientDB SQL that you can use on the Console or as part of an SQL operation from another client program.  Using this method, you can retrieve the code that the given function executes when it's called.  To check what language it's written in, see the [`getLanguage()`](getLanguage.md) method.  To set the code that the function executes, see the [`setCode()`](setCode.md) method.

### Syntax

```
String OFunction().getCode()
```

#### Return Value

This method returns a `String` instance, which contains the JavaScript or OrientDB SQL code that the function executes when called.


