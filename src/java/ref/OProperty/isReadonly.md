
# OProperty - isReadonly()

This method determines whether you can write to the property.

## Checking Constraints

You can enforce a schema on a class by applying constraints to some or all of the properties.  This constraint indicates whether the property allows you to update data.  When it is read only, you can only read data from the property after creating the record.

### Syntax

```
Boolean OProperty().isReadonly()
```

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance, which if `true` indicates that the property is currently set to 'read only'.

