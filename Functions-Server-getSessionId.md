---
search:
   keywords: ['functions', 'server', 'request', 'session id', 'getSessionId']
---

# Functions - getSessionId()

This method is called by the `request` object.  It returns the Session ID of the session executing the function.

## Retrieving Session ID's

Using this method you can retrieve the current Session ID into your function.

### Syntax

```
var id = request.getSessionId()
```

#### Return Value

This method returns a string containing the current Session ID.
