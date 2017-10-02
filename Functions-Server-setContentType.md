---
search:
   keywords: ['functions', 'server', 'response', 'set content type', 'setContentType']
---

# Functions - setContentType()

This method is called from the `response` object.  It sets the content type for the HTTP response.

## Setting Content Type

When developing applications that interact with OrientDB through the HTTP protocol, you may find it useful to set the content type in the responses.  This allows you to tell your application how you want it to handle the return content, ensuring that it in turn passes say XML or JSON data to the appropriate parsers.

### Syntax

```
var obj = response.setContentType(<type>)
```

- **`<type>`** Defines the content type you want to set, as a string.

#### Return Value

This method returns the updated response object.
