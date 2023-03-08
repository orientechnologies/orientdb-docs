
# Attractions 

## Example 1 

Find all Attractions connected with Customer with OrderedId 1:

```sql
MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{Class: Attractions, as: attraction}
RETURN $pathelements
```

In the _Graph Editor_ included in [Studio](../../../studio/README.md), using _'RETURN $pathelements'_ as `RETURN` clause, this is the obtained graph:

![](../../../images/demo-dbs/social-travel-agency/query_15_graph.png)

In the _Browse Tab_ of [Studio](../../../studio/README.md), using _'RETURN attraction.@Rid as Attraction_RID, attraction.Name as Attraction_Name, attraction.Type as Attraction_Type'_ as `RETURN` clause, this is the obtained list of records (only few records are shown in the image below):

![](../../../images/demo-dbs/social-travel-agency/query_15_browse.png)
