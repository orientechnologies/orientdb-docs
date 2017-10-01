---
search:
   keywords: ['functions', 'server', 'request', 'get http method', 'getHttpMethod']
---

# Functions - getHttpMethod()

This method is called from the `request` object.  It returns the HTTP protocol method used by the request.

## Retrieving HTTP Methods

When developing applications that interact with OrientDB through the HTTP protocol, you may find it useful to retrieve the HTTP method from requests.  For instance, the same function might use the request content to run a series of [`SELECT`](SQL-Query.md) statements when set with a `GET` method or use it to run [`UPDATE`](SQL-Update.md) statements in responding to a `POST` method.  Using this method, you can retrieve the HTTP method sent with the request.

### Syntax

```
var method = request.getHttpMethod()
```

#### Return Value

This method returns a string that provides the HTTP method of the request.
