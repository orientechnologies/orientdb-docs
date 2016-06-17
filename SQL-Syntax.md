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

###Reserved words

In OrientDB SQL the following are reserved words

- AFTER
- AND
- AS
- ASC
- BATCH
- BEFORE
- BETWEEN
- BREADTH_FIRST
- BY
- CLUSTER
- CONTAINS
- CONTAINSALL
- CONTAINSKEY
- CONTAINSTEXT
- CONTAINSVALUE
- CREATE
- DEFAULT
- DEFINED
- DELETE
- DEPTH_FIRST
- DESC
- DISTINCT
- EDGE
- FETCHPLAN
- FROM
- INCREMENT
- INSERT
- INSTANCEOF
- INTO
- IS
- LET
- LIKE
- LIMIT
- LOCK
- MATCH
- MATCHES
- MAXDEPTH
- NOCACHE
- NOT
- NULL
- OR
- PARALLEL
- POLYMORPHIC
- RETRY
- RETURN
- SELECT
- SKIP
- STRATEGY
- TIMEOUT
- TRAVERSE
- UNSAFE
- UNWIND
- UPDATE
- UPSERT
- VERTEX
- WAIT
- WHERE
- WHILE

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
- `<base type value>` (string, number, boolean)
- `<field name>`
- `<@attribute name>`
- `<function invocation>`
- `<expression> <binary operator> <expression>`: with Java precedence rules
- `<unary operator> <expression>` 
- `<expression> ? <expression> : <expression>`: ternary if-else operator
- `( <expression> )`: expression between parenthesis, for precedences
- `( <query> )`: query between parenthesis
- `[ <expression> (, <expression>)* ]`: a list, an ordered collection that allows duplicates, eg. `["a", "b", "c"]`)
- `{ <expression>: <expression> (, <expression>: <expression>)* }`: the result is an ODocument, with <field>:<value> values, eg. `{"a":1, "b": 1+2+3, "c": foo.bar.size() }`. The key name is converted to String if it's not.
- `<expression> <modifier> ( <modifier> )*`: a chain of modifiers (see below)
- `<expression> IS NULL`: check for null value of an expression
- `<expression> IS NOT NULL`: check for non null value of an expression

#### Modifiers

A modifier can be
- a dot-separated field chain, eg. `foo.bar`.
- a method invocation, eg. `foo.size()`.
- a square bracket filter, eg. `foo[1]` or `foo[name = 'John']`


#### Square bracket filters

Square brackets can be used to filter collections or maps. 

`field[ ( <expression> | <range> | <condition> ) ]`

Based on what is between brackets, the square bracket filtering has different effects:

- `<expression>`: If the expression returns an Integer or Long value (i), the result of the square bracket filtering
is the i-th element of the collection/map. If the result of the expresson (K) is not a number, the filtering returns the value corresponding to the key K in the map field. If the field is not a collection/map, the square bracket filtering returns `null`.
The result of this filtering is ALWAYS a single value.
- `<range>`: A range is something like `M..N`  or `M...N` where M and N are integer/long numbers, eg. `fieldName[2..5]`. The result of range filtering is a collection that is a subet of the original field value, containing all the items from position M (included) to position N (excluded for `..`, included for `...`). Eg. if `fieldName = ['a', 'b', 'c', 'd', 'e']`, `fieldName[1..3] = ['b', 'c']`, `fieldName[1...3] = ['b', 'c', 'd']`. Ranges start from `0`. The result of this filtering is ALWAYS a list (ordered collection, allowing duplicates). If the original collection was ordered, then the result will preserve the order.
- `<condition>`: A normal SQL condition, that is applied to each element in the `fieldName` collection. The result is a sub-collection that contains only items that match the condition. Eg. `fieldName = [{foo = 1},{foo = 2},{foo = 5},{foo = 8}]`, `fieldName[foo > 4] = [{foo = 5},{foo = 8}]`. The result of this filtering is ALWAYS a list (ordered collection, allowing duplicates). If the original collection was ordered, then the result will preserve the order.


###Conditions

A condition is an expression that returns a boolean value.

An expression that returns something different from a boolean value is always evaluated to `false`.

### Math Operators

- **`=`  (equals)**: If used in an expression, it is the boolean equals (eg. `select from Foo where name = 'John'`. If used in an SET section of INSERT/UPDATE statements or on a LET statement, it represents a variable assignment (eg. `insert into Foo set name = 'John'`)
- **`!=` (not equals)**: inequality operator. (TODO type conversion)
- **`<>` (not equals)**: same as `!=`
- **`>`  (greater than)**
- **`>=` (greater or equal)**
- **`<`  (less than)**
- **`<=` (less or equal)**
- **`+`  (plus)**: addition if both operands are numbers, string concatenation (with string conversion) if one of the operands is not a number. The order of calculation (and conversion) is from left to right, eg `'a' + 1 + 2 = 'a12'`, `1 + 2 + 'a' = '3a'`. Plus can also be used as a unary operator (no effect)
- **`-`  (minus**): subtraction between numbers. Non-number operands are evaluated to zero (TODO CHECK THIS!!!). Minus can also be used as a unary operator, to invert the sign of a number
- **`*`  (multiplication)**: multiplication between numbers. Non-number operands are evaluated to one (TODO CHECK THIS!!!). 
- **`/`  (division)**: division between numbers. Non-number operands are evaluated to one (TODO CHECK THIS!!!). The result of a division by zero is NaN
- **`%`  (modulo)**: modulo between numbers. Non-number operands are evaluated to one (TODO CHECK THIS!!!). 
- **`>>`  (bitwise right shift)**
- **`<<`  (bitwise right shift)**
- **`&`  (bitwise AND)**
- **`|`  (bitwise OR)**
- **`^`  (bitwise XOR)**
- **`~`  (bitwise NOT)**

### Boolean Operators

- **`AND`**: logical AND
- **`OR`**: logical OR
- **`NOT`**: logical NOT
- **`CONTAINS`**: checks if the left collection contains the right element. The left argument has to be a colleciton, otherwise it returns FALSE. It's NOT the check of colleciton intersections, so `['a', 'b', 'c'] CONTAINS ['a', 'b']` will return FALSE, while `['a', 'b', 'c'] CONTAINS 'a'` will return TRUE. 
- **`IN`**: the same as CONTAINS, but with inverted operands.
- **`CONTAINSKEY`**: for maps, the same as for CONTAINS, but checks on the map keys
- **`CONTAINSVALUE`**: for maps, the same as for CONTAINS, but checks on the map values
- **`LIKE`**: for strings, checks if a string contains another string. `%` is used as a wildcard, eg. `'foobar CONTAINS '%ooba%''`
- **`IS DEFINED`** (unary): returns TRUE is a field is defined in a document
- **`IS NOT DEFINED`** (unary): returns TRUE is a field is not defined in a document
- **`BETWEEN - AND`** (ternary): returns TRUE is a value is between two values, eg. `5 BETWEEN 1 AND 10`
- **`MATCHES`**: checks if a string matches a regular expression
- **`INSTANCEOF`**: checks the type of a value, the right operand has to be the a String representing a class name, eg. `father INSTANCEOF 'Person'` (TODO consider identifiers as class names as well?)

