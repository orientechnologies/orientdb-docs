## SQL Projections

A projection is a value that is returned by a query statement (SELECT, MATCH).

Eg. the following query

```sql
SELECT name as firstName, age * 12 as ageInMonths, out("Friend") from Person where surname = 'Smith'
```

has three projections:

- `name as firstName`
- `age * 12 as ageInMonths`
- `out("Friend")`

### Syntax

**A projection** has the following syntax:

`<expression> [<nestedProjection>] [ AS <alias> ]`

- `<expression>` is an expression (see [SQL Syntax](SQL-Syntax.md)) that represents the way to calculate the value of the single projection
- `<alias>` is the Identifier (see [SQL Syntax](SQL-Syntax.md)) representing the field name used to return the value in the result set

A projection block has the following syntax:

`[DISTINCT] <projection> [, <projection> ]*`

- `DISTINCT`: removes duplicates from the result-set

*IMPORTANT - the old `distinct()` function (used in OrientDB <=2.x) is no longer supported*


### Query result

By default, a query returns a different result-set based on the projections it has:
- **`*` alone**: The result set is made of records as they arrive from the target, with the original @rid and @class attributes (if any)
- **`*` plus other projections**: records of the original target, merged with the other projection values, with @rid, @class and @version of the original record. 
- **no projections**: same behavior as `*`
- **`expand(<projection>)`**: The result set is made of the records returned by the projection, expanded (if the projection result is a link or a collection of links) and unwinded (if the projection result is a collection). Nothing in all the other cases.
- **one or more projections**: temporary records (with temporary @rid and no @class). Projections that represent links are returned as simple @rid values, unless differently specified in the fetchplan.

*IMPORTANT - projection values can be overwritten in the final result, the overwrite happens from left to right*

eg.
```sql
SELECT 1 as a, 2 as a 
```
will return `[{"a":2}]`

eg.

Having the record `{"@class":"Foo", "name":"bar", "@rid":"#12:0", "@version": 2}`

```sql
SELECT *, "hey" as name from Foo
```
will return `[{"@class":"Foo", "@rid":"#12:0", "@version": 2, "name":"hey"}]`

```sql
SELECT  "hey" as name, * from Foo
```
will return `[{"@class":"Foo", "@rid":"#12:0", "@version": 2, "name":"bar"}]`


> ATTENTION: when saving back a record with a valid rid, you will overwrite the existing record! So pay attention 
when using `*` together with other projections 

> IMPORTANT - the result of the query can be further unwound using the UNWIND operator

> IMPORTANT: `expand()` cannot be used together with `GROUP BY`

### Aliases

The alias is the field name that a projection will have in the result-set.

An alias can be implicit, if declared with the `AS` keyword, eg.

```sql
SELECT name + " " + surname as full_name from Person

result:
[{"full_name":"John Smith"}]
```

An alias can be implicit, when no `AS` is defined, eg.


```sql
SELECT name from Person

result:
[{"name":"John"}]
```

An implicit alias is calculated based on how the projection is written. By default, OrientDB uses the plain String representation of the projection as alias. 


```
SELECT 1+2 as sum

result:
[{"sum": 3}] 
```

```
SELECT parent.name+" "+parent.surname as full_name from Node

result:
[{"full_name": "John Smith"}] 
```

The String representation of a projection is the exact representation of the projection string, without spaces before and after dots and brackets, no spaces before commas, a single space before and after operators.

eg.

```
SELECT 1+2 

result:
[{"1 + 2": 3}] /* see the space before and after the + sign */
```

```
SELECT parent.name+" "+parent.surname from Node

result:
[{"parent.name + \" \" + parent.surname": "John Smith"}] 
```

```
SELECT items[4] from Node

result:
[{"items[4]": "John Smith"}] 
```

### Nested projections

(since v 3.0 M2)

#### Syntax:


`":{" ( * | (["!"] <identifier> ["*"] (<comma> ["!"] <identifier> ["*"])* ) ) "}"`


A projection can refer to a link or to a collection of links, eg. a LINKLIST or a LINKSET.
In some cases you can be interested in the expanded object instead of the RID.

Let's clarify this with an example. This is our dataset:

| @rid  | name | surname | parent |
|-------|------|---------|--------|
| #12:0 | foo  | fooz    |        |
| #12:1 | bar  | barz    | #12:0  |
| #12:2 | baz  | bazz    | #12:1  |

Given this query:

```SQL
SELECT name, parent FROM TheClass WHERE name = 'baz'
```
The result is

```
{ 
   "name": "baz",
   "parent": #12:1
}
```
Now suppose you want to expand the link and retrieve some properties of the linked object.
You can do it explicitly do it with other projections:

```SQL
SELECT name, parent.name FROM TheClass WHERE name = 'baz'
```

```
{ 
   "name": "baz",
   "parent.name": "bar"
}
```

but this will force you to list them one by one, and it's not always possible, especially when you don't know all their names.

Another alternative is to use nested projections, eg.

```SQL
SELECT name, parent:{name} FROM TheClass WHERE name = 'baz'
```

```
{ 
   "name": "baz",
   "parent": {
      "name": "bar"
   }
}
```
or with multiple attributes
```SQL
SELECT name, parent:{name, surname} FROM TheClass WHERE name = 'baz'
```

```
{ 
   "name": "baz",
   "parent": {
      "name": "bar"
      "surname": "barz"      
   }
}
```

or using a wildcard

```SQL
SELECT name, parent:{*} FROM TheClass WHERE name = 'baz'
```

```
{ 
   "name": "baz",
   "parent": {
      "name": "bar"
      "surname": "barz"      
      "parent": #12:0
   }
}
```

You can also use the `!` exclude syntax to define which attributes you want to *exclude* from the nested projection:

```SQL
SELECT name, parent:{!surname} FROM TheClass WHERE name = 'baz'
```

```
{ 
   "name": "baz",
   "parent": {
      "name": "bar"
      "parent": #12:0
   }
}
```

You can also use a wildcard on the right of property names, to specify the inclusion of attributes that start with a prefix, eg.

```SQL
SELECT name, parent:{surna*} FROM TheClass WHERE name = 'baz'
```

```
{ 
   "name": "baz",
   "parent": {
      "surname": "barz"      
   }
}
```

or their exclusion

```SQL
SELECT name, parent:{!surna*} FROM TheClass WHERE name = 'baz'
```

```
{ 
   "name": "baz",
   "parent": {
      "name": "bar",      
      "parent": #12:0
   }
}
```

Nested projection syntax allows for multiple level depth expressions, eg. you can go three levels deep as follows:

```
SELECT name, parent:{name, surname, parent:{name, surname}} FROM TheClass WHERE name = 'baz'
```

```
{ 
   "name": "baz",
   "parent": {
      "name": "bar"
      "surname": "barz"      
      "parent": {
         "name": "foo"
         "surname": "fooz"      
      }   
   }
}
```

You can also use expressions and aliases in nested projections:

```
SELECT name, parent.parent:{name, surname} as grandparent FROM TheClass WHERE name = 'baz'
```

```
{ 
   "name": "baz",
   "grandparent": {
      "name": "foo"
      "surname": "fooz"      
   }   
}
```
