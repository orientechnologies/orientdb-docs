# Console - RELOAD RECORD

Reloads a record by its record-id from the current database ignoring the cache. This is useful when external applications change the record and you need to see latest update.

## Syntax

```
RELOAD RECORD <record-id>
```

Where:

- record-id      The unique Record Id of the record to reload. If you don't have the Record Id execute a query first

## Example

```sql
RELOAD RECORD 5:5

--------------------------------------------------
Class: Person   id: 5:5   v.0
--------------------------------------------------
              parent : Person@5:4{parent:null,children:[Person@5:5, Person@5:6],name:Barack,surname:Obama,city:City@-6:2}
            children : null
                name : Malia Ann
             surname : Obama
                city : null
--------------------------------------------------
```


This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
