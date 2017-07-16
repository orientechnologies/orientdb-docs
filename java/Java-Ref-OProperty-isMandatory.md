---
search:
   keywords: ['Java API', 'OProperty', 'is mandatory', 'isMandatory']
---

# OProperty - isMandatory()

This method determines whether records allow this property to be null.

## Checking Mandatory

When you want to enforce a schema on your database, setting some or all properties to mandatory forces the class to require values set on them.  Using this method, you can check whether the class requires a value set on the property.

### Syntax

```
boolean OProperty().isMandatory()
```

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance.  If the value is `true`, it indicates that the property is mandatory and requires all records have a value set on it.
