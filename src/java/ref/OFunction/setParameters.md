
# OFunction - setParameters()

Defines the parameters used by the function.

## Function Parameters

Functions can take parameters and perform various operations based on the specific things you pass to them.  In order to call an parameter from your function code, you need to have the parameters defined for the [`OFunction`](../OFunction.md) instance.  Using this method you can define a list of parameters available to the function.  To determine what parameters are available to the function, see the [`getParameters()`](getParameters.md) method.

### Syntax

```
OFunction OFunction().setParameters(List<String> params)
```

| Argument | Type | Description |
|---|---|---|
| **`params`** | `List<String>` | Defines the parameters the function receives when called |

#### Return Type

This method returns the updated [`OFunction`](../OFunction.md) instance, which you may find useful when stringing several operations together.


