---
search:
   keywords: ['Java API', 'OServer', 'save configuration', 'saveConfiguration']
---

# OServer - saveConfiguration()

This method saves the current server configuration to disk.

## Saving Configuration

Occasionally, you may want to operate on the OrientDB Server configuration from within your application.  When you modify the configuration, those changes remain volatile until you save them using this method.

### Syntax

```
public void OServer().saveConfiguration()
```

#### Exceptions

This method throws the following exception:

- [`IOException`]({{ book.javase }}/api/java/io/IOException.html)


