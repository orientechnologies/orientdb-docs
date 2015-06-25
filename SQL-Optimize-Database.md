# SQL - OPTIMIZE DATABASE

The **OPTIMIZE DATABASE** command optimizes the database by using different ways. Today only the conversion of regular edges to [Lightweight edges](Lightweight-Edges) is supported. This command will be improved in the future with new modes.

## Syntax

```sql
OPTIMIZE DATABASE [-lwedges]
```

Where:
- **-lwedges** converts regular edges into [Lightweight edges](Lightweight-Edges).

## See also
- [SQL commands](SQL.md)
- [Console commands](Console-Commands.md)

## Examples

Converts all regular edges into [Lightweight edges](Lightweight-Edges). 
```sql
OPTIMIZE DATABASE -lwedges
```
