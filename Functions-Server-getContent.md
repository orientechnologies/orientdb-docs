---
search:
   keywords: ['functions', 'server', 'response', 'request', 'get content', 'getContent']
---

# Functions - getContent()

This method can be called from the `request` object. It retrieves the content of the request.

## Retrieving Content

In developing server-side functions, you may occasionally encounter situations where you need to operate on the content of an HTTP request.  Using this method, you can retrieve the content as a string into your function.

### Syntax

```
var content = request.getContent()
```

#### Return Value

This method returns a string of the request content.
