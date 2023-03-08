---
search:
   keywords: ['Java API', 'OClass', 'remove super class', 'removeSuperClass']
---

# OClass - removeSuperClass()

This method removes a superclass from a class.

## Removing Superclasses

OrientDB borrows the concept of a class from the Object Oriented programming paradigm.  This borrowing includes the idea that database classes can inherit from their superclasses.

### Syntax

```
OClass OClass().removeSuperClass(OClass class)
```

| Argument | Type | Description |
|---|---|---|
| **`class`** | [`OClass`](../OClass.md) | Defines the superclass that you want to remove |

#### Return Value

This method returns the updated [`OClass`](../OClass.md) instance.
