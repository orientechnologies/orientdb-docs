# Console - LOAD RECORD

Loads a record by its record-id from the current database.

## Syntax

```
LOAD RECORD <record-id>
```

Where:

- record-id      The unique [Record Id](Concepts.md#RecordID) of the record to load. If you don't have the Record Id execute a query first

## Example

```sql
LOAD RECORD #5:5

--------------------------------------------------
Class: Person   id: #5:5   v.0
--------------------------------------------------
              parent : Person@5:4{parent:null,children:[Person@5:5, Person@5:6],name:Barack,surname:Obama,city:City@-6:2}
            children : null
                name : Malia Ann
             surname : Obama
                city : null
--------------------------------------------------
```


This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
