---
search:
   keywords: ['functions', 'server', 'response', 'send stream', 'sendStream']
---

# Functions - sendStream()

This method is called from the `response` object.  It sends the HTTP response to your application as a stream.

## Sending HTTP Responses

When developing an application that interacts with OrientDB through functions and the HTTP protocol, eventually you'll need to send the response back to the requesting application.  Using this method, you can trigger OrientDB to issue the response as a stream.

### Syntax

```
var request = response.sendStream(<code>, <reason>, <content-type>, <content>, <size>)
```

- **`<code>`** Defines the HTTP response status code, as an integer.
- **`<reason>`** Defines the HTTP response status reason, as a string.
- **`<content-type>`** Defines the HTTP response content type, as a string.
- **`<content>`** Defines the HTTP response content, as an input stream.
- **`<size>`** Defines the size of the stream, as a long integer.

#### Return Value

This method returns the HTTP request object.
