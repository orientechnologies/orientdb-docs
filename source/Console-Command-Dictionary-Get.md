# Console - DICTIONARY GET

Displays the value of the requested key loaded from the database dictionary.

## Syntax

```
DICTIONARY GET <key>
```

Where:

- key            The key to search

## Example

```sql
DICTIONARY GET obama
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
```

To know all the keys stored in the database dictionary use the [DICTIONARY KEYS](Console-Command-Dictionary-Keys.md) command.

For complete index (and dictionary) guide look at [Index guide](Indexes.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
