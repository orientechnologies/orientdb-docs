---
search:
   keywords: ['Java API', 'OClass', 'Cluster ID', 'polymorphism', 'class', 'cluster', 'has polymorphic cluster id', 'hasPolymorphicClusterId']
---

# OClass - hasPolymorphicClusterId()

This method determines whether the class or any subclass of the class use the given cluster.

## Checking for Clusters 

OrientDB borrows the concept of class from the Object Oriented programming paradigm.  This borrowing includes polymorphism, the idea that a class can have subclasses and superclasses.  Those superclasses and subclasses have their own clusters used in storing records.  This method determines whether any class that is a superclass or subclass of this class uses the given cluster, as defined by its Cluster ID (the first number in a Record ID).

### Syntax

```
boolean OClass().hasPolymorphicClusterId(int clusterId)
```

| Argument | Type | Description |
|---|---|---|
| **`clusterId`** | [`int`]({{ book.javase }}/api/java/lang/Integer.html) | Defines the cluster you want to check for, by its Cluster ID |

#### Return Value

This method returns a [`Boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance, where a `true` value indicates that polymorphic classes of this class do use the given cluster.
