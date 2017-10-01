---
search:
   keywords: ['function', 'server', 'url', 'get url', 'getURL']
---

# Functions - getURL()

This function is called from the `request` object.  It returns the URL of the HTTP request.

## Retrieving URL's

When developing applications that interact with OrientDB through HTTP, you may find it useful to retrieve the URL of the HTTP request, either for logging purposes or to control what further operations the function calls.

### Syntax

```
var url = request.getURL()
```

#### Return Value

This method returns a string of the URL in the HTTP request.
