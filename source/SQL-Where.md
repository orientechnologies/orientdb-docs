# SQL - Filtering

The Where condition is shared among many SQL commands.

# Syntax

`[<item>] <operator> <item>`

# Items

And `item` can be:


|**What**|**Description**|**Example**|**Available since**|
|--------|---------------|-----------|-------------------|
|field|Document field|where *price* > 1000000|0.9.1|
|field&lt;indexes&gt;|Document field part. To know more about field part look at the full syntax: [Document_Field_Part](Document-Field-Part.md)|where tags[name='Hi'] or tags[0-3] IN ('Hello') and employees IS NOT NULL|1.0rc5|
|record attribute|Record attribute name with @ as prefix|where *@class* = 'Profile'|0.9.21|
|column|The number of the column. Useful in Column Database|where *column(1)* > 300|0.9.1|
|any()|Represents any field of the Document. The condition is true if ANY of the fields matches the condition|where *any()* like 'L%'|0.9.10|
|all()|Represents all the fields of the Document. The condition is true if ALL the fields match the condition|where *all()* is null|0.9.10|
|[functions](SQL-Functions.md)|Any [function](SQL-Functions.md) between the defined ones|where distance(x, y, 52.20472, 0.14056 ) <= 30|0.9.25|
|[$variable](SQL-Where.md#variables)|Context variable prefixed with $|where $depth <= 3|1.2.0|


## Record attributes


|Name|Description|Example|Available since|
|--------|---------------|-----------|-------------------|
|@this|returns the record it self|select **@this.toJSON()** from Account|0.9.25|
|@rid|returns the [RecordID](Concepts.md#recordid) in the form &lt;cluster:position&gt;. It's null for embedded records. *NOTE: using @rid in where condition slow down queries. Much better to use the [RecordID](Concepts.md#recordid) as target. Example: change this: select from Profile where @rid = #10:44 with this: select from #10:44 *|**@rid** = #11:0|0.9.21|
|@class|returns Class name only for record of type Schema Aware. It's null for the others|**@class** = 'Profile'|0.9.21|
|@version|returns the record version as integer. Version starts from 0. Can't be null|**@version** > 0|0.9.21|
|@size|returns the record size in bytes|**@size** > 1024|0.9.21|
|@fields|returns the number of fields in document|select @fields from V|-|
|@type|returns the record type between: 'document', 'column', 'flat', 'bytes'|**@type** = 'flat'|0.9.21|

# Operators

## Conditional Operators

|Apply to|Operator|Description|Example|Available since|
|--------|---------------|-----------|-------------------|----|
|any|=|Equals to|name **=** 'Luke'|0.9.1|
|string|like|Similar to equals, but allow the wildcard '%' that means 'any'|name **like** 'Luk%'|0.9.1|
|any|<|Less than|age **<** 40|0.9.1|
|any|<=|Less than or equal to|age **<=** 40|0.9.1|
|any|>|Greater than|age **>** 40|0.9.1|
|any|>=|Greater than or equal to|age **>=** 40|0.9.1|
|any|<>|Not equals (same of !=)|age **<>** 40|0.9.1|
|any|BETWEEN|The value is between a range. It's equivalent to &lt;field&gt; &gt;= &lt;from-value&gt; AND &lt;field&gt; &lt;= &lt;to-value&gt;|price BETWEEN 10 and 30|1.0rc2|
|any|IS|Used to test if a value is NULL|children **is** null|0.9.6|
|record, string (as class name)|INSTANCEOF|Used to check if the record extends a class|@this **instanceof** 'Customer' or @class **instanceof** 'Provider'|1.0rc8|
|collection|IN|contains any of the elements listed|name **in** ['European','Asiatic']||
|collection|CONTAINS|true if the collection contains at least one element that satisfy the next condition. Condition can be a single item: in this case the behaviour is like the IN operator|children **contains** (name = 'Luke') - map.values() **contains** (name = 'Luke')|0.9.7|
|collection|CONTAINSALL|true if all the elements of the collection satisfy the next condition|children *containsAll* (name = 'Luke')|0.9.7|
|map|CONTAINSKEY|true if the map contains at least one key equals to the requested. You can also use map.keys() CONTAINS in place of it|connections *containsKey* 'Luke'|0.9.22|
|map|CONTAINSVALUE|true if the map contains at least one value equals to the requested. You can also use map.values() CONTAINS in place of it|connections *containsValue* 10:3|0.9.22|
|string|CONTAINSTEXT|used with 89cd72a14eb5493801e99a43c5034685. Current limitation is that it must be the unique condition of a query. When used against an indexed field, a lookup in the index will be performed with the text specified as key. When there is no index a simple Java indexOf will be performed. So the result set could be different if you have an index or not on that field |text *containsText* 'jay'|0.9.22|
|string|MATCHES|Matches the string using a [http://www.regular-expressions.info/ Regular Expression]|text matches '\b[A-Z0-9.%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b'|0.9.6|
|any|TRAVERSE[(&lt;minDepth&gt; [,&lt;maxDepth&gt; [,&lt;fields&gt;]]|*This function was born before the SQL Traverse statement and today it's pretty limited. Look at [Traversing graphs](Java-Traverse.md) to know more about traversing in better ways.* <br>true if traversing the declared field(s) at the level from &lt;minDepth&gt; to &lt;maxDepth&gt; matches the condition. A minDepth = 0 means the root node, maxDepth = -1 means no limit: traverse all the graph recursively. If &lt;minDepth&gt; and &lt;maxDepth&gt; are not used, then (0, -1) will be taken. If &lt;fields&gt; is not passed, than any() will be used.|select from profile where any() **traverse(0,7,'followers,followings')** ( address.city.name = 'Rome' )|0.9.10 and 0.9.24 for &lt;fields&gt; parameter|


## Logical Operators


|Operator|Description|Example|Available since|
|--------|---------------|-----------|-------------------|
|AND|true if both the conditions are true|name = 'Luke' **and** surname like 'Sky%'|0.9.1|
|OR|true if at least one of the condition is true|name = 'Luke' **or** surname like 'Sky%'|0.9.1|
|NOT|true if the condition is false. NOT needs parenthesis on the right with the condition to negate|**not** ( name = 'Luke')|1.2|


## Mathematics Operators


|Apply to|Operator       |Description|Example            |Available since|
|--------|---------------|-----------|-------------------|---------------|
|Numbers|+|Plus|age + 34|1.0rc7|
|Numbers|-|Minus|salary - 34|1.0rc7|
|Numbers|\*|Multiply|factor \* 1.3|1.0rc7|
|Numbers|/|Divide|total / 12|1.0rc7|
|Numbers|%|Mod|total % 3|1.0rc7|

Starting from v1.4 OrientDB supports the `eval()` function to execute complex operations. Example:
```sql
select eval( "amount * 120 / 100 - discount" ) as finalPrice from Order
```

## Methods

Also called "Field Operators", are [are treated on a separate page](SQL-Methods.md).

# Functions

All the [SQL functions are treated on a separate page](SQL-Functions.md).

# Variables

OrientDB supports variables managed in the context of the command/query. By default some variables are created. Below the table with the available variables:


|Name    |Description    |Command(s) |Since|
|--------|---------------|-----------|-----|
|$parent|Get the parent context from a sub-query. Example: select from V let $type = ( traverse * from $parent.$current.children )|[SELECT](SQL-Query.md) and [TRAVERSE](SQL-Traverse.md)|1.2.0|
|$current|Current record to use in sub-queries to refer from the parent's variable|[SELECT](SQL-Query.md) and [TRAVERSE](SQL-Traverse.md)|1.2.0|
|$depth|The current depth of nesting|[TRAVERSE](SQL-Traverse.md)|1.1.0|
|$path|The string representation of the current path. Example:  #6:0.in.#5:0#.out. You can also display it with -> select $path from (traverse * from V)|[TRAVERSE](SQL-Traverse.md)|1.1.0|
|$stack|The List of operation in the stack. Use it to access to the history of the traversal|[TRAVERSE](SQL-Traverse.md)|1.1.0|
|$history|The set of all the records traversed as a Set&lt;ORID&gt;|[TRAVERSE](SQL-Traverse.md)|1.1.0|


To set custom variable use the [LET](SQL-Query.md#let-block) keyword.
