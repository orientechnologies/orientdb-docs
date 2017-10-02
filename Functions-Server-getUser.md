---
search:
   keywords: ['functions', 'server', 'request', 'get user', 'getUser']
---

# Functions - getUser()

This function is called from the `request` object.  It returns a string of the requesting user's name.

## Retrieving Users

Functions execute on OrientDB under specific users.  Using this method you can determine which user executes the function.  You may find this useful in logging operations or when building responses for functions that fail due to the user being unprivileged.

### Syntax

```
var username = request.getUser()
```

#### Return Value

This method returns a string that provides the username of the requesting user.
