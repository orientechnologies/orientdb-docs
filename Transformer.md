<!-- proofread 2015-12-11 SAM -->
# ETL Transformers
Transformer components are executed in a pipeline. They work with the received input and return output.

Before the execution, the `$input` variable is always assigned, so you can get at run-time and use if needed.

## Available Transformers

|[CSV](Transformer.md#csv)|[FIELD](Transformer.md#field)|[MERGE](Transformer.md#merge)|[VERTEX](Transformer.md#vertex)|
|-----|-----|-----|-----|
|[CODE](Transformer.md#code) |[LINK](Transformer.md#link)|[EDGE](Transformer.md#edge)|[FLOW](Transformer.md#flow) |
|[LOG](Transformer.md#log)|[BLOCK](Transformer.md#block) | [COMMAND](Transformer.md#command)|<!-- PH -->|


### CSV *Deprecated*
*DEPRECATED* : since version **2.1.4**  please use the new [csv extractor](Extractor.md#csv) instead
Converts a String in a Document parsing it as CSV.

Component description.
- Component name: **csv**
- Supported inputs types: [**String**]
- Output: **ODocument**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|separator|Column separator|char|false|,|
|columnsOnFirstLine|Columns are described in the first line|boolean|false|true|
|columns|Columns array containing names, and optionally types by postfixing names with :<type>. Specifying type guarantee better performance|string[]|false|<!-- PH -->|
|nullValue|value to consider as NULL. Default is not declared|string|false|<!-- PH -->|
|stringCharacter|String character delimiter|char|false|"|
|skipFrom|Line number where start to skip|integer|true|<!-- PH -->|
|skipTo|Line number where skip ends|integer|true|<!-- PH -->|

#### Example
Transforms a row in CSV (as ODocument), using comma as separator, considering "NULL" as null value and skipping the rows 2-4:
```json
{ "csv": { "separator": ",", "nullValue": "NULL",
           "skipFrom": 1, "skipTo": 3 } }
```

-----

## FIELD
Execute a SQL transformation against a field.

Component description.
- Component name: **vertex**
- Supported inputs types: [**ODocument**]
- Output: **ODocument**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|fieldName|Document's field name to assign|string|false|<!-- PH -->|
|fieldNames|Document's field names to assign (Since 2.1)|string|false|<!-- PH -->|
|expression|Expression to evaluate. You can use [OrientDB SQL syntax](https://github.com/orientechnologies/orientdb/wiki/SQL-Where#syntax)|string|true|<!-- PH -->|
|value|Value to set. If the value is taken or computed at run-time, use `expression` instead|any|false|<!-- PH -->|
|operation|Operation to execute against the field(s): set, remove. Default is set|string|false|set|
|save|Save the vertex/edge/document right after the setting of the field|boolean|false|false|

#### Examples
Transform the field 'class' into the ODocument's class by prefixing it with '_':

```json
{ "field": { "fieldName": "@class", "expression": "class.prefix('_')"} }
```

Apply the class name based on the value of another field:

```json
{ "field": { "fieldName": "@class", "expression": "if( ( fileCount >= 0 ), 'D', 'F')"} }
```

Assign the last part of a path to the "name" field:

```json
{ "field": { "fieldName": "name",
      "expression": "path.substring( eval( '$current.path.lastIndexOf(\"/\") + 1') )" }
```

Assign a fixed value:
```json
{ "field": { "fieldName": "counter", "value": 0} }
```

Rename a field from 'salary' to 'remuneration':
```json
{ "field": { "fieldName": "remuneration", "expression": "salary"} },
{ "field": { "fieldName": "salary", "operation": "remove"} }
```

Rename multiple fields in one call (As of v2.1):
```json
{ "field": { "fieldNames": ["remuneration","salary"], "operation": "remove"} }
```
-----

### MERGE
Merges input ODocument with another one, loaded by a lookup. Lookup can be a lookup against an index or a SELECT query.

Component description.
- Component name: **merge**
- Supported inputs types: [**ODocument**, **OrientVertex**]
- Output: **ODocument**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|joinFieldName|Field name where the join value is saved|string|true|<!-- PH -->|
|lookup|Can be the index name where to execute the lookup, or a SELECT query|string|true|<!-- PH -->|
|unresolvedLinkAction|Action to execute in case the JOIN hasn't been resolved. Actions can be: 'NOTHING' (do nothing), WARNING (increment warnings), ERROR (increment errors), HALT (interrupt the process), SKIP (skip current row).|string|false|NOTHING|

#### Example
Merge current record against the record returned by the lookup on index "V.URI" with the value contained in the  field "URI" of the input's document:
```json
{ "merge": { "joinFieldName":"URI", "lookup":"V.URI" } }
```
-----

### VERTEX
Transform a ODocument in a OrientVertex.

Component description.
- Component name: **vertex**
- Supported inputs types: [**ODocument**, **OrientVertex**]
- Output: **OrientVertex**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|class|Vertex class name to assign|string|false|V|
|skipDuplicates|Vertices with duplicate keys are skipped. If `skipDuplicates:true` and a UNIQUE constraint is defined on vertices, the ETL will ignore the duplicate with no exceptions. Available since v2.1|boolean|false|false|

#### Example
Transform the ODocument in a Vertex setting as class the value of "$className" variable:
```json
{ "vertex": { "class": "$className", "skipDuplicates": true } }
```
-----

### EDGE
Transform a JOIN value in one or more EDGEs between current vertex and all the vertices returned by the lookup. Lookup can be a lookup against an index or a SELECT query.

Component description.
- Component name: **EDGE**
- Supported inputs types: [**ODocument**, **OrientVertex**]
- Output: **OrientVertex**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|joinFieldName|Field name where the join value is saved|string|true|<!-- PH -->|
|direction|Edge direction|string|false|'out'|
|class|Edge's class name|string|false|'E'|
|lookup|Can be the index name where to execute the lookup, or a SELECT query|string|true|<!-- PH -->|
|targetVertexFields|Fields to set in the target vertex (since v2.1)|object|false|<!-- PH -->|
|edgeFields|Fields to set in the edge (since v2.1)|object|false|<!-- PH -->|
|skipDuplicates|Duplicated edges are skipped. If `skipDuplicates:true` and a UNIQUE constraint is defined on both "out" and "in" properties in the edge's class, the ETL will ignore the duplicate with no exceptions|boolean|false|false|
|unresolvedLinkAction|Action to execute in case the JOIN hasn't been resolved. Actions can be: 'NOTHING' (do nothing), CREATE (create a OrientVertex setting as primary key the join value), WARNING (increment warnings), ERROR (increment errors), HALT (interrupt the process), SKIP (skip current row).|string|false|NOTHING|

#### Example 1
Create an EDGE from the current vertex, with class "Parent", to all the vertices returned by the lookup on "D.inode" index with the value contained in the field "inode_parent" of the input's vertex:
```json
{ "edge": { "class": "Parent", "joinFieldName": "inode_parent",
            "lookup":"D.inode", "unresolvedLinkAction":"CREATE"} }
```

#### Example 2: single line CSV contains both vertices and edge
```json
{
    "source": {
        "content": {
            "value": "id,name,surname,friendSince,friendId,friendName,friendSurname\n0,Jay,Miner,1996,1,Luca,Garulli"
        }
    },
    "extractor": {
        "row": {}
    },
    "transformers": [
        {
            "csv": {}
        },
        {
            "vertex": {
                "class": "V1"
            }
        },
        {
            "edge": {
                "unresolvedLinkAction": "CREATE",
                "class": "Friend",
                "joinFieldName": "friendId",
                "lookup": "V2.fid",
                "targetVertexFields": {
                    "name": "${input.friendName}",
                    "surname": "${input.friendSurname}"
                },
                "edgeFields": {
                    "since": "${input.friendSince}"
                }
            }
        },
        {
            "field": {
                "fieldNames": [
                    "friendSince",
                    "friendId",
                    "friendName",
                    "friendSurname"
                ],
                "operation": "remove"
            }
        }
    ],
    "loader": {
        "orientdb": {
            "dbURL": "memory:ETLBaseTest",
            "dbType": "graph",
            "useLightweightEdges": false
        }
    }
}
```
-----

### FLOW
Control the pipeline flow. Supported operations are "skip" and "halt". This transformer usually operates with the "if" attribute.

Component description.
- Component name: **flow**
- Supported inputs types: **Any**
- Output: same type as input

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|operation|Flow operation between: skip and halt|string|true|<!-- PH -->|

#### Example
Skip the current record if name is null:
```json
{ "flow": { "if": "name is null", "operation" : "skip" } }
```
-----


### CODE
Executes a snippet of code in any of the JVM supported languages. Default is Javascript. Last object in the code is returned as output. In the execution context, the following variables are bound:
- `input` with the input object received
- `record` with the record extracted from input object, when is possible. In case the input object is a Vertex/Edge, the underlying ODocument is assigned to the variable

Component description.
- Component name: **code**
- Supported inputs types: [**Object**]
- Output: **Object**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|-----------|-----------|
|language|Programming language used|string|false|Javascript|
|code|Code to execute|string|true|<!-- PH -->|

#### Example
Displays current record and returns the parent.
```json
{ "code": { "language": "Javascript",
            "code": "print('Current record: ' + record); record.field('parent');"}
}
```

-----

### LINK
Transform a JOIN value into a LINK in the current record, with the result of the lookup. Lookup can be a lookup against an index or a SELECT query.

Component description.
- Component name: **link**
- Supported inputs types: [**ODocument**, **OrientVertex**]
- Output: **ODocument**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|joinFieldName|Field name where the join value is saved|string|false|<!-- PH -->|
|joinValue|Value to lookup|string|false|-|
|linkFieldName|Field name containing the link to set|string|true|-|
|linkFieldType|Type of link between: LINK, LINKSET and LINKLIST|string|true|-|
|lookup|Can be the index name where to execute the lookup, or a SELECT query|string|true|-|
|unresolvedLinkAction|Action to execute in case the JOIN hasn't been resolved. Actions can be: 'NOTHING' (do nothing), CREATE (create a ODocument setting as primary key the join value), WARNING (increment warnings), ERROR (increment errors), HALT (interrupt the process), SKIP (skip current row).|string|false|NOTHING|

#### Example
Transform a JOIN value into a LINK in the current record (set as "parent" of type LINK) with the result of the lookup on index "D.inode" with the value contained in the field "inode_parent" of the input's document:
```json
{ "link": { "linkFieldName": "parent", "linkFieldType": "LINK",
            "joinFieldName": "inode_parent", "lookup":"D.inode", "unresolvedLinkAction":"CREATE"} }
```
-----


### LOG
Logs the input object to System.out.

Component description.
- Component name: **log**
- Supported inputs types: **Any**
- Output: **Any**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|prefix|Prefix to write before the content|string|false|<!-- PH -->|
|postfix|Postfix to write after the content|string|false|<!-- PH -->|

#### Example
Simply log current value:
```json
{ "log": {} }
```

Log current value with "-> " as prefix:
```json
{ "log": { "prefix" : "-> "} }
```

-----

### Block
Executes a [Block](Block.md) as a transformation step.

Component description.
- Component name: **block**
- Supported inputs types: [**Any**]
- Output: **Any**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|block|[Block](Block.md) to execute|document|true|<!-- PH -->|


#### Example
Simply log current value:
```json
{ "block": {
    "let": {
      "name": "id",
      "value": "={eval('$input.amount * 2')}"
    }
  }
}
```

### Command
Executes a command.

Component description.
- Component name: **command**
- Supported inputs types: [**ODocument**]
- Output: **ODocument**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|language|Command language. Available are: sql (default) and gremlin|string|false|sql|
|command|Command to execute|string|true|<!-- PH -->|


#### Example
```json
{
  "command" : {
    "command" : "select from E where id = ${edgeid}",
    "output" : "edge"
  }
}
```
-----
