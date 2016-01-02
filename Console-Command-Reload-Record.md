# Console - `RELOAD RECORD`

Reloads a record from the current database by its Record ID, ignoring the cache.

You may find this command useful in cases where external applications change the record and you need to see the latest update.

**Syntax**

```
RELOAD RECORD <record-id>
```

- **`<record-id>`** Defines the unique Record ID for the record you want to reload.  If you don't have the Record ID, execute a query first.

**Examples**

- Reload record with the ID of `5:5`:

  <pre>
  orientdb> <code class='lang-sql userinput'>RELOAD RECORD 5:5</code>

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
