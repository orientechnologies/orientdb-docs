---
search:
   keywords: ['functions', 'server', 'request', 'get parameter', 'getParameter']
---

# Functions - getParameters)

This method is called from the `request` object.  It returns the value of the given HTTP request parameter.

## Retrieving Parameters

When developing applications that interact with OrientDB through the HTTP protocol, you may want to retrieve parameters from HTTP requests to operate on in your functions.  Using this method, you can retrieve the value of a specific parameter by name.  If you would like to operate on the parameters collectively, use [`getParameters()`](Functions-Server-getParameters.md).  To operate on arguments, use [`getArguments()`](Functions-Server-getArguments.md) or [`getArgument()`](Functions-Server-getArgument.md).

### Syntax

```
var value = request.getParameter(<name>)
```

#### Return Value

This method returns a string value of the given HTTP request parameter.
