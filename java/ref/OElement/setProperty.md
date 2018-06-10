---
search:
   keywords: ['Java API', 'OElement', 'set property', 'setProperty']
---

# OElement - setProperty()

This method sets data on a record property.

## Setting Properties

Data in a record is stored in a set of fields called properties.  Using this method you can add data to a record by its property name.

### Syntax

There are two methods available in setting properties:

```
// METHOD 1
void OElement().setProperty(String name, Object value)

// METHOD 2
void OElement().setProperty(String name, Object value, OType field)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the property name |
| **`value`** | [`Object`]({{ book.javase }}/api/java/lang/Object.html) | Defines the data you want to set on the property |
| **`field`** | [`OType`](Java-Ref-OType.md) | Forced type for the property, (not auto-determined) |
