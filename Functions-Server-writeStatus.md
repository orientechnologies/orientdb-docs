---
search:
   keywords: ['functions', 'server', 'response', 'status', 'writeStatus', 'write status']
---

# Functions - writeStatus()

This method is called from the `response` object.  It sets the HTTP response status code and reason.

## Setting HTTP Response Status

In the event that you are developing an application that uses complex HTTP responses from OrientDB to determine how it handles the response content, you can use this method to set the HTTP response status code and reason.

### Syntax

```
var res = response.writeStatus(<code>, <reason>)
```

- **`<code>`** Defines the response status code as an integer value, such as `404` or `200`.
- **`<reason>`** Defines the response status text.

#### Return Value

This method returns the response object.
