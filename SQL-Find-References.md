# SQL - FIND REFERENCES

SQL command to search all records that contains a link to a given record id in the entire database or a subset of specified class and cluster. Returns a set of record ids.

# Syntax

```sql
FIND REFERENCES <rid|(<sub-query>)> [class-list]
```
Where:
- *rid* is the record id to search. If a sub-query is passed, then all the RIDs returned by the sub-query will be searched. Sub-query is available since 1.0rc9
- *class-list* list of specific class or cluster, separated by commas, you want to execute the search in.

Returns a list of document containing 2 fields:
- rid, as the original RID searched
- referredBy, as a Set of RIDs containing the collection of RID that reference the searched rid if any, otherwise the set is empty

# Examples

Get all the records that contains a link to 5:0

```sql
FIND REFERENCES 5:0
```

Result example:

```sql
RESULT:
+------+-----------------+
| rid  | referredBy      |
+------+-----------------+
| #5:0 | [#10:23, #30:4] |
+------+-----------------+
```

Get all the references to the record of the default cluster (available since 1.0rc9):

```sql
FIND REFERENCES (SELECT FROM CLUSTER:default)
```
Get all the records in Profile and !AnimalType classes that contains a link to 5:0 :

```sql
FIND REFERENCES 5:0 [Profile,AnimalType]
```

Get all the records in Profile cluster and !AnimalType class that contains a link to 5:0

```sql
FIND REFERENCES 5:0 [CLUSTER:Profile,AnimalType]
```

To know more about other SQL commands look at [SQL Commands](Commands.md).
