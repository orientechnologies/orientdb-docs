# SQL - `EXPLAIN`

Profiles any command and returns a JSON data on the result of its execution.  You may find this useful to see why queries are running slow.  Use it as a keyword before any command that you want to profile.

**Syntax**

```
EXPLAIN <command>
```

- **`<command>`** Defines the command that you want to profile.

**Examples**

- Profile a query that executes on a class without indexes:

  <pre>
  orientdb> <code class='lang-sql userinput'>EXPLAIN SELECT FROM Account</code>

  Profiled command '{documentReads:1126, documentReadsCompatibleClass:1126, 
  recordReads:1126, elapsed:209, resultType:collection, resultSize:1126}' 
  in 0,212000 sec(s).
  </pre>

- Profile a query that executes on a class with indexes:

  <pre>
  orientdb> <code class='lang-sql userinput'>EXPLAIN SELECT FROM Profile WHERE name = 'Luca'</code>

  Profiled command '{involvedIndexes:[1], indexReads:1, resultType:collection
  resultSize:1, documentAnalyzedCompatibleClass:1, elapsed:1}' 
  in 0,002000 sec(s).
  </pre>

>For more information,s ee
>- [SQL Commands](SQL.md)


## Understanding the Profile

When you run this command, it returns JSON data containing all of the following profile metrics:

| Metric | Description |
|---|---|
| `elapsed` | Time to execute in seconds.  The precision is the nanosecond.|
| `resultType` |  The result-type: `collection`, `document`, or `number`.|
| `resultSize` | Number of records retrieved, in cases where the result-type is `collection`.|
| `recordReads` | Number of records read from disk.|
| `documentReads` | Number of documents read from disk.  This metric may differ from `recordReads` in the event that other kinds of records are present in the command target.  For instance, if you have documents and recordbytes in the same cluster it may skip many records.  That said, in case of scans, it is recommended that you store different records in separate clusters.|
| `documentAnalyzedCompatibleClass` | Number of documents analyzed in the class.  For instance, if you use the same cluster in documents for the classes `Account` and `Invoice`, it would skip records of the class `Invoice` when you target the class `Account`.  In case of scans, it is recommended that you store different classes in separate clusters.|
| `involvedIndexes` | Indexes involved in the command.|
| `indexReads` | Number of records read from the index.|


