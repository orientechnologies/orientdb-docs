---
search:
   keywords: ['etl', 'ETL', 'transformer']
---

<!-- proofread 2015-12-11 SAM -->
# ETL Transformers

When OrientDB runs the ETL module, transformer components execute in a pipeline to modify the data before it gets loaded into the OrientDB database.  The operate on received input and return output.

Before execution, it always initalizes the `$input` variable, so that if you need to you can access it at run-time.

- [CSV](#csv-transformer)
- [FIELD](#field-transformer)
- [MERGE](#merge-transformer)
- [VERTEX](#vertex-transformer)
- [CODE](#code-transformer)
- [LINK](#link-transformer)
- [EDGE](#edge-transformer)
- [FLOW](#flow-transformer)
- [LOG](#flow-transformer)
- [BLOCK](#block-transformer)
- [COMMAND](#command-transformer)

## CSV Transformer

>Beginning with version 2.1.4, the CSV Transformer has been deprecated in favor of the [CSV Extractor](Extractor.md#csv-extractor).

Converts a string in a Document, parsing it as CSV

Component description.
- Component name: **csv**
- Supported inputs types: [**String**]
- Output: **ODocument**

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"separator"` | Defines the column separator. | char | | `,` |
| `"columnsOnFirstLine"` | Defines whether the first line contains column descriptions. | boolean | | `true` |
| `"columns"` | Defines array containing column names, you can define types by postfixing the names with `:<type>`. | string array | | |
| `"nullValue"` | Defines the value to interpret as null. | string | | |
| `"stringCharacter"` | Defines string character delimiter. | char | | `"` |
| `"skipFrom"` | Defines the line number to skip from. | integer | yes | |
| `"skipTo"` | Defines the line number to skip to. | integer | yes | |


>For the `"columns"` parameter, specifying type guarantees better performance.

**Example**

- Transform a row in CSV (as `ODocument` class), using commas as the separator, considering `NULL` as a null value and skipping rows two through four.

  ```json
  { "csv": { "separator": ",", "nullValue": "NULL",
             "skipFrom": 1, "skipTo": 3 } }
  ```

## Field Transformer

When the ETL module calls the Field Transformer, it executes an SQL transformer against the field.

Component description.
- Component name: **vertex**
- Supported inputs types: [**ODocument**]
- Output: **ODocument**

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"fieldName"` | Defines the document field name to use.  | string | | |
| `"expression"` | Defines the expression you want to evaluate, using OrientDB SQL. | string | yes | |
| `"value"` | Defines the value to set.  If the value is taken or computed at run-time, use `"expression"` instead. | any | | |
| `"operation"` | Defines the operation to execute against the fields: `SET` or `REMOVE`. | string | | `SET`|
| `"save"` | Defines whether to save the vertex, edge or document right after setting the fields. | boolean | | `false` |

>The `"fieldName"` parameter was introduced in version 2.1.

**Examples**

- Transform the field `class` into the `ODocument` class, by prefixing it with `_`:

  ```json
  { "field": 
    { "fieldName": "@class", 
	  "expression": "class.prefix('_')"
    } 
  }
  ```

- Apply the class name, based on the value of another field:

  ```json
  { "field": 
    { "fieldName": "@class", 
	  "expression": "if( ( fileCount >= 0 ), 'D', 'F')"
    }
  }
  ```

- Assign the last part of a path to the `name` field:

  ```json
  { "field": 
    { "fieldName": "name",
      "expression": "path.substring( eval( '$current.path.lastIndexOf(\"/\") + 1') )" 
    }
  }
  ```

- Asign the field a fixed value:

  ```json
  { "field": 
    { "fieldName": "counter", 
	  "value": 0
    }
  }
  ```

- Rename the field from `salary` to `renumeration`:


  ```json
  { "field": 
    { "fieldName": "remuneration", 
	  "expression": "salary"
    } 
  },
  { "field": 
    { "fieldName": "salary", 
	  "operation": "remove"
    } 
  }
  ```

- Rename multiple fields in one call. 

  ```json
  { "field": 
    { "fieldNames": 
	  [ "remuneration", "salary" ], 
	  "operation": "remove"
    } 
  }
  ```

  This feature was introduced in version 2.1.


## Merge Transformer

When the ETL module calls the Merge Transformer, it takes input from one `ODocument` instance to output into another, loaded by lookup.  THe lookup can either be a lookup against an index or a [`SELECT`](../sql/SQL-Query.md) query.

Component description.
- Component name: **merge**
- Supported inputs types: [**ODocument**, **OrientVertex**]
- Output: **ODocument**

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"joinFieldName"` | Defines the field containing the join value. | string | yes | |
| `"lookup"` | Defines the index on which to execute th elookup, or a [`SELECT`](../sql/SQL-Query.md) query. | string | yes | |
| `"unresolvedLinkAction"` | Defines the action to execute in the event that the join hasn't been resolved. | string | | `NOTHING` |

For the `"unresolvedLinkAction"` parameter, the supported actions are:

| Action | Description |
|---|---|
| `NOTHING` | Tells the transformer to do nothing. |
| `WARNING` | Tells the transformer to increment warnings. |
| `ERROR` | Tells the transformer to increment errors. |
| `HALT` | Tells the transformer to interrupt the process. |
| `SKIP` | Tells the transformer to skip the current row. |

**Example**

- Merge the current record against the record returned by the lookup on index `V.URI`, with the value contained in the field `URI` of the input document:

  ```json
  { "merge": 
    { "joinFieldName": "URI", 
	  "lookup":"V.URI" 
    } 
  }
  ```

## Vertex Transformer

When the ETL module runs the Vertex Transformer, it transforms `ODocument` input to output `OrientVertex`.

Component description.
- Component name: **vertex**
- Supported inputs types: [**ODocument**, **OrientVertex**]
- Output: **OrientVertex**

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"class"` | Defines the vertex class to use. | string | | `V` |
| `"skipDuplicates"` | Defines whether it skips duplicates.  When class has a `UNIQUE` constraint, ETL ignores duplicates.| boolean | | `false` |

>The `"skipDuplicates"` parameter was introduced in version 2.1.

**Example**

- Transform `ODocument` input into a vertex, setting the class value to the `$classname` variable:

  ```json
  { "vertex": 
    { "class": "$className", 
	  "skipDuplicates": true 
    } 
  }
  ```

## Edge Transformer

When the ETL modules calls the Edge Transformer, it converts join values in one or more edges between the current vertex and all vertices returned by the lookup.  The lookup can either be made against an index or a [`SELECT`](../sql/SQL-Query.md).

Component description.
- Component name: **EDGE**
- Supported inputs types: [**ODocument**, **OrientVertex**]
- Output: **OrientVertex**

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"joinFieldName"` | Defines the field containing the join value. | string | yes | |
| `"direction"` | Defines the edge direction. | string | | `out` |
| `"class"` | Defines the edge class. | string | | `E` |
| `"lookup"` | Defines the index on which to execute the lookup or a [`SELECT`](../sql/SQL-Query.md). | string | yes | |
| `"targetVertexFields"` | Defines the field on which to set the target vertex. | object | | |
| `"edgeFields"` | Defines the fields to set in th eedge. | object | | |
| `"skipDuplicates"` | Defines whether to skip duplicate edges when the `UNIQUE` constraint is set on both the `out` and `in` properties. | boolean | | `false` |
| `"unresolvedLinkAction"` | Defines the action to execute in the event that the join hasn't been resolved. | string | | `NOTHING`|

>The `"targetVertexFields"` andx `"edgeFields"` parameter were introduced in version 2.1.

For the `"unresolvedLinkAction"` parameter, the following actions are supported:

| Action | Description |
|---|---|
| `NOTHING` | Tells the transformer to do nothing. |
| `CREATE` | Tells the transformer to create an instance of `OrientVertex`, setting the primary key to the join value. |
| `WARNING` | Tells the transformer to increment warnings. |
| `ERROR` | Tells the transformer to increment errors. |
| `HALT` | Tells the transformer to interrupt the process. |
| `SKIP` | Tells the transformer to skup the current row. |

**Examples**

- Create an edge from the current vertex, with the class set to `Parent`, to all vertices returned by the lookup on the `D.inode` index with the value contained in the filed `inode_parent` of the input's vertex:

  ```json
  { "edge": 
    { "class": "Parent", 
	  "joinFieldName": "inode_parent",
      "lookup":"D.inode",    
	  "unresolvedLinkAction": "CREATE"
    } 
  }
  ```

- Transformer a single-line CSV that contains both vertices and edges:

  ```json
  { "source": 
    { "content": 
	  { "value": "id,name,surname,friendSince,friendId,friendName,friendSurname\n0,Jay,Miner,1996,1,Luca,Garulli"
      }
    },
    "extractor": 
	  { "row": {} },
    "transformers": 
	  [ 
	    { "csv": {} },
        { "vertex": 
		  { "class": "V1" }
        },
        { "edge": 
		  { "unresolvedLinkAction": "CREATE",
            "class": "Friend",
            "joinFieldName": "friendId",
            "lookup": "V2.fid",
            "targetVertexFields": 
			  { "name": "${input.friendName}",
                 "surname": "${input.friendSurname}"
              },
              "edgeFields": 
			    { "since": "${input.friendSince}" }
                }
          },
          { "field": 
		    { "fieldNames": 
			  [ "friendSince",
                "friendId",
                "friendName",
                "friendSurname"
              ],
              "operation": "remove"
            }
          }
        ],
        "loader": 
		  { "orientdb": 
		    { "dbURL": "memory:ETLBaseTest",
              "dbType": "graph",
              "useLightweightEdges": false
            }
        }
    }
  ```


## Flow Transformer

When the ETL module calls the Flow Transformer, it modifies the flow through the pipeline.  Supported operations are `skip` and `halt`.  Typically, this transformer operates with the `if` attribute.

Component description.
- Component name: **flow**
- Supported inputs types: **Any**
- Output: same type as input

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"operation"` | Defines the flow operation: `skip` or `halt`. | string | yes | |

**Example**

- Skip the current record if `name` is null:

  ```json
  { "flow": 
    { "if": "name is null", 
	  "operation" : "skip" 
    } 
  }
  ```

## Code Transformer

When the ETL module calls the Code Transformer, it executes a snippet of code in any JVM supported language.  The default is JavaScript.  The last object in the code is returned as output.

In the execution context:
- `input` The input object received.
- `record` The record extracted from the input object, when possible.  In the event that input object is a vertex or edge, it assigns the underlying `ODocument` to the variable.

Component description.
- Component name: **code**
- Supported inputs types: [**Object**]
- Output: **Object**

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|-----------|-----------|
| `"language"` | Defines the programming language to use. | string | | JavaScript |
| `"code"` | Defines the code to execute. | string | yes | |

**Example**

- Display the current record and return the parent:

  ```json
  { "code": 
    { "language": "Javascript",
      "code": "print('Current record: ' + record); record.field('parent');"
    }
  }
  ```
  
## Link Transformer

When the ETL module calls the Link Transformer, it converts join values into links within the current record, using the result of the lookup.  The lookup can be made against an index or a [`SELECT`](../sql/SQL-Query.md).

Component description.
- Component name: **link**
- Supported inputs types: [**ODocument**, **OrientVertex**]
- Output: **ODocument**

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"joinFieldName"` | Defines the field containing hte join value. | string | | |
| `"joinValue"` | Defines the value to look up. | string | | |
| `"linkFieldName"` | Defines the field containing the link to set. | string | yes | |
| `"linkFieldType"` | Defines the link type. | string | yes | |
| `"lookup"` | Defines the index on which to execute the lookup or a [`SELECT`](../sql/SQL-Query.md) query. | string | yes | |
| `"unresolvedLinkAction"` | Defines the action to execute in the event that the join doesn't resolve. | string | | `NOTHING`|

For the `"linkFieldType"` parameter, supported link types are: `LINK`, `LINKSET` and `LINKLIST`.

For the `"unresolvedLinkAction"` parameter the following actions are supported:

| Action | Description |
|---|---|
| `NOTHING` | Tells the transformer to do nothing. |
| `CREATE` | Tells the transformer to create an `ODocument` instance, setting the primary key as the join value. |
| `WARNING` | Tells the transformer to increment warnings. |
| `ERROR` | Tells the transformer to increment errors. |
| `HALT` | Tells the transformer to interrupt the process. |
| `SKIP` | Tells the transformer to skip the current row. |

**Example**

- Transform a JSON value into a link within the current record, set as `parent` of the type `LINK`, with the result of the lookup on the index `D.node` with the value contained in the field `inode_parent` on the input document.

  ```json
  { "link": 
    { "linkFieldName": "parent", 
	  "linkFieldType": "LINK",
      "joinFieldName": "inode_parent", 
	  "lookup":"D.inode",  
	  "unresolvedLinkAction":"CREATE"
    } 
  }
  ```

## Log Transformer

When the ETL module uses the Log Transformer, it logs the input object to `System.out`.

Component description.
- Component name: **log**
- Supported inputs types: **Any**
- Output: **Any**

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"prefix"` | Defines what it writes before the content. | string | | |
| `"postfix"` | Defines what it writes after the content. | string | | |

**Examples**

- Log the current value:

  ```json
  { "log": {} }
  ```

- Log the currnt value with `->` as the prefix:

  ```json
  { "log": 
    { "prefix" : "-> " } 
  }
  ```

## Block Transformer

When the ETL module calls the Block Transformer, it executes an ETL [Block](Block.md) component as a transformation step.

Component description.
- Component name: **block**
- Supported inputs types: [**Any**]
- Output: **Any**

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|`"block"` | Defines the block to execute. | document | yes | |

**Example**

- Log the current value:

  ```json
  { "block": 
    { "let": 
	  { "name": "id",
        "value": "={eval('$input.amount * 2')}"
      }
    }
  }
  ```

## Command Transformer

When the ETL module calls the Command Transformer, it executes the given command.

Component description.
- Component name: **command**
- Supported inputs types: [**ODocument**]
- Output: **ODocument**

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
| `"language"` | Defines the command language: SQL or Gremlin. | string | | `sql` |
| `"command"` | Defines the command to execute. | string | yes | |

**Example**

- Execute a [`SELECT`](../sql/SQL-Query.md) and output an edge:

  ```json
  { "command" : 
    { "command" : "SELECT FROM E WHERE id = ${input.edgeid}",
      "output" : "edge"
    }
  }
  ```
