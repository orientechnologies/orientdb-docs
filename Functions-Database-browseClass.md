---
search:
   keywords: ['functions', 'database', 'browse class', 'browseClass']
---

# Functions - browseClass()

This method returns all records of a given class.

## Browsing Classes

OrientDB borrows from the Object Oriented Programming paradigm the concept of a class.  Where a cluster defines where the database stores records, classes define what kind of records you want to store. Occasionally, you may find it useful to retrieve all records by class.  For instance, you may have a function to perform routine security checks on users with access to your database.  Calling this method on the `OUser` and `ORole` classes can retrieve records on all database users and allow you to determine the resources they can access by role.

### Syntax

```
var records = db.browseClass(<name>, <polymorphic>)
```

- **`<name>`** Defines the class name.
- **`<polymorphic>`** Defines whether you want the method to retrieve subclasses. By default, it is `false`.
