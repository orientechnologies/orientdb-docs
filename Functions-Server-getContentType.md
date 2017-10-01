---
search:
   keywords: ['functions', 'server', 'request', 'response', 'get content type', 'getContentType']
---

# Functions - getContentType()

This method is called from both the `request` and `response` objects.  It returns the request or response content types.

## Retrieving Content Types

When developing applications that interact with OrientDB through HTTP, you may find it useful to create a series of server-side functions to manage the incoming data.  Using this function you can determine the content type of the incoming HTTP request or outgoing response.  You can use then use this information, for instance, to determine how to parse the content, ensuring that incoming strings of JSON or XML are sent to the appropriate parsers.

To set the content type in HTTP responses, see [`setContentType()`](Functions-Server-setContentType.md).

### Syntax

```
var content_type = request.getContentType()

var content_type = response.getContentType()
```

#### Return Value

This method returns a string containing the content type of the HTTP request or response.




