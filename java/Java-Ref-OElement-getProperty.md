---
search:
   keywords: ['Java API', 'OElement', 'getProperty', 'get property', 'properties]
---

# OElement - getProperty()

This method retrieves the given property from a record.

## Retrieving Properties

OrientDB stores the particular data for each record in fields, also called properties.  Using this method you can retrieve data from the record to operate on it from within your Java application.  The method uses the property name and type to identify the data you want to retrieve.

### Syntax

```
<RET> RET OElement().getProperty(String name)
```

| Argument | Type | Description |
|---|---|---|
| **`name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the property name |

#### Return Value

OrientDB stores typed data.  The return value this method returns is of the type that coresponds to the given property. For more information, see [Supported Data Types](../general/Types.md).

### Example

Records often contain more data that you need to operate on in a particular instance.  For instance, imagine you have a web application that serves blogs.  You don't need the entire record when you're only rendering a link.  You might use a method like the one below to create a link from an [`OElement`](Java-Ref-OElement.md):

```java
// GENERATE LINK
public String makeLink(OElement record){

	String title = record.getProperty("title");
	String url = record.getProperty("URL");

	return String.format("<a href=\"%s\">%s</a>", url, title);

}
```
