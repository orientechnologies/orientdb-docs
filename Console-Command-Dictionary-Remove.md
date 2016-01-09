<!-- proofread 2015-01-07 SAM -->

# Console - `DICTIONARY REMOVE`

Removes the association from the database dictionary.

**Syntax**

```
DICTIONARY REMOVE <key>
```

- **`<key>`** Defines the key that you want to remove.

**Example**

- In a database dictionary of U.S. presidents, remove the key for Barack Obama:

  <pre>
  orientdb> <code class="lang-sql userinput">DICTIONARY REMOVE obama</code>

  Entry removed from the dictionary. Last value of entry was:
  ------------------------------------------------------------------------
  Class: Person   id: 5:4   v.1
  ------------------------------------------------------------------------
     parent : null
   children : [Person@5:5{parent:Person@5:4,children:null,name:Malia Ann,
              surname:Obama,city:null}, Person@5:6{parent:Person@5:4,
              children:null,name:Natasha,surname:Obama,city:null}]
       name : Barack
    surname : Obama
       city : City@-6:2{name:Honolulu}
  ------------------------------------------------------------------------
  </pre>


>You can display information for all keys stored in the database dictionary using the [`DICTIONARY KEY`](Console-Command-Dictionary-Keys.md) command.  For more information on dictionaries and indexes, see [Indexes](Indexes.md).
>
>For more information on other commands, see [Console Commands](Console-Commands.md).
