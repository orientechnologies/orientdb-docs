---
search:
   keywords: ['Java API', 'OServer', 'get user', 'getUser']
---

# Java API - `OServer().getUser()`

This method retrieves user configuration from the OrientDB Server.

## Retrieving Users

In the event that you need to operate on a server user from within your application, this method allows you to retrieve the server user configuration.  This is an instance of the `OServerUserConfiguration` class, which you can then read or modify from within your application.

### Syntax

```
public OServerUserConfiguration OServer().getUser(String name)
```

| Argument | Type | Description
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the user name |


