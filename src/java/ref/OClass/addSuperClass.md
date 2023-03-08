---
search:
   keywords: ['Java API', 'OClass', 'class', 'super class', 'addSuperClass']
---

# OClass - addSuperClass()

This method adds a superclass to the database class.

## Adding Superclasses

OrientDB supports polymorphism in database classes.  This means that you can register an [`OClass`](../OClass.md) instance to extend another [`OClass`](../OClass.md) instance.  Using this method, you can assign the given database class as the superclass to this class.

### Syntax

```
OClass OClass().addSuperClass(OClass superClass)
```

| Argument | Type | Description |
|---|---|---|
| **`superClass`** | [`OClass`](../OClass.md) | Defines the superclass |

#### Return Value

This method returns an [`OClass`](../OClass.md) instance.

### Example

Imagine you want a method to provision a database for your application.  You might want to add a series of classes in sequence and then add them to the relevant superclass.

```java
private ODatabaseDocument db;
private Logger logger;

public void provisionSubClasses(OClass superCls, List<OClass> classes){

    // Log Operation
	logger.info(String.format( 
		"Adding subclasses to %s",
		superCls.getName()));

	// Iterate over subclasses 
	for(OClass cls : classes){

		// Log Debug Message
		logger.debug(String.format(
		   "Adding subclass '%s',
		   cls.getName()));

		// Add Superclass to Class
		cls.addSuperClass(superCls);
	}
	logger.debug("Done");
}
```
