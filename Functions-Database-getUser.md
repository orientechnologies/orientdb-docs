---
search:
   keywords: ['functions', 'database', 'get user', 'getUser']
---

# Functions - getUser()

This method retrieves the current user.

## Retrieving Users

When you operate on the database you access it through a particular database users.  With this method, you can retrieve the current user from within the function.  You may find it useful in logging or when you need the function to operate on a particular user.

### Syntax

```
var user = db.getUser()
```


