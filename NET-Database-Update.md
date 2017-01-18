---
search:
   keywords: ['NET', 'c#', 'ODatabase', 'update']
---

# OrientDB-NET - `Update()`

This method updates records on the database.

## Updating Records

Using this method you can change or otherwise modify records on the database.  By itself, it initializes an `OSqlUpdate` object, which you can then operate on to further define the records you want to change and what changes you would like to make.

### Syntax

```
// UPDATING RECORDS
OSqlUpdate ODatabase.Update()
```

There are several methods available to the `OSqlUpdate` method.  These allow you to build and execute the update against your database.


#### Defining the Target

When using this method, you can update by class, cluster or Record ID.

- **Class Updates**

  ```
  OSqlUpdate ODatabase.Update()
     .Class(string className)
  ```

- **Cluster Updates**

  ```
  OSqlUpdate ODatabase.Update()
     .Cluster(string clusterName)
  ```

- **Record Updates**

  ```
  // RECORD METHOD
  OSqlUpdate ODatabase.Update()
     .Record(ORID recordID)

  // RECORD ARGUMENT
  OSqlUpdate ODatabase.Update(ORID recordID)
  ```

For the sake of simplicity, syntax cases shown hereafter assume that you're updating a class.

#### Defining the Update

When using this method, you have a few options in defining the update that you want to make: whether you're adding or removing data, or changing records.

- **Setting Field**

  ```
  OSqlUpdate ODatabase.Update(<rid>)
     .Set(field, value)
  ```

- **Adding Fields**

  ```
  OSqlUpdate ODatabase.Update(<rid>)
     .Add(field, value)
  ```

- **Removing Fields**

  ```
  OSqlUpdate ODatabase.Update(<rid>)
     .Remove(field)
  ```

#### Executing Updates

Using the above methods you can build the update that you want, however OrientDB-NET does not execute the update on your database until you use an execution method: 

- `Run()` Executes the update on the database and returns an integer.

- `ToString()` Executes the update on the database and returns a string.


### Example

For instance, say that you routinely implement complicated updates on your database with various changes.  You might wnat to build a helper function that loops through common variables in defining the update.

```csharp
using Orient.Client;
using System;
...

// UPDATE OPERATION
public ODocument UpdateDatabase(ODatabase database, string className,
      Dictionary<string, string> changes)
{
   // LOG OPERATION
   Console.WriteLine("Updating Class: {0}", className);

   // INITIALIZE UPDATE
   OSqlUpdate update = database.Update().Class(classname);

   // DEFINE CHANGES
   foreach(KeyValuePair<string, string> setting in changes)
   {
      // APPLY CHANGES
      update.Set(setting.Key, setting.Value);
   }

   // RUN AND RETURN ODOCUMENT
   return update.Run();
}
```
