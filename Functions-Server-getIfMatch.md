---
search:
   keywords: ['functions', 'server', 'request', 'get if-match', 'getIfMatch']
---

# Functions - getIfMatch()

This method is called from the `request` object.  It returns the `If-Match` value of the HTTP request.


## Retrieving If-Match Values

When developing applications that interact with OrientDB through the HTTP protocol, you may sometimes find it useful to use `If-Match` HTTP requests, such as in cases where you want to use conditions to determine how your function handles the incoming request beyond content type and method.

### Syntax

```
var ifmatch = request.getIfMatch()
```

#### Return Value

This method returns a string containing the `If-Match` value from the HTTP request.
