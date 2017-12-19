
{% include "./include-warning-3.0.md" %}

# Upgrading to OrientDB 3.0

## General information

Developing OrientDB 3.0 we put a lot of attention on maintaining backward compatibility with v 2.2. In some cases though, we had to do some small breaking changes to make the whole solution more consistent. 

Here is a list of the things you should know when migrating to v 3.0

## Schema

### Case sensitive property names

In v 2.2 property names are case sensitive while working schemaless, while if you work schemaful property names are treated as case insensitive.

Eg. consider the following queries:

```
Query 1:
SELECT name from V

Query 2:
SELECT Name from V
```

In v 2.2:
- Query 1 and Query 2 are equivalent if you are working schemaless
- Query 1 and Query 2 are *different* if you declared `name` property in the schema for V


In v 3.0 these two queries are *always* different, so `Name` and `name` are considered two different properties (with or without a schema)

When migrating from v 2.2 to v 3.0, review your queries and make sure that you are writing property names in the right case

> Note: CLASS names are still *case insensitive*

### Case sensitive index names

In v 2.2 index names are case insensitive

In v 3.0 index names are *case sensitive*

When migrating from v 2.2 to v 3.0, review your queries and make sure that you are writing index names in the right case

## SQL

### UPDATE ADD/PUT/INCREMENT

In v 2.2 there was a specific syntax for:
- adding values to lists: `UPDATE AClass ADD aListProperty = "a value to add"`
- adding elements to maps: `UPDATE AClass PUT aMapProperty = "a key to add", "a value to add"`
- incrementing values: `UPDATE AClass INCREMENT aNumberProperty = <aNumber>`

This syntax is limitating, misleading and hard to read, so we decided to switch to a more natural syntax, as follows:

#### UPDATE ADD:

V 3.0 has a new `||` operator that allows to concatenate lists and sets:

```
UPDATE AClass ADD aListProperty = "a value to add"
```
becomes
```
UPDATE AClass SET aListProperty =  aListProperty || "a value to add"
```
but it can also be used to concatenate the value *on the left*:
```
UPDATE AClass SET aListProperty =  "a value to add" || aListProperty
```
or to concatenate multiple values:
```
UPDATE AClass SET aListProperty =  aListProperty || ["a value to add", "another value"]
```



# Release notes

General information on how to upgrade OrientDB can be found in the [Upgrade](../Upgrade.md) Chapter.

You may also be interested in checking the [Release Notes](../Release-Notes.md).
