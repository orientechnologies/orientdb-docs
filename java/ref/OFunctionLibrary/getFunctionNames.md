---
search:
   keywords: ['java', 'ofunctionlibrary', 'ofunction']
---

# OFunctionLibrary - getFunctionNames()

Retrieves a set of logical names for the functions available in the function library.

## Retrieving Logical Names

OrientDB supports the use of functions and user-defined functions, allowing you to do a little bit more on the database side than the standard OrientDB SQL provides.  These functions are stored internally as a series of [`OFunction`](../OFunction.md) instances, but operated on from the Console using their logical names.  Using this method, you can retrieve the logical names for all functions defined in the function library.

### Syntax

```
Set<String> OFunctionLibrary().getFunctionNames()
```

#### Return Value

This method returns a `Set` instance that contains a series of `String` instances, corresponding to the logical name for each function in the database function library.
