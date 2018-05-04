---
search:
   keywords: ['Java API', 'OProperty']
---

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
| [**`getDefaultValue()`**](Java-Ref-OProperty-getDefaultValue.md) | [`String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the default value |
| [**`getLinkedClass()`**](Java-Ref-OProperty-getLinkedClass.md) | [`OClass`](Java-Ref-OClass.md) | Retrieves the linked class in lazy mode |
| [**`getLinkedType()`**](Java-Ref-OProperty-getLinkedType.md) | [`OType`](Java-Ref-OType.md) | Retrieves the linked type |
| [**`getMax()`**](Java-Ref-OProperty-getMax.md) | [`String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the maximum allowed value |
| [**`getMin()`**](Java-Ref-OProperty-getMin.md) | [`String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the minimum allowed value |
| [**`getName()`**](Java-Ref-OProperty-getName.md) | [`String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the property name |
| [**`getType()`**](Java-Ref-OProperty-getType.md) | [`OType`](Java-Ref-OType.md) | Retrieves the property type |
| [**`isMandatory()`**](Java-Ref-OProperty-isMandatory.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the class requires you to set a value on this property | 
| [**`isNotNull()`**](Java-Ref-OProperty-isNotNull.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether the class permits `null` values |
| [**`isReadonly()`**](Java-Ref-OProperty-isReadonly.md) | [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) | Determines whether you can write data to the property |
| [**`setDefaultValue()`**](Java-Ref-OProperty-setDefaultValue.md) | `OProperty` | Defines the default value | 
| [**`setLinkedClass()`**](Java-Ref-OProperty-setLinkedClass.md) | `OProperty` | Defines the linked class |
| [**`setLinkedType()`**](Java-Ref-OProperty-setLinkedType.md) | `OProperty` | Defines the linked type |
| [**`setMax()`**](Java-Ref-OProperty-setMax.md) | `OProperty` | Defines the maximum allowed value |
| [**`setMin()`**](Java-Ref-OProperty-setMin.md) | `OProperty` | Defines the minimum allowed value |
| [**`setName()`**](Java-Ref-OProperty-setName.md) | `OProperty` | Defines the property name |
| [**`setType()`**](Java-Ref-OProperty-setType.md) | `OProperty` | Defines the property type |
