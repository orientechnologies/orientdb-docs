
# OElement - getPropertyNames()

This method returns the property names set for the given record.

## Retrieving Property Names

In cases where you have a record and don't know what properties it provides, this method allows you retrieve a set of strings containing the property names.  You can then use [`getProperty()`](getProperty.md) to retrieve the data you want.

### Syntax

```
Set<String> OElement().getPropertyNames()
```

#### Return Value

This method returns a [`Set`]({{ book.javase }}/api/java/util/Set.html) containing [`String`]({{ book.javase }}/api/java/lang/String.html) instances of each property name defined in the record.


### Example

Imagine an application in which you sometimes retrieve records with inconsistent data.  In the event of an error, you might want a method that reports the properties and contents for a record to use when debugging issues.

```java
public void errorReadingRecord(OElement record){

   // Fetch Properties
   Set<String> names = record.getPropertyNames();

   // Report Error
   logger.warn(
      String.format("Error Reading Record, record keys: %s",
	     StringUtils.join(names, ", ")));
}
```

