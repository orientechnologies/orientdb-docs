---
search:
   keywords: ['SQL', 'FIND REFERENCES', 'command', 'find', 'reference']
---

# SQL - `FIND REFERENCES`

Searches records in the database that contain links to the given Record ID in the database or a subset of the specified class and cluster, returning the matching Record ID's.

**Syntax**

```sql
FIND REFERENCES <record-id>|(<sub-query>) [class-list]
```

- **`<record-id>`** Defines the Record ID you want to find links to in the database.
- **`<sub-query>`** Defines a sub-query for the Record ID's you want to find links to in the database.  This feature was introduced in version 1.0rc9.
- **`<class-list>`** Defines a comma-separated list of classes or clusters that you want to search.

This command returns a document containing two fields:

| Field | Description |
|---|---|
| `rid` | Record ID searched. |
| `referredBy` | Set of Record ID's referenced by the Record ID searched, if any.  In the event that no records reference the searched Record ID, it returns an empty set. |


**Examples**

- Find records that contain a link to `#5:0`:

  <pre>
  orientdb> <code class="lang-sql userinput">FIND REFERENCES 5:0</code>

  RESULT:
  ------+-----------------
   rid  | referredBy      
  ------+-----------------
   #5:0 | [#10:23, #30:4] 
  ------+-----------------
  </pre>

- Find references to the default cluster record

  <pre>
  orientdb> <code class='lang-sql userinput'>FIND REFERENCES (SELECT FROM CLUSTER:default)</code>
  </pre>

- Find all records in the classes `Profile` and `AnimalType` that contain a link to `#5:0`:

  <pre>
  orientdb> <code class="lang-sql userinput"> FIND REFERENCES 5:0 [Profile, AnimalType]</code>
  </pre>

- Find all records in the cluster `profile` and class `AnimalType` that contain a link to `#5:0`:

  <pre>
  orientdb> <code class='lang-sql userinput'>FIND REFERENCES 5:0 [CLUSTER:profile, AnimalType]</code>
  </pre>


>For more information, see
>- [SQL Commands](SQL.md)