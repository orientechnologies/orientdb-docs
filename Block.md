<!-- proofread 2015-12-11 SAM -->
# ETL - Blocks

**Block** components execute operations.

## Available Blocks

|[let](Block.md#row)|[code](Block.md#code)|[console](Block.md#console)|
|---|---|---|
|<!-- PH -->|<!-- PH -->|<!-- PH -->|

### let

Assigns a variable in the ETL process context.

- Component name: **let**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|name|Variable name. Any $ prefix is ignored|string|true|-|
|value|Fixed value to assign|any|false|-|
|expression|Expression in OrientDB SQL language, to evaluate and assign|string|false|-|

#### Example
Assign a value to the variable:

```json
{ "let": { "name": "$filePath",  "value": "/temp/myfile"} }
```

Concats the $fileName variable to $fileDirectory to create the new variable $filePath:

```json
{ "let": { "name": "$filePath",  "expression": "$fileDirectory.append( $fileName )"} }
```

### code

Execute a snippet of code in any of the JVM supported languages. Default is Javascript.

- Component name: **code**

#### Syntax
| Parameter | Description | Type| Mandatory | Default value |
|-----------|-------------|-----|-----------|-----------|
|language|Programming language used|string|false|Javascript|
|code|Code to execute|string|true|-|

#### Example

```json
{ "code": { "language": "Javascript",
            "code": "print('Hello World!');"}
}
```

### console

Execute commands invoking the [OrientDB Console](Console-Commands.md).

- Component name: **console**

#### Syntax
| Parameter | Description | Type | Mandatory | Default value |
|-----------|-------------|------|-----------|-----------|
|file|File path containing the commands to execute|string|false|-|
|commands|Array of commands, as string, to execute in sequence|string array|false|-|

#### Example

Invoke the console with a file containing the commands to execute
```json
{ "console": { "file": "/temp/commands.sql"}  }
```

```json
{ "console": {
    "commands": [
      "CONNECT plocal:/temp/db/mydb admin admin",
      "INSERT INTO Account set name = 'Luca'"
  ] }
}
```
