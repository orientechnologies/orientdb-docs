---
search:
   keywords: ['java', 'ofunctionlibrary', 'ofunction']
---

# OFunctionLibrary

Interface used to store the available [`OFunction`](OFunction.md) instances on a database.

## Function Library

OrientDB SQL supports the use of functions and user-defined functions, which are typically defined in JavaScript using a [`CREATE FUNCTION`](../../sql/SQL-Create-Function.md) statement.  Internally, OrientDB stores functions as a series of [`OFunction`](OFunction.md) instances.  When working in a Java, you can define series of new functions internally from your application code.

You can retrieve the function library from [`ODatabaseSession`](ODatabaseSession.md) or [`ODatabaseDocument`](ODatabaseDocument.md) by first retrieving the metadata with the [`getMetadata()`](ODatabaseDocument/getMetadata.md) method and then retrieving the function library from the metadata with the [`getFunctionLibrary()`](OMetadata/getFunctionLibrary.md) method.  In order to operate on the function library, you also need to import it into your code.

```java
import com.orientechnologies.orient.core.metadata.function.OFunctionLibrary;
```

### Methods

| Method | Return Type | Description |
|---|---|---|
| [**`createFunction()`**](OFunctionLibrary/createFunction.md) | [`OFunction`](OFunction.md)  | Creates a new function |
| [**`dropFunction()`**](OFunctionLibrary/dropFunction.md) | `void` | Removes function |
| [**`getFunction()`**](OFunctionLibrary/getFunction.md) | [`OFunction`](OFunction.md) | Retrieves the given function |
| [**`getFunctionNames()`**](OFunctionLibrary/getFunctionNames.md) | `Set<String>` | Retrieves the logical names for functions in the library |



