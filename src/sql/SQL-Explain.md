
# SQL - `EXPLAIN`

EXPLAIN SQL command returns information about query execution planning of a specific statement, without executing the statement itself.

**Syntax**

```
EXPLAIN <command>
```

- **`<command>`** Defines the command that you want to profile, eg. a SELECT statement

**Examples**


- Profile a query that executes on a class filtering based on an attribute:

  <pre>
  orientdb {db=foo}> <code class='lang-sql userinput'>explain select from v where name = 'a'</code>

  Profiled command '[{

  executionPlan:{...},

  executionPlanAsString:

  + FETCH FROM CLASS v
    + FETCH FROM CLUSTER 9 ASC
    + FETCH FROM CLUSTER 10 ASC
    + FETCH FROM CLUSTER 11 ASC
    + FETCH FROM CLUSTER 12 ASC
    + FETCH FROM CLUSTER 13 ASC
    + FETCH FROM CLUSTER 14 ASC
    + FETCH FROM CLUSTER 15 ASC
    + FETCH FROM CLUSTER 16 ASC
    + FETCH NEW RECORDS FROM CURRENT TRANSACTION SCOPE (if any)
  + FILTER ITEMS WHERE 
    name = 'a'
  
  }]' in 0,022000 sec(s):

  </pre>

>For more information, see
>- [SQL Commands](SQL-Commands.md)
>- [PROFILE](SQL-Profile.md)




