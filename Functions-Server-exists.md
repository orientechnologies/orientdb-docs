---
search:
   keywords: ['functions', 'server', 'util', 'exists']
---

# Functions - exists()

This method is called from the `util` object.  It returns `true` if the given variable has been defined.

## Checking Variables

When developing an application that interacts with OrientDB through functions and the HTTP protocol, you may find this useful in cases where the application does not always define values passed into the function.  Using this method, you can check whether the given variable is defined. 

### Syntax

```
var isDefined = util.exists(<variable>)
```

- **`<variable>`** Defines the variable you want to check.

#### Return Value

This method returns a boolean value.  A value of `true` indicates that the variable is defined.  A value of `false` indicates that the variable is `null` or `undefined`.
