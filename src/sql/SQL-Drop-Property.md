
# SQL - `DROP PROPERTY`

Removes a property from the schema.  Does not remove the property values in the records, it just changes the schema information.  Records continue to have the property values, if any.

**Syntax**

```sql
DROP PROPERTY <class>.<property> [FORCE]
```

- **`<class>`** Defines the class where the property exists.
- **`<property>`** Defines the property you want to remove.
- **FORCE** In case one or more indexes are defined on the property, the command will throw an exception. Use FORCE to drop indexes together with the property

**Examples**

- Remove the `name` property from the class `User`:

  <pre>
  orientdb> <code class="lang-sql userinput">DROP PROPERTY User.name</code>
  </pre>


>For more information, see
>- [`CREATE PROPERTY`](SQL-Create-Property.md)
>- [SQL Commands](SQL-Commands.md)
>- [Console Commands](../console/Console-Commands.md)
