---
search:
   keywords: ['functions', 'server', 'request', 'get argument', 'getArgument']
---

# Functions - getArgument()

This method is called from the `request` object.  It returns the HTTP request argument for the given position.

## Retrieving Arguments

Rather than passing data to your function through HTTP request content, you can also pass in arguments through the URL.  Using this method you can retrieve a specific argument from the URL determined by its position.  To retrieve all URL arguments, use [`getArguments()`](Functions-Server-getArguments.md). To retrieve HTTP request parameters, see [`getParameter()`](Functions-Server-getParameter.md) and [`getParameters()`](Functions-Server-getParameters.md).

### Syntax

```
var arg = request.getArgument(<position>)
```

- **`<position>`** Defines the position of the argument you want to retrieve.

#### Return Value

This method returns a string of the argument passed to the function through the HTTP request URL.  It determines which argument to return by the given position.  If it doesn't find an argument for the given position, it returns `null`.

