---
search:
   keywords: ['Java API', 'OClass', 'property', 'property exists', 'exists property', 'existsProperty']
---

# OClass - existsProperty()

This method determines whether the given property exists on the class.

## Checking Properties

In cases where your application operates on a database it didn't configure or when you suspect other clients or users might have modified the class schema, you may want to check that a given property exists before initiating an operation.  This method checks whether the given property name exists.  You can then use its return to decide whether or not you want to proceed.

### Syntax

```
boolean OClass().existsProperty(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the property name |

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) result.  The return value is `true` when the given property name exists on the class.
