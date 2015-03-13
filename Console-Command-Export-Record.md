# Console - EXPORT RECORD

This command exports the current record in the format requested. The format must be between the supported ones. In case of error the supported format list will be displayed.

## Syntax

```
export record <format>
```

## Example

```java
> export record json
{
  'parent': null,
  'children': [5:5, 5:6],
  'name': 'Barack',
  'surname': 'Obama',
  'city': -6:2
}
```


This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
