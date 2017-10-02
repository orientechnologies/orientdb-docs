---
search:
   keywords: ['functions', 'server', 'response', 'write line', 'writeLine']
---

# Functions - writeLine()

This method is called from the `response` object.  It writes the given text to the end of the content.

## Writing Lines

Using this method you can append lines to the end of the HTTP response content.  You may find it useful when adding content in a loop.

### Syntax

```
var response = response.writeLine(<line>)
```

- **`<line>`** Defines the string you want to add to the content.

#### Return Value

This method returns the HTTP response object.
