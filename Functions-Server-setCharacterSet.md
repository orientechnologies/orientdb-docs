---
search:
   keywords: ['functions', 'server', 'response', 'character set', 'getCharacterSet']
---

# Functions - getCharacterSet()

This method is called from the `response` object.  It sets the character set for the HTTP response.


## Retrieving Character Set

When developing server-side functions for applications that interact with OrientDB through the HTTP protocol, you may find it convenient to retrieve or set the character set value on responses, especially if you are using a non-standard character set.  Using this method, you can set the character set for the response.  To retrieve the character set, see [`getCharacterSet()`](Functions-Server-getCharacterSet.md).

### Syntax

```
var res = response.setCharacterSet(<character-set>)
```

- **`<character-set>`** Defines the character set for the HTTP response, a string value.

#### Return Value

This method returns the updated response object.

