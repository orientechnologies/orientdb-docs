---
search:
   keywords: ['functions', 'server', 'response', 'character set', 'getCharacterSet']
---

# Functions - getCharacterSet()

This method is called from the `response` object.  It returns the character set for the HTTP response.


## Retrieving Character Set

When developing server-side functions for applications that interact with OrientDB through the HTTP protocol, you may find it convenient to retrieve or set the character set value on responses, especially if you are using a non-standard character set.  Using this method, you can retrieve the character set from the response.  To set the character set, see [`setCharacterSet()`](Functions-Server-setCharacterSet.md).

### Syntax

```
var char_set = response.getCharacterSet()
```

#### Return Value

This method returns a string value that provides the HTTP response character set.
