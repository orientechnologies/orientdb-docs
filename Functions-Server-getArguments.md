---
search:
   keywords: ['functions', 'server', 'request', 'get arguments', 'getArguments']
---

# Functions - getArguments()

This method is called from the `request` object.  It returns the HTTP request arguments in REST form.

## Retrieving Arguments

Rather than passing data to your function through HTTP request content, you can also pass in arguments through the URL.  Using this method you can retrieve the URL arguments into an array for further operations.  To retrieve specific arguments by position, use [`getArgument()`](Functions-Server-getArgument.md).  To retrieve HTTP request parameters, see [`getParameter()`](Functions-Server-getParameter.md) and [`getParameters()`](Functions-Server-getParameters.md).

### Syntax

```
var args = request.getArguments()
```

#### Return Value

This method returns an array of strings that contain each argument passed to the function through the HTTP request.

