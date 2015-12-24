# Console - `GET`

Returns the value of the requested property.

**Syntax**

```
GET <property-name>
```

- **`<property-name>`** Defines the name of the property.

**Example**

- Find the default limit on your database:

  <pre>
  orientdb> <code class="lang-sql userinput">GET LIMIT</code>

  limit = 20
  </pre>


>To display all available properties configured on your database, use the [`PROPERTIES`](Console-Command-Properties.md) command.

>For more information on other commands, see [Console Commands](Console-Commands.md).
