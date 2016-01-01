# Console - `INDEXES`

Displays all indexes in the current database.

**Syntax**

```sql
INDEXES
```

**Example**

- Display indexes in the current database:

  <pre>
  orientdb {db=GratefulDeadConcerts}> <code class="lang-sql userinput">INDEXES</code>

  INDEXES
  --------------+------------+-------+--------+---------
   NAME         | TYPE       | CLASS | FIELDS | RECORDS 
  --------------+------------+-------+--------+---------
   dictionary   | DICTIONARY |       |        |       0 
   Group.Grp_Id | UNIQUE     | Group | Grp_Id |       1 
   ORole.name   | UNIQUE     | ORole | name   |       3 
   OUser.name   | UNIQUE     | OUser | name   |       4 
  --------------+------------+----------------+---------
   TOTAL = 4                                          8 
  ------------------------------------------------------
  </pre>


>For more information on other commands, see [Console Commands](Console-Commands.md).
