---
search:
   keywords: ['functions', 'server', 'request', 'is multipart', 'isMultipart']
---

# Functions - isMultipart()

This method is called from the `request` object.  It determines whether or not an HTTP request is multi-part.

## Multi-part HTTP Requests 

In developing applications that interact with OrientDB through the HTTP protocol, you may find it useful to check whether the incoming request in multi-part.  If your applications sometimes sends multi-part requests, you may find it useful to check, ensuring that you handle the incoming data appropriately.

### Syntax

```
var isMulti = request.isMultiaprt()
```

#### Return Value

This method returns a boolean value, where a value of `true` indicates that the HTTP request is multi-part.
