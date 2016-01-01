# Console - `INFO CLASS`

Displays all information on givne class.

**Syntax**

```
INFO CLASS <class-name>
```

- **`<class-name>`** Defines what class you want information on.


**Example**

- Display information on class `Profile`

  <pre>
  orientdb> <code class="lang-sql userinput">INFO CLASS Profile</code>

  Default cluster......: profile (id=10)
  Supported cluster ids: [10]
  Properties:
  --------+----+----------+-----------+---------+-----------+----------+-----+----
   NAME   | ID | TYPE     | LINK TYPE | INDEX   | MANDATORY | NOT NULL | MIN | MAX
  --------+----+----------+-----------+---------+-----------+----------+-----+----
   nick   |  3 | STRING   | null      |         | false     | false    | 3   | 30 
   name   |  2 | STRING   | null      |NOTUNIQUE| false     | false    | 3   | 30 
   surname|  1 | STRING   | null      |         | false     | false    | 3   | 30 
   ...    |    | ...      | ...       | ...     | ...       | ...      |...  | ...
   photo  |  0 | TRANSIENT| null      |         | false     | false    |     |    
  --------+----+----------+-----------+---------+-----------+----------+-----+----
  </pre>


>For more information on other commands, see [Console Commands](Console-Commands.md).
