---
search:
   keywords: ['Java API', 'OProperty', 'property', 'is not null', 'isNotNull']
---

# OProperty - isNotNull()

This method determines whether a property permits `null` values.

## Checking Constraints

Properties can enforce a schema on the records you save to OrientDB.  This constraint defines whether the class allows `null` values for this property.  Using this method, you can determine whether the constraint has been configured for the property.

### Syntax

```
Boolean OProperty().isNotNull()
```

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance, which if `true` indicates that the property allows `null` values.
