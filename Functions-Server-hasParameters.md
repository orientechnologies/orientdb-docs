---
search:
   keywords: ['functions', 'server', 'request', 'has parameters', 'hasParameters']
---

# Functions - hasParameters()

This method is called from the `request` object.  It returns the number of given parameters found in the HTTP request. 

## Checking Parameters

When developing applications that interact with OrientDB through the HTTP protocol, you may find it useful to check in your function whether certain parameters were sent.  This method takes a series of parameters as arguments, it then counts the number of parameters for which it finds values set in the HTTP request.

### Syntax

```
var count = request.hasParameters(<name>, ...)
```

- **`<name>`** Defines a parameter you want to check the HTTP request for, a string value.  Include as many parameters as you want to check.

#### Return Value

This method returns an integer value indicated the number of the given parameters that it found in the HTTP request.



