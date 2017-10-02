---
search:
   keywords: ['functions', 'server', 'request', 'response', 'get http version', 'getHttpVersion']
---

# Function - getHttpVersion()

This method is called from either the `request` or `response` objects.  It returns the HTTP protocol version of the request or response.

## Retrieving HTTP Version

When developing an application that interacts with OrientDB through the HTTP protocol, you may find it useful to check the HTTP version used in requests or responses.  Especially on cases where you're relying on features introduced in more recent versions.

### Syntax

```
var version = request.getHttpVersion()

var version = response.getHttpVersion()
```

#### Return Value

This method returns a string that provides the HTTP protocol version of the request or response.
