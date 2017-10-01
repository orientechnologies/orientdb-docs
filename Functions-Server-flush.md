---
search:
   keywords: ['functions', 'server', 'response', 'flush']
---

# Functions - flush()

This method is called from the `response` object.  It flushes the content to the TCP/IP socket.

## Flushing the Response

When your HTTP response is correctly configured, you can use this method to send it to the TCP/IP socket.

### Syntax

```
var request = response.flush()
```

