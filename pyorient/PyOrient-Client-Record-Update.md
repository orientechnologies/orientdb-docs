---
search:
   keywords: ['PyOrient', 'client', 'update record']
---

# PyOrient Client - `record_update()`

This method updates the given Record ID with data from a dict argument.

>**Warning**: Prior to version 2.0 of OrientDB, some users encountered issues with `record_update()` and [`record_create()`](PyOrient-Client-Record-Create.md) in PyOrient.  When developing applications for older versions of OrientDB, it is recommended that you avoid these methods.

## Updating Records

When you want to update an existing record on OrientDB, you can use the `record_update()` method.  In order to update a record, you'll need its Record ID and version, which you can call from the record object.

**Syntax**

```
client.record_update(<record-id>, <data>, <version>)
```

- **`<record-id>`** Defines the Record ID of the record you want to update.
- **`<data>`** Defines the data you want to change in a dict.
- **`<versin>`** Defines the version of the record you want to update.

The dict object you pass to this method uses the following format:

```
data = {
   @<class>: {
      <property>: <value>
   }
}
```

- **`<class>`** Defines the class name.
- **`<property>`** Defines the property you want to add, if any.
- **`<value>`** Defines the value you want to assign the property.


**Example**

Consider the example of a database for a smart home application.  Say that you have a series of appliances that you have modified with your own custom electronics.  For instance, you might add a Raspberry Pi with a touchscreen to the refrigerator, to display weather information while idle and provide an app for generating grocery lists.

Whenever you open the grocery list, your application checks in with OrientDB for the current shopping list, then updates the database with the new entries.  Then, say you have guests coming over and want to buy more eggs:

```py

# Fetch Grocery List
eggs = client.query(
   "SELECT FROM ShoppingList "
   "WHERE type = 'grocery'"
   "AND item = 'eggs'")

data = {
   "@ShoppingList": {
      "quantity": 24
   }
}
client.record_update(eggs._rid, data, eggs._version)
```

Here, PyOrient uses the [`query()`](PyOrient-Client-Query.md) method to retrieve an object instance from the database, it then updates the `ShoppingList` with the new quantity of eggs.
