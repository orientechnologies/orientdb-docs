# SQL - EXPLAIN

Profiles any command and returns back result of execution. This is useful to know why a query is slow. Use EXPLAIN as keyword before the command you want to profile.

# Syntax

```
EXPLAIN <command>
```

- **command** is the command you want to profile.

Returns a document containing all the profiled metrics:
<table><tbody>
  <tr><th>Metric</th><th>Description</th></tr>
  <tr><td>elapsed</td><td>Time elapsed in seconds to execute the command. The precision is nanosecond</td></tr>
  <tr><td>resultType</td><td>The result type. Can be 'collection', 'document' or 'number'</td></tr>
  <tr><td>resultSize</td><td>The number of record retrieved in case the resultType is a 'collection'</td></tr>
  <tr><td>recordReads</td><td>The number of records read from disk</td></tr>
  <tr><td>documentReads</td><td>The number of documents read from disk. It could be different by recordReads if other kind of records are present in the target of the command. For example if you put in the same cluster documents and recordbytes you could skip many records. Much better to store different records in separate clusters in case of scan</td></tr>
  <tr><td>documentAnalyzedCompatibleClass</td><td>The number of documents analyzed of the requested class of the query. It could be different by documentReads if records of different classes are present in the target of the command. For example if you put in the same cluster documents of class "Account" and "Invoice" you could skip many records of type "Invoice" if your're looking for Account instances. Much better to store records of different classes in separate clusters in case of scan</td></tr>
  <tr><td>involvedIndexes</td><td>The indexes involved in the command</td></tr>
  <tr><td>indexReads</td><td>The number of records read from the index</td></tr>
</tbody></table>


# Examples

## Non indexed query

```sql
EXPLAIN SELECT FROM account

Profiled command
'{documentReads:1126,documentReadsCompatibleClass:1126,recordReads:1126,elapsed:209,resultType:collection,resultSize:1126}' in 0,212000 sec(s).
```
## Indexed query

```sql
EXPLAIN SELECT FROM profile WHERE name = 'Luca'

Profiled command '{involvedIndexes:[1],indexReads:1,documentAnalyzedCompatibleClass:1,elapsed:1,resultType:collection,resultSize:1}' in 0,002000 sec(s).
```

To know more about other SQL commands look at [SQL commands](SQL.md).
