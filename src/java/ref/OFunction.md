
# OFunction

Interface that controls a database function, which you can in turn use in OrientDB SQL on the database or within your applications.

## Using Functions

Functions in OrientDB are stored operations that you can call from the Console or through any of the database driver methods that use OrientDB SQL.  OrientDB provides a number of functions by default and the user can define a series of additional functions as need.  They are stored in the database as a series of `OFunction` instances accessible through [`OMetadata`](OMetadata.md) and the [`OFunctionLibrary`](OFunctionLibrary.md).

In order to work with functions from your application, you first need to import the class into your code.

```java
import com.orientechnologies.orient.core.metadata.function.OFunction;
```

### Methods

Each function supports the following methods.


| Method | Return Type | Description |
|---|---|---|
| [**`getCode()`**](OFunction/getCode.md) | `String` | Retrieves the function code |
| [**`getId()`**](OFunction/getId.md) | [`ORID`](ORID.md)  | Retrieves the function Record ID |
| [**`getLanguage()`**](OFunction/getLanguage.md) | `String` | Retrieves the name of the scripting language the function uses |
| [**`getName()`**](OFunction/getName.md) | `String` | Retrieves the logical name of the function |
| [**`getParameters()`**](OFunction/getParameters.md) | `List<String>` | Retrieves the parameters available for use in the function code |
| [**`isIdempotent()`**](OFunction/isIdempotent.md) | `boolean` | Determines whether the function performs idempotent queries or executes non-idempotent commands |
| [**`setCode()`**](OFunction/setCode.md) | `OFunction` | Defines the function code |
| [**`setIdempotent()`**](OFunction/setIdempotent.md) | `OFunction` | Defines whether the function is idempotent or non-idempotent |
| [**`setLanguage()`**](OFunction/setLanguage.md) | `OFunction` | Defines the scripting language the function uses |
| [**`setName()`**](OFunction/setName.md) | `OFunction` | Defines the logical name of the function |
| [**`setParameeters()`**](OFunction/setParameters.md) | `OFunction` | Defines the parameters available to the function code |

