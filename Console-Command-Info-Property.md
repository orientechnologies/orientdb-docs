# Console - `INFO PROPERTY`

Displays all information on the given property.

**Syntax**

```sql
INFO PROPERTY <class-name>.<property-name>
```

- **`<class-name>`** Defines the class to which the property belongs.
- **`<property-name>`** Defines the property you want information on.


**Example**

- Display information on the property `name` in the class `OUser`:

  <pre>
  orientdb> <code class='userinput lang-sql'>INFO PROPERTY OUser.name</code>

  PROPERTY 'OUser.name'

  Type.................: STRING
  Mandatory............: true
  Not null.............: true
  Read only............: false
  Default value........: null
  Minimum value........: null
  Maximum value........: null
  REGEXP...............: null
  Collate..............: {OCaseInsensitiveCollate : name = ci}
  Linked class.........: null
  Linked type..........: null

  INDEXES (1 altogether)
  --------------------+------------
   NAME               | PROPERTIES 
  --------------------+------------
   OUser.name         | name       
  --------------------+------------
  </pre>


>For more information on other commands, see [Console Commands](Console-Commands.md).


