# Console - CONFIG SET

Changes the value of a property.

## Syntax

```
CONFIG SET <config-name> <config-value>
```

Where:

- config-name  Name of the configuration to change
- config-value Value to set

## Example

```sql
CONFIG SET db.cache.enabled false

Remote configuration value changed correctly
```

## See also

To know all the configuration values use the [CONFIG](Console-Command-Config.md). To read a configuration value use the [CONFIG GET](Console-Command-Config-Get.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
