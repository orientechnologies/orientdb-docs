# OrientDB SQL syntax

OrientDB Query Language is and SQL dialect.

This page lists all the details about its syntax.

### Identifiers
An identifier is a name that identifies an entity in OrientDB schema. Identifiers can refer to
- class names
- property names
- index names
- aliases
- cluster names
- function names
- method names
- named parameters
- variable names (LET)

An identifier is a sequence of characters delimited by back-ticks ``` ` ```. 
Examples of valid identifiers are
- ``` `surname` ```
- ``` `name and surname` ```
- ``` `foo.bar` ```
- ``` `a + b` ```
- ``` `select` ```

The back-tick character can be used as a valid character for identifiers, but it has to be escaped with a backslash, eg.
- ``` `foo \` bar` ```

**Simplified identifiers**

Identifiers that start with a letter or with `$` and that contain only numbers, letters and underscores, can be written without back-tick quoting. Reserved words cannot be used as simplified identifiers. Valid simplified identifiers are
- ```name```
- ```name_and_surname```
- ```$foo```
- ```name_12```


Examples of INVALID queries for wrong identifier syntax

```SQL
/* INVALID - `from` is a reserved keyword */
SELECT from from from 
/* CORRECT */
SELECT `from` from `from` 

/* INVALID - simplified identifiers cannot start with a number */
SELECT name as 1name from Foo
/* CORRECT */
SELECT name as `1name` from Foo

/* INVALID - simplified identifiers cannot contain `-` character, `and` is a reserved keyword */
SELECT name-and-surname from Foo
/* CORRECT 1 - `name-and-surname` is a single field name */
SELECT `name-and-surname` from Foo
/* CORRECT 2 - `name`, `and` and `surname` are numbers and the result is the subtraction */
SELECT name-`and`-surname from Foo
/* CORRECT 2 - with spaces  */
SELECT name - `and` - surname from Foo

/* INVALID - wrong back-tick escaping */
SELECT `foo`bar` from Foo
/* CORRECT */
SELECT `foo\`bar` from Foo

```
**Case sensitivity**

*(draft, TBD)* All the identifiers are case sensitive.

###Base types

Accepted base types in OrientDB SQL are:
- integer numbers: TODO precision

Valid integers are
```
1
12345678
-45
```
(TODO hex and oct, decimal exponent, hex exponent)

- floating point numbers: single or double precision

Valid floating point numbers are:
```
1.5
12345678.65432
-45.0
0.23
.23
```


- strings: delimited by `'` or by `"`. Single quotes, double quotes and back-slash inside strings can escaped using a back-slash

Valid strings are:
```
"foo bar"
'foo bar'
"foo \" bar"
'foo \' bar'
'foo \\ bar'
```

- booleans: boolean values are case sensitive

Valid boolean values are
```
true
false
```

- null: case insensitive (for consistency with IS NULL and IS NOT NULL conditions, that are case insensitive)

Valid null expressions include
```
NULL
null
Null
nUll
...
```

###Expressions

Expressions can be used as:

- single projections
- operands in a condition
- items in a GROUP BY 
- items in an ORDER BY
- right argument of a LET assignment

Valid expressions are:
- `<base type value>`
- `<field name>`
- `<@attribute name>`
- `<function invocation>`
- `<expression> <modifier> ( <modifier> )*`
- `( <query> )`

#### Modifiers

A modifier can be
- a method invocation, eg. `foo.size()`
- a square bracket filter, eg. `foo[1]` or `foo[name = 'John']`
- a dot-separated field chain, eg. `foo.bar`

#### Square bracket filters

Square brackets can be used to filter collections or maps. 

`field[ ( <expression> | <range> | <condition> ) ]`

Based on what is between brackets, the square bracket filtering has different effects:

- `<expression>`: If the expression returns an Integer or Long value (i), the result of the square bracket filtering
is the i-th element of the collection/map. If the result of the expresson (K) is not a number, the filtering returns the value corresponding to the key K in the map field. If the field is not a collection/map, the square bracket filtering returns `null`.
The result of this filtering is ALWAYS a single value.
- `<range>`: A range is something like `M..N`  or `M...N` where M and N are integer/long numbers, eg. `fieldName[2..5]`. The result of range filtering is a collection that is a subet of the original field value, containing all the items from position M (included) to position N (excluded for `..`, included for `...`). Eg. if `fieldName = ['a', 'b', 'c', 'd', 'e']`, `fieldName[1..3] = ['b', 'c']`, `fieldName[1...3] = ['b', 'c', 'd']`. Ranges start from `0`.
- `<condition>`: A normal SQL condition, that is applied to each element in the `fieldName` collection. The result is a sub-collection that contains only items that match the condition. Eg. `fieldName = [{foo = 1},{foo = 2},{foo = 5},{foo = 8}]`, `fieldName[foo > 4] = [{foo = 5},{foo = 8}]`.




###Conditions

TODO

