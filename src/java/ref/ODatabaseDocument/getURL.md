---
search:
   keywords: ['java', 'odatabasedocument', 'geturl']
---

# ODatabaseDocument - getURL()

Retrieves the database URL.

## Database URL

Each database in OrientDB has a URL that corresponds to the path needed to access it.  Database URL's are relative to the OrientDB home directory.  For instance, `plocal:../databases/GratefulDeadConcerts`.  Using this method you can retrieve the URL of the current database instance.

### Syntax

```
String ODatabaseDocument().getURL()
```

#### Return Value

This method returns a `String` value, which corresponds to the URL of the current database.
