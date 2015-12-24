# Console - `EXPORT RECORD`

Exports the current record, using the requested format.  In the event that you give a format that OrientDB does not support, it provides a list of supported formats.

**Syntax**

```
EXPORT RECORD <format>
```

- **`<format>`** Defines the export format you want to use. 

**Examples**

- Use [`SELECT`](SQL-Query.md) to create a record for export:

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT name, surname, parent, children, city FROM Person WHERE 
            name='Barack' AND surname='Obama'</code>

  ---+-----+--------+---------+--------+------------+------
   # | RID | name   | surname | parent | children   | city
  ---+-----+--------+---------+--------+------------+------
   0 | 5:4 | Barack | Obama   | null   | [5:5, 5:6] | -6:2
  ---+-----+--------+---------+--------+------------+------
  </pre>

- Export JSON data from this record:

  <pre>
  orientdb> <code class="lang-sql userinput">EXPORT RECORD JSON</code>

  {
    'name': 'Barack',
    'surname': 'Obama',
    'parent': null,
    'children': [5:5, 5:6],
    'city': -6:2
  }
  </pre>

- Use a bad format value to determine what export formats are available on your database:

  <pre> 
  orientdb> <code class="lang-sql userinput">EXPORT RECORD GIBBERISH</code>

  ERROR: Format 'GIBBERISH' was not found.
  Supported formats are:
  - json
  - ORecordDocument2csv
  </pre>
 
>For more information on other commands, see [Console Commands](Console-Commands.md).
