---
search:
   keywords: ['java', 'ofunction', 'setlanguage']
---

# OFunction - setLanguage()

Defines the language that the function uses.

## Function Language

Functions aren't just collections of OrientDB SQL statements.  They can also be written in JavaScript, which you may find more convenient for complex operations.  When not explicitly set, [`OFunction`](../OFunction.md) defaults to JavaScript.  Using this method, you can set the language that the function uses when it executes its code.  To determine what language the function uses, see the [`getLanguage()`](getLanguage.md) method.


### Syntax

```
OFunction OFunction().setLanguage(String lang)
```

| Argument | Type | Description |
|---|---|---|
| **`lang`** | `String` | Defines the language you want to use. |

#### Return Type

This method returns the updated [`OFunction`](../OFunction.md) instance, which you may find useful when stringing several operations together.


