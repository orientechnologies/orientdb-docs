---
search:
   keywords: ['functions', 'server', 'response', 'get header']
---

# Functions - getHeader()

This method is called from the `response` object.  It sets the additional headers in the response.

## Setting Headers

With server-side functions, you may occasionally want to operate on the HTTP responses your function returns.  Using this method, you can set the response headers.  You may find this useful in situations where you need to log information from the response header or where you want to modify the value the function returns.  To retrieve the response to additional headers, see [`getHeader()`](Functions-Server-getHeader.md).

### Syntax

```
var obj = response.setHeader(<header>)
```

- **`header`** Defines the string value of the header you want to set.

#### Return Value

This method returns the updated request object. 
