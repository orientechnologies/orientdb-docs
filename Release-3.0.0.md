### API changes

**ODocument**

`ODocument.field(name)` and `ODocument.field(name, value)` now do not interprete the field name as an expression. 
Any character is allowed.

eg.

```java
ODocument doc = new ODocument();
doc.field("foo.bar", 15); 

ODocument foo = new ODocument();
doc.field("foo", foo);
foo.field("bar", 30);

Integer thisIs15 = doc.field("foo.bar"); //this evaluates the field whose name is `foo.bar`
Integer thisIs30 = doc.eval("foo.bar");  //this evaluates the expression `foo`.`bar`

```

IMPORTANT: in the near future `ODocument.field()` methods will be deprecated and replaced with `ODocument.get/setProperty()`


**OProperty**

`OProperty.getFullName()` now returns ``` `ClassName`.`propertyName` ``` instead of ```ClassName.propertyName```
