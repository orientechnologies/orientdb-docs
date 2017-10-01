---
search:
   keywords: ['functions', 'server', 'request', 'get parameters', 'getParameters']
---

# Functions - getParameters()

This method is called from the `request` object.  It returns the HTTP request parameters.

## Retrieving Parameters

When developing applications that interact with OrientDB through the HTTP protocol, you may want to retrieve parameters from HTTP requests to operate on in your functions.  Using this method, you can retrieve all the parameters sent in the request.  If you would like to operate on a specific parameter by name, use [`getParameter()`](Functions-Server-getParameter.md).  To operate on arguments, use [`getArguments()`](Functions-Server-getArguments.md) or [`getArgument()`](Functions-Server-getArgument.md).

### Syntax

```
var params = request.getParameters()
```

#### Return Value

This method returns a string of the HTTP request parameters.
