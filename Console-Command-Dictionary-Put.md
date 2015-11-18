# Console - DISCTIONARY PUT

Associates in the database dictionary a record to a key to be found later using a [DICTIONARY GET](Console-Command-Dictionary-Get.md) command.

## Syntax

```
DICTIONARY PUT <key> <record-id>
```

Where:

- key            The key to bind
- record-id      The record-id of the record to bind to the key passes

## Example

```sql
DICTIONARY PUT obama 5:4
--------------------------------------------------
Class: Person   id: 5:4   v.1
--------------------------------------------------
              parent : null
            children : [Person@5:5{parent:Person@5:4,children:null,name:Malia Ann,surname:Obama,city:null}, Person@5:6{parent:Person@5:4,children:null
,name:Natasha,surname:Obama,city:null}]
                name : Barack
             surname : Obama
                city : City@-6:2{name:Honolulu}
--------------------------------------------------
The entry obama=5:4 has been inserted in the database dictionary
```

To know all the keys stored in the database dictionary use the [DICTIONARY KEYS](Console-Command-Dictionary-Keys.md) command.

For complete index (and dictionary) guide look at [Index guide](Indexes.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
