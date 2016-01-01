# Console - `LOAD RECORD`

Loads a record the given [Record ID](Concepts.md#record-id) from the current database.

**Syntax**

```sql
LOAD RECORD <record-id>
```

- **`<record-id`** Defines the Record ID of the record you want to load.

In the event that you don't have a Record ID, execute a query to find the one that you want.

**Example**

- Load the record for `#5:5`:

  <pre>
  orientdb> <code class="lang-sql userinput">LOAD RECORD #5:5</code>

  --------------------------------------------------------------------------------
   Class: Person   id: #5:5   v.0
  --------------------------------------------------------------------------------
     parent : Person@5:4{parent:null,children:[Person@5:5, Person@5:6],name:Barack,
              surname:Obama,city:City@-6:2}
   children : null
       name : Malia Ann
    surname : Obama
       city : null
  --------------------------------------------------------------------------------
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).
