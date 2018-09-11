---
search:
   keywords: ['java', 'ometadata', 'getfunctionlibrary', 'functionlibrary']
---

# OMetadata - getFunctionLibrary()

Retrieves the function library from the database metadata.

## OrientDB Functions

OrientDB SQL supports the use of functions and of user-defined functions.  These are represented internally as [`OFunction`](../OFunction.md) instances.  They are stored at the database level in the function library, that is the [`OFunctionLibrary`](../OFunctionLibrary.md).  Using this method you can retrieve the function library from the database metadata, allowing you to operate on the available database functions or add new functions for your application to use.

### Syntax

```
OFunctionLibrary OMetadata().getFunctionLibrary()
```

#### Return Type

This method returns an [`OFunctionLibrary`](../OFunctionLibrary.md) instance, which contains the database functions.


