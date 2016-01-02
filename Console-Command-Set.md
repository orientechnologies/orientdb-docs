# Console - `SET`

Changes the value of a property.

**Syntax**

```
SET <property-name> <property-value>
```

- **`<property-name>`** Defines the name of the property
- **`<property-value>`** Defines the value you want to change the property to.

**Example**

- Change the `LIMIT` property to one hundred:

  <pre>
  orientdb> <code class="lang-sql userinput">SET LIMIT 100</code>

  Previous value was: 20
  limit = 100
  </pre>

>To display all properties use the [`PROPERTIES`](Console-Command-Properties.md) command.  To display the value of a particular property, use the [`GET`](Console-Command-Get.md) command.
>
>For more information on other commands, see [Console Commands](Console-Commands.md).
