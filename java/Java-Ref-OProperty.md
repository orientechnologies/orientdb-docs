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
| [**`getMax()`**](Java-Ref-OProperty-getMax.md) | [`String`]({{ book.javase }}/api/java/lang/String.html) | Retrieves the maximum allowed value |
| [**`setDefaultValue()`**](Java-Ref-OProperty-setDefaultValue.md) | `OProperty` | Defines the default value | 
| [**`setMax()`**](Java-Ref-OProperty-setMax.md) | `OProperty` | Defines the maximum allowed value |
