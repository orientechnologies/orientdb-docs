---
search:
   keywords: ['java', 'ofunction', 'getparameters' ]
---

# OFunction - getParameters()

Retrieves the parameters used by the function.

## Function Parameters

Functions can take parameters and perform various operations based on the specific things you pass to them.  In order to call an parameter from your function code, you need to have the parameters defined for the [`OFunction`](../OFunction.md) instance.  Using this method you can retrieve a list of parameters available to the function.  To set the parameters for the function, see the [`setParameters()`](setParameters.md) method.

### Syntax

```
List<String> OFunction().getParameters()
```

#### Return Type

This method returns a `List` that contains a series of `String` instances.  Each `String` corresponds to a parameter the function expects to receive when it's called, which you can then use in your function code.


