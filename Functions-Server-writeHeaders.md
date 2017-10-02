---
search:
   keywords: ['functions', 'server', 'response', 'write headers', 'writeHeaders']
---

# Functions - writeHeaders()

This method is called from the `response` object.  It sets the content type for the HTTP response.

## Writing Headers

Similar to [`setContentType()`](Functions-Server-setContentType.md), this method allows you to set the content type for the HTTP response.  This allows you to have OrientDB tell your application how it should prase the response content.  Also, allows you to enable the keep-alive.

### Syntax

```
var response = response.writeHeaders(<type>, <keep-alive>)
```

- **`<type>`** Defines the content type for the HTTP response.  Set as a string variable.
- **`<keep-alive>`** Defines whether you want to use the keep-alive.  Set as a boolean value.  Defaults to `false`.

#### Return Value

This method returns the response object.
