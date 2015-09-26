# SQL - TRUNCATE RECORD

The **Truncate Record** command truncates a record without loading it. Useful when the record is dirty in any way and can't be loaded correctly.

## Syntax

```
TRUNCATE RECORD <rid>*
```

Where:
- **rid** [RecordID](Concepts.md#recordid) to truncate. To truncate multiple records in one shot, list all the [RecordIDs](Concepts.md#recordid) separated by comma inside squared brackets.

### Returns

The number of records truncated.

## Examples

Truncates the record **#20:3**:
```java
TRUNCATE RECORD 20:3
```

Truncates 3 records all together:
```java
TRUNCATE RECORD [20:0, 20:1, 20:2]
```


See also [SQL Delete Command](SQL-Delete.md).

To know more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
