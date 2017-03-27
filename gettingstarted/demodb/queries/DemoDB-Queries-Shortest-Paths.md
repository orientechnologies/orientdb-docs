
### Shortest Path

#### Example 1
 
Find the shortest path between the Profile 'Santo' and the Country 'United States':

```sql
SELECT expand(path) FROM (
  SELECT shortestPath($from, $to) AS path 
  LET $from = (SELECT FROM Profiles WHERE Name='Santo' and Surname='OrientDB'), $to = (SELECT FROM Countries WHERE Name='United States') 
  UNWIND path
)
```

![](../../../images/demo-dbs/social-travel-agency/shortestpath_1_browse.png)

![](../../../images/demo-dbs/social-travel-agency/shortestpath_1_graph.png)

