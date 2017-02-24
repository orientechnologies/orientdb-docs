---
search:
   keywords: ['etl', 'ETL', 'block']
---

<!-- proofread 2015-12-11 SAM -->
# ETL - Blocks

When OrientDB executes the ETL module, blocks in the ETL configuration define components to execute in the process. The ETL module in OrientDB supports the following types of blocks:

- [`"let"`](#let-blocks)
- [`"code"`](#code-blocks)
- [`"console"`](#console-blocks)

## Let Blocks

In a `"let"` block, you can define variables to the ETL process context.

- Component name: `let`

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|:-------:|-----------|
| `"name"` | Defines the variable name.  The ETL process ignores any values with the `$` prefix. |string| yes | |
| `"value"` | Defines the fixed value to assign. | an |  | |
| `"expression"` | Defines an expression in the OrientDB SQL language to evaluate and assign. | string | | |

**Examples**

- Assign a value to the file path variable

  ```json
  { 
    "let": { 
      "name": "$filePath",
	  "value": "/temp/myfile"
	} 
  }
  ```

- Concat the `$fileName` variable to the `$fileDirectory` to create a new variable for `$filePath`:

  ```json
  { 
     "let": { 
	    "name": "$filePath",  
		"expression": "$fileDirectory.append($fileName )"
     } 
  }
```

## Code Blocks

In the `"code"` block, you can configure code snippets to execute in any JVM-supported languages.  The default language is JavaScript.

- Component name: `code`

**Syntax**

| Parameter | Description | Type| Mandatory | Default value |
|-----------|-------------|-----|:---------:|-----------|
|`"language"` | Defines the programming language to use. | string | | Javascript |
| `"code"` | Defines the code to execute. | string | yes | |


**Examples**

- Execute a `Hello, World!` program in JavaScript, through the ETL module:

  ```json
  { 
     "code": { 
	    "language": "Javascript",
        "code": "print('Hello World!');"
     }
  }
  ```

## Console Blocks

In a `"console"` block, you can define commands OrientDB executes through the [Console](../console/Console-Commands.md).

- Component name: `console`

**Syntax**

| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|:--------:|-----------|
| `"file"` | Defines the path to a file containing the commands you want to execute.  | string | | |
|`"commands"` | Defines an array of commands, as strings, to execute in sequence. | string array | | |

**Example**

- Invoke the console with a file containing the commands:

  ```json
  { 
     "console": { 
	    "file": "/temp/commands.sql"
	 } 
   }
  ```

- Invoke the console with an array of commands:

  ```json
  { 
     "console": {
        "commands": [
           "CONNECT plocal:/temp/db/mydb admin admin",
           "INSERT INTO Account set name = 'Luca'"
        ]
	}
  }
  ```
