# Console - DISPLAYS RECORD

Displays details on the given record from the last returned result-set. 

**Syntax**

```sql
DISPLAY RECORD <record-number>
```

- **`<record-number>`** Defines the relative position of the record in the last result-set.

**Example**

- Query the database on the class `Person` to generate a result-set:

  <pre>
  orientdb> <code class='lang-sql userinput'>SELECT FROM Person</code>

  ---+-----+--------+----------+-----------+-----------+------
   # | RID | PARENT | CHILDREN | NAME      | SURNAME   | City
  ---+-----+--------+----------+-----------+-----------+------
   0 | 5:0 | null   | null     | Giuseppe  | Garibaldi | -6:0
   1 | 5:1 | 5:0    | null     | Napoleon  | Bonaparte | -6:0
   2 | 5:2 | 5:3    | null     | Nicholas  | Churchill | -6:1
   3 | 5:3 | 5:2    | null     | Winston   | Churchill | -6:1
   4 | 5:4 | null   | [2]      | Barack    | Obama     | -6:2
   5 | 5:5 | 5:4    | null     | Malia Ann | Obama     | null
   6 | 5:6 | 5:4    | null     | Natasha   | Obama     | null
  ---+-----+--------+----------+-----------+-----------+------
  7 item(s) found. Query executed in 0.038 sec(s).
  </pre>

- With the result-set ready, display record number four in the result-set, (for Malia Ann Obama):

  <pre>
  orientdb> <code class='lang-sql userinput'>DISPLAY RECORD 5</code>

  ------------------------------------------------------------------------
  Class: Person   id: 5:5   v.0
  ------------------------------------------------------------------------
    parent : Person@5:4{parent:null,children:[Person@5:5, Person@5:6],
             name:Barack,surname:Obama,city:City@-6:2}
   children : null
       name : Malia Ann
    surname : Obama
        city : null
  ------------------------------------------------------------------------
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).
