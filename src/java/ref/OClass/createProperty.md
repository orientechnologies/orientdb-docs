---
search:
   keywords: ['Java API', 'OClass', 'OProperty', 'create property', 'createProperty']
---

# OClass - createProperty()

This method creates a property on the class.

## Creating Properties

Classes in OrientDB can feature fields that contain particular types of data.  In the comparison to Relational databases, if the class is the table, the properties are the columns in the table.  Using this method, you can create new properties on the class, naming it and typing its contents.

### Syntax

```
// METHOD 1
OProperty OClass().createProperty(
	String name, 
	OType type)

// METHOD 2
OProperty OClass().createProperty(
	String name, 
	OType type,
	OClass linkedClass)

// METHOD 3
OProperty OClass().createProperty(
	String name, 
	OType type,
	OType linkedType)

// METHOD 4
OProperty OClass().createProperty(
	String name, 
	OType type,
	OType linkedType, 
	Boolean isUnsafe)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the property name |
| **`type`** | [`OType`](../OType.md) | Defines the property type |
| **`linkedClass`** | [`OClass`](../OClass.md) | Defines the class to link to, for use with properties of the type `LINK`, `LINKLIST`, `LINKSET`, `LINMAP`, `EMBEDDED`, `EMBEDDEDLIST`.  You can further spcify the type for embedded classes. |
| **`linkedType`** | [`OType`](../OType.md) | Defines the linked type, for use with properties of the types: `EMBEDDEDLIST`, `EMBEDDEDSET` or `EMBEDDEDMAP`.  Set this argument to `null` for all other cases. |
| **`isUnsafe`** | Defines whether it should check the persistent data for compatibility.  Only use if all persistent data is compatible with the property. |

#### Return Value

This method returns the created property as an [`OProperty`](../OProperty.md) instance.

