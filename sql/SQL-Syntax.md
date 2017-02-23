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

The following are reserved identifiers can NEVER be used (upper or lower case):

- ``` `@rid` ```
- ``` `@class` ```
- ``` `@version` ```
- ``` `@type` ```
- ``` `@fieldTypes` ```

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
- **integer numbers**: 

Valid integers are
```
(32bit)
1
12345678
-45

(64bit)
1L
12345678L
-45L
```

- **floating point numbers**: single or double precision

Valid floating point numbers are:
```
(single precision)
1.5
12345678.65432
-45.0

(double precision)
0.23D
.23D
```

- **absolute precision, decimal numbers**: like BigDecimal in Java

Use the `bigDecimal(<number>)` function to explicitly instantiate an absolute precision number.


- **strings**: delimited by `'` or by `"`. Single quotes, double quotes and back-slash inside strings can escaped using a back-slash

Valid strings are:
```
"foo bar"
'foo bar'
"foo \" bar"
'foo \' bar'
'foo \\ bar'
```

- **booleans**: boolean values are case sensitive

Valid boolean values are
```
true
false
```

Boolean value constants are case insensitive, so also `TRUE`, `True` and so on are valid.


- **links**: A link is a pointer to a document in the database

In SQL a link is represented as follows:

```
#<cluster-id>:<cluster-position>
```
eg.
```
#12:15
```


- **null**: case insensitive (for consistency with IS NULL and IS NOT NULL conditions, that are case insensitive)

Valid null expressions include
```
NULL
null
Null
nUll
...
```

###Numbers

OrientDB can store five different types of numbers
- Integer: 32bit signed
- Long: 64bit signed
- Float: decimal 32bit signed
- Duoble: decimal 64bit signed
- BigDecimal: absolute precision

(TODO hex and oct, decimal exponent, hex exponent)

**Integers** are represented in SQL as plain numbers, eg. `123`. If the number represented exceeds the Integer maximum size (see Java java.lang.Integer `MAX_VALUE` and `MIN_VALUE`), then it's automatically converted to a Long. 

When an integer is saved to a schemaful property of another numerical type, it is automatically converted. 

**Longs** are represented in SQL as numbers with `L` suffix, eg. `123L` (L can be uppercase or lowercase). Plain numbers (withot L prefix) that exceed the Integer range are also automatically converted to Long. If the number represented exceeds the Long maximum size (see Java java.lang.Long `MAX_VALUE` and `MIN_VALUE`), then the result is `NULL`;

**Float** numbers are represented in SQL as `[-][<number>].<number>`, eg. valid Float values are `1.5`, `-1567.0`, `.556767`. If the number represented exceeds the Float maximum size (see Java java.lang.Float `MAX_VALUE` and `MIN_VALUE`), then it's automatically converted to a Double. 

**Double** numbers are represented in SQL as `[-][<number>].<number>D` (D can be uppercase or lowercase), eg. valid Float values are `1.5d`, `-1567.0D`, `.556767D`. If the number represented exceeds the Double maximum size (see Java java.lang.Double `MAX_VALUE` and `MIN_VALUE`), then the result is `NULL`

**BigDecimal** in OrientDB is represented as a Java BigDecimal. 
The instantiation of BigDecimal can be done explicitly, using the `bigDecimal(<number> | <string>)` funciton, eg. `bigDecimal(124.4)` or `bigDecimal("124.4")`



Mathematical operations with numbers follow these rules:
- Operations are calculated from left to right, following the operand priority (see maths section)
- When an operation involves two numbers of different type, both are converted to the higher precision type between the two. 

Eg. 

```
15 + 20L = 15L + 20L     // the 15 is converted to 15L

15L + 20 = 15L + 20L     // the 20 is converted to 20L

15 + 20.3 = 15.0 + 20.3     // the 15 is converted to 15.0

15.0 + 20.3D = 15.0D + 20.3D     // the 15.0 is converted to 15.0D
```

the overflow follows Java rules.

The conversion of a number to BigDecimal can be done explicitly, using the `bigDecimal()` funciton, eg. `bigDecimal(124.4)` or `bigDecimal("124.4")`

###Collections

OrientDB supports two types of collections:
- **Lists**: ordered, allow duplicates
- **Sets**: not ordered (?), no duplicates
 
The SQL notation allows to create `Lists` with square bracket notation, eg.
```
[1, 3, 2, 2, 4]
```

A `List` can be converted to a `Set` using the `.asSet()` method:

```
[1, 3, 2, 2, 4].asSet() = [1, 3, 2, 4] /*  the order of the elements in the resulting set is not guaranteed */
```

###Binary data
OrientDB can store binary data (byte arrays) in document fields. There is no native representation of binary data in SQL syntax, insert/update a binary field you have to use `decode(<base64string>, "base64")` function.

To obtain the base64 string representation of a byte array, you can use the function `encode(<byteArray>, "base64")`

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
- `<json>`: It is translated to an ODocument. Nested JSON is allowed and is translated to nested ODocuments (TODO what about Maps?)
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
- **`>>`  (bitwise right shift)** (support will come after 3.0 M1)
- **`<<`  (bitwise right shift)** (support will come after 3.0 M1)
- **`&`  (bitwise AND)** (support will come after 3.0 M1)
- **`|`  (bitwise OR)** (support will come after 3.0 M1)
- **`^`  (bitwise XOR)** (support will come after 3.0 M1)
- **`~`  (bitwise NOT)** (support will come after 3.0 M1)
- **`||`**: array concatenation (support will come after 3.0 M1)

### Math + Assign operators

- **`+=`  (add and assign)**: adds right operand to left operand and assigns the value to the left operand. Returns the final value of the left operand. If one of the operands is not a number, then this operator acts as a `concatenate string values and assign`
- **`-=`  (subtract and assign)**: subtracts right operand from left operand and assigns the value to the left operand. Returns the final value of the left operand
- **`*=`  (multiply and assign)**: multiplies left operand and right operand and assigns the value to the left operand. Returns the final value of the left operand
- **`/=`  (divide and assign)**: divides left operand by right operand and assigns the value to the left operand. Returns the final value of the left operand
- **`%=`  (modulo and assign)**: calculates left operand modulo right operand and assigns the value to the left operand. Returns the final value of the left operand

### Array concatenation

The `||` operator concatenates two arrays.

```
[1, 2, 3] || [4, 5] = [1, 2, 3, 4, 5]
```

If one of the elements is not an array, then it's converted to an array of one element, before the concatenation operation is executed

```
[1, 2, 3] || 4 = [1, 2, 3, 4]

1 || [2, 3, 4] = [1, 2, 3, 4]

1 || 2 || 3 || 4 = [1, 2, 3, 4]
```

To add an array, you have to wrap the array element in another array:

```
[[1, 2], [3, 4]] || [5, 6] = [[1, 2], [3, 4], 5, 6]

[[1, 2], [3, 4]] || [[5, 6]] = [[1, 2], [3, 4], [5, 6]]
```

The result of an array concatenation is always a List (ordered and with duplicates). The order of the elements in the list is the same as the order in the elements in the source arrays, in the order they appear in the original expression.

To transform the result of an array concatenation in a Set (remove duplicates), just use the `.asSet()` method

```
[1, 2] || [2, 3] = [1, 2, 2, 3]

([1, 2] || [2, 3]).asSet() = [1, 2, 3] 
```


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

