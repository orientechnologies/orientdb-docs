---
search:
   keywords: ['java', 'ofunction', 'setcode']
---

# OFunction - getCode()

Defines the function code. 

## Function Code

Functions refer to stored operations written in JavaScript or OrientDB SQL that you can use on the Console or as part of an SQL operation from another client program.  Using this method, you can set the code that the given function executes when it's called.  To set what language it's written in, see the [`setLanguage()`](setLanguage.md) method.  To retrieve the code from function, see the [`getCode()`](getCode.md) method.

### Syntax

```
OFunction OFunction().setCode(String code)
```

| Argument | Type | Description |
|---|---|---|
| **`code`** | `String` | Defines the code that you want to execute |

#### Return Value

This method returns the updated [`OFunction`](../OFunction.md) instance.  You may find this useful when stringing several operations together.


