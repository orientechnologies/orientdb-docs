---
search:
   keywords: ['Java', 'API', 'OProperty', 'getLinkedClass', 'get linked class']
---

# OProperty - getLinkedClass()

Retrieves the class linked to the property.

## Retrieving Linked Classes

Properties are generally created as fields in a database class, (that is, an [`OClass`](Java-Ref-OClass.md) instance).  Using this method, you can retrieve the database class to which the given [`OProperty`](Java-Ref-OProperty.md) instance is linked.

OrientDB retrieves this class in lazy mode, because while unmarshalling, the class could not be loaded.

### Syntax

```
OClass OProperty.getLinkedClass()
```

#### Return Value

This method returns the [`OClass`](Java-Ref-OClass.md) instance linked to the property.
