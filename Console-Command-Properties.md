# Console - `PROPERTIES`

Displays all configured properties.

**Syntax**

```
PROPERTIES
```

**Example**

- List configured properties:

  <pre>
  orientdb> <code class='lang-sql userinput'>PROPERTIES</code>

  PROPERTIES:
  ------------------------+-----------
   NAME                   | VALUE
  ------------------------+-----------
   limit                  | 20 
   backupBufferSize       | 1048576
   backupCompressionLevel | 9      
   collectionMaxItems     | 10     
   verbose                | 2      
   width                  | 150    
   maxBinaryDisplay       | 150    
   debug                  | false  
   ignoreErrors           | false  
  ------------------------+-----------
  </pre>

>To change a property value, use the [`SET`](Console-Command-Set.md) command.
>
>For more information on other commands, see [Console Commands](Console-Commands.md).
