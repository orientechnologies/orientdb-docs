# Inheritance

OrientDB doesn't split Documents between different classes (as many OR-Mapping tools do). Each Document can reside in one or clusters associated with its specific class. When you execute a query against a class that has sub-classes, OrientDB will search into the clusters of the target class and all its sub-classes.

## Declare in schema

OrientDB needs to know the the class inheritance relationship. Note that this is an abstract concept that applies to both [POJOs](Object-Database.md#inheritance) and  [Documents](Document-Database.md#inheritance).

Example:

```java
OClass account = database.getMetadata().getSchema().createClass("Account");
OClass company = database.getMetadata().getSchema().createClass("Company").setSuperClass(account);
```

## Polymorphic Queries

By default all queries are polymorphic. Using the example above with this SQL query:

```sql
SELECT FROM account WHERE name.toUpperCase() = 'Google'
```
Will return all the instances of the `Account` and the `Company` classes that have the property name equal to `Google`.

## How it works

Consider this example. We have 3 classes, with the cluster-id between parentheses:

```
Account(10) <|--- Company (13) <|--- OrientTechnologiesGroup (27)
```

OrientDB, by default, creates a separate cluster for each class.

This cluster is indicated by the `defaultClusterId` property in the `OClass` class and indicates the cluster used by default when not specified. However the `OClass` has a property `clusterIds` (as `int[]`) that contains all the clusters able to contain the records of that class.

By default `clusterIds` and `defaultClusterId` are the same.

When you execute a query against a class, OrientDB limits the result sets to only the records of the clusters contained in the `clusterIds` property.

In this way when you execute this:

```sql
SELECT FROM Account WHERE name.toUpperCase() = 'GOOGLE'
```

Will return all the records with the name property set to `GOOGLE` from all three classes because the base class, `Account`, was specified.  For the class `Account` OrientDB searches inside the clusters `10`, `13` and, `27` (following the inheritance specified in the schema).
