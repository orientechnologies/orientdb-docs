---
search:
   keywords: ['Java API', 'OProperty', 'default value', 'get default value', 'getDefaultValue']
---

# OProperty - getDefaultValue()

This method sets the default value for the given property.

## Retrieving Default Values

Normally, when you create a new record and save it to OrientDB, you define the values set on each property.  In cases where values are not set on each property, the undefined properties defaults to `null` values.  While this may be sufficient in most cases, you may at times want to have a default value on some properties.

For instance, imagine a class that records student information for a school.  Since each year the majority of new students are added to a particular class, (that is, the current class of incoming freshmen), you might set and each year update the default class for this property, saving yourself time in the long run.

Using this method, you can define the default value for the property.

### Syntax

```
OProperty OProperty().setDefaultValue(String value)
```

| Argument | Type | Description |
|---|---|---|
| **`value`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the value to set |

#### Return Value

This method returns the updated [`OProperty`](Java-Ref-OProperty.md) instance.



