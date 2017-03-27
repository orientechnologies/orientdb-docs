
### Traverses

#### Example 1

```sql
TRAVERSE * FROM (
  SELECT FROM Profiles WHERE Name='Santo' and Surname='OrientDB'
) MAXDEPTH 3
```

![](../../../images/demo-dbs/social-travel-agency/traverse_1_browse.png)

![](../../../images/demo-dbs/social-travel-agency/traverse_1_graph.png)


#### Example 2

```sql
TRAVERSE * FROM (
  SELECT FROM Countries WHERE Name='Italy'
) MAXDEPTH 3
```

![](../../../images/demo-dbs/social-travel-agency/traverse_2_browse.png)

![](../../../images/demo-dbs/social-travel-agency/traverse_2_graph.png)
