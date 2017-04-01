
### Shortest Path

#### Example 1
 
Find the shortest path between the Profile 'Santo' and the Country 'United States':

```sql
SELECT expand(path) FROM (
  SELECT shortestPath($from, $to) AS path 
  LET 
    $from = (SELECT FROM Profiles WHERE Name='Santo' and Surname='OrientDB'), 
    $to = (SELECT FROM Countries WHERE Name='United States') 
  UNWIND path
)
```

In the _Graph Editor_ included in [Studio](../studio/README.md), this is the obtained graph:
 
![](../../../images/demo-dbs/social-travel-agency/shortestpath_1_graph.png)

In the _Browse Tab_ of [Studio](../studio/README.md), this is the obtained list of records:

![](../../../images/demo-dbs/social-travel-agency/shortestpath_1_browse.png)

