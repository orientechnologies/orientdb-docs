<!-- proofread 2015-01-07 SAM -->

# Console - `DICTIONARY PUT`

Binds a record to a key in the dictionary database, making it accessible to the [`DICTIONARY GET`](Console-Command-Dictionary-Get.md) command.

**Syntax**

```
DICTIONARY PUT <key> <record-id>
```
- **`<key>`** Defines the key you want to bind.
- **`<record-id>`** Defines the ID for the record you want to bind to the key.


**Example**

- In the database dictionary of U.S. presidents, bind the record for Barack Obama to the key `obama`:

  <pre>
  orientdb> <code class="lang-sql userinput">DICTIONARY PUT obama 5:4</code>

  ------------------------------------------------------------------------
   Class: Person  id: 5:4  v.1
  ------------------------------------------------------------------------
      parent : null
    children : [Person@5:5{parent:Person@5:4,children:null,name:Malia Ann,
               surname:Obama,city:null}, Person@5:6{parent:Person@5:4,
               children:null,name:Natasha,surname:Obama,city:null}]
        name : Barack
     surname : Obama
        city : City@-6:2{name:Honolulu}
  ------------------------------------------------------------------------
  The entry obama=5:4 has been inserted in the database dictionary
  </pre>


>To see all the keys stored in the database dictionary, use the [`DICTIONARY KEYS`](Console-Command-Dictionary-Keys.md) command.  For more information on dictionaries and indexes, see [Indexes](Indexes.md).
>
>For more information on other commands, see [Console Commands](Console-Commands.md).
