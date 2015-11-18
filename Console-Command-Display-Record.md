# Console - DISPLAYS RECORD

Displays the details of the record of the last result set returned. This command needs the relative position of the record in the result set.

## Syntax

```sql
DISPLAY RECORD <number>
```

Where:

- number         The number of the record in the last result set

## Example

```sql
SELECT * FROM person

---+--------+--------------------+--------------------+--------------------+--------------------+--------------------
  #| REC ID |PARENT              |CHILDREN            |NAME                |SURNAME             |CITY
---+--------+--------------------+--------------------+--------------------+--------------------+--------------------
  0|     5:0|null                |null                |Giuseppe            |Garibaldi           |-6:0
  1|     5:1|5:0                 |null                |Napoleone           |Bonaparte           |-6:0
  2|     5:2|5:3                 |null                |Nicholas            |Churcill            |-6:1
  3|     5:3|5:2                 |null                |Winston             |Churcill            |-6:1
  4|     5:4|null                |[2]                 |Barack              |Obama               |-6:2
  5|     5:5|5:4                 |null                |Malia Ann           |Obama               |null
  6|     5:6|5:4                 |null                |Natasha             |Obama               |null
---+--------+--------------------+--------------------+--------------------+--------------------+--------------------
7 item(s) found. Query executed in 0.038 sec(s).

DISPLAY RECORD 4
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
