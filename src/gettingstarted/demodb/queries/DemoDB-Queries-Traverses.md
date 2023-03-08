
# Traverses

## Example 1

Traverse everything from Profile 'Santo' up to depth three:

```sql
TRAVERSE * FROM (
  SELECT FROM Profiles WHERE Name='Santo' and Surname='OrientDB'
) MAXDEPTH 3
```

In the _Graph Editor_ included in [Studio](../../../studio/README.md), this is the obtained graph:
 
![](../../../images/demo-dbs/social-travel-agency/traverse_1_graph.png)

In the _Browse Tab_ of [Studio](../../../studio/README.md), this is the obtained list of records (only few records are shown in the image below):

![](../../../images/demo-dbs/social-travel-agency/traverse_1_browse.png)


## Example 2

Traverse everything from Country 'Italy' up to depth three:

```sql
TRAVERSE * FROM (
  SELECT FROM Countries WHERE Name='Italy'
) MAXDEPTH 3
```

In the _Graph Editor_ included in [Studio](../../../studio/README.md), this is the obtained graph:
 
![](../../../images/demo-dbs/social-travel-agency/traverse_2_graph.png)

In the _Browse Tab_ of [Studio](../../../studio/README.md), this is the obtained list of records (only few records are shown in the image below):

![](../../../images/demo-dbs/social-travel-agency/traverse_2_browse.png)


