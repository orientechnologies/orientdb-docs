---
search:
   keywords: ['Java API', 'OClass', 'class', 'super class', 'addSuperClass']
---

# OClass - addSuperClass()

This method adds a superclass to the database class.

## Adding Superclasses

OrientDB supports polymorphism in database classes.  This means that you can register an [`OClass`](Java-Ref-OClass.md) instance to extend another [`OClass`](Java-Ref-OClass.md) instance.  Using this method, you can assign the given database class as the superclass to this class.

### Syntax

```
OClass ODatabaseDocument().addSuperClass(OClass superClass)
```

| Argument | Type | Description |
|---|---|---|
| **`superClass`** | [`OClass`](Java-Ref-OClass.md) | Defines the superclass |

#### Return Value

This method returns an [`OClass`](Java-Ref-OClass.md) instance.


