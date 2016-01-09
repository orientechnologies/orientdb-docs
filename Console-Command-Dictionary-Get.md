<!-- proofread 2015-01-07 SAM -->

# Console - `DICTIONARY GET`

Displays the value of the requested key, loaded from the database dictionary.

**Syntax**

```sql
DICTIONARY GET <key>
```

- **`<key>`** Defines the key you want to access.


**Example**

- In a dictionary of U.S. presidents, display the entry for Barack Obama:

  <pre>
  orientdb> <code class='lang-sql userinput'>DICTIONARY GET obama</code>

  -------------------------------------------------------------------------
  Class: Person id: 5:4 v.1
  -------------------------------------------------------------------------
      parent: null
   children : [Person@5:5{parent:Person@5:4,children:null,name:Malia Ann,
              surname:Obama,city:null}, Person@5:6{parent:Person@5:4,
              children:null,name:Natasha,surname:Obama,city:null}]
       name : Barack
    surname : Obama
       city : City@-6:2{name:Honolulu}
  -------------------------------------------------------------------------
  </pre>

>You can display all keys stored in a database using the [`DICTIONARY KEYS`](Console-Command-Dictionary-Keys.md) command. For more information on indexes, see [Indexes](Indexes.md).

>For more information on other commands, see [Console Commands](Console-Commands.md).
