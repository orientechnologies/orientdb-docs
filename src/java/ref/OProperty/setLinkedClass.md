---
search:
   keywords: ['Java', 'API', 'OProperty', 'OClass', 'setLinkedClass', 'set linked class']
---

# OProperty - setLinkedClass()

Defines the database class linked to this property.

## Setting Linked Classes

Ideally, new properties are created with their corresponding database classes.  For instance, after creating an instance of [`OClass`](../OClass.md) for your database, you would then use the [`createProperty()`](../OClass/createProperty.md) method to instantiate the properties on that class.

In cases where you create the database class and properties separately, you can use this method to link the property to the given class.

### Syntax

```
OProperty OProperty.setLinkedClass(OClass <class>)
```

- **`<class>`** Defines the database class.

### Return Value

This method returns the updated [`OProperty`](../OProperty) instance.
