---
search:
   keywords: ['functions', 'server', 'response', 'get header']
---

# Functions - getHeader()

This method is called from the `response` object.  It returns a string of the additional response headers.

## Retrieving Headers

With server-side functions, you may occasionally want to operate on the HTTP responses your function returns.  Using this method, you can retrieve the response headers.  You may find this useful in situations where you need to log information from the response header or where you want to modify the value the function returns.  To set the response to additional headers, see [`setHeader()`](Functions-Server-setHeader.md).

### Syntax

```
var header = response.getHeader()
```

#### Return Value

This method returns a string containing the additional headers in the response.
