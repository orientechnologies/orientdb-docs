
# OProperty - getDefaultValue()

This method retrieves the default value for the given property.

## Retrieving Default Values

Normally, when you create a new record and save it to OrientDB, you define the values set on each property.  In cases where values are not set on each property, the undefined properties defaults to `null` values.  While this may be sufficient in most cases, you may at times want to have a default value on some properties.

For instance, imagine a class that records student information for a school.  Since each year the majority of new students are added to a particular class, (that is, the current class of incoming freshmen), you might set and each year update the default class for this property, saving yourself time in the long run.

Using this method, you can retrieve the current default value set on the property.

### Syntax

```
String OProperty().getDefaultValue()
```

#### Return Value

This method returns a [`String`]({{ book.javase }}/api/java/lang/String.html) instance, representing the default value for the property.



