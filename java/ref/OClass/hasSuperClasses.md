---
search:
   keywords: ['Java API', 'OClass', 'polymorphism', 'has super classes', 'hasSuperClasses']
---

# OClass - hasSuperClasses()

This method determines whether the class is a subclass of another class.

## Checking for Superclasses

OrientDB borrows the concept of class from the Objected Oriented programming paradigm.  This borrowing includes polymorphism, or the idea that a class can be a subclass of and inherit from another class.  Using this method, you can determine whether your [`OClass`](../OClass.md) instance inherits from any superclasses. 

### Syntax

```
boolean OClass().hasSuperClasses()
```

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance, where a `true` value indicates that it is a subclass.
