
# Java API - OProperty

This class provides a standard interface for handling properties on database classes.

## Managing Properties

Where database classes allow you to organize records on your database, properties organize the data you store on the records.  You can manage this through an enforced schema, allowing you to apply constraints to the property.  You can also manage it through an implied schema, where you decide at the application level to use certain properties to store certain information on the record.

Each property you create on a class initializes an `OProperty` instance on OrientDB. You can then retrieve these instances to retrieve information or operate on them further. 

This class is available at `com.orientechnologies.orient.core.metadata.schema`.

```java
import com.orientechnologies.orient.core.metadata.schema.OProperty;
```

## Methods

| Method | Return Type | Description |
|---|---|---|
| [**`getDefaultValue()`**](OProperty/getDefaultValue.md) | [`String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the default value |
| [**`getLinkedClass()`**](OProperty/getLinkedClass.md) | [`OClass`](OClass.md) | Retrieves the linked class in lazy mode |
| [**`getLinkedType()`**](OProperty/getLinkedType.md) | [`OType`](OType.md) | Retrieves the linked type |
| [**`getMax()`**](OProperty/getMax.md) | [`String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the maximum allowed value |
| [**`getMin()`**](OProperty/getMin.md) | [`String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the minimum allowed value |
| [**`getName()`**](OProperty/getName.md) | [`String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the property name |
| [**`getType()`**](OProperty/getType.md) | [`OType`](OType.md) | Retrieves the property type |
| [**`isMandatory()`**](OProperty/isMandatory.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the class requires you to set a value on this property | 
| [**`isNotNull()`**](OProperty/isNotNull.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the class permits `null` values |
| [**`isReadonly()`**](OProperty/isReadonly.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether you can write data to the property |
| [**`setDefaultValue()`**](OProperty/setDefaultValue.md) | `OProperty` | Defines the default value | 
| [**`setLinkedClass()`**](OProperty/setLinkedClass.md) | `OProperty` | Defines the linked class |
| [**`setLinkedType()`**](OProperty/setLinkedType.md) | `OProperty` | Defines the linked type |
| [**`setMax()`**](OProperty/setMax.md) | `OProperty` | Defines the maximum allowed value |
| [**`setMin()`**](OProperty/setMin.md) | `OProperty` | Defines the minimum allowed value |
| [**`setName()`**](OProperty/setName.md) | `OProperty` | Defines the property name |
| [**`setType()`**](OProperty/setType.md) | `OProperty` | Defines the property type |
