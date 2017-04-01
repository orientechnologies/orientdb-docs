
### Locations 

#### Example 1 

Find all Attractions connected with Customer with OrderedId 1:

<pre><code class="lang-sql">MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{Class: Attractions, as: attraction}
RETURN $pathelements
</code></pre>

In the _Graph Editor_ included in [Studio](../studio/README.md), using _'RETURN $pathelements'_ as `RETURN` clause, this is the obtained graph:

![](../../../images/demo-dbs/social-travel-agency/query_15_graph.png)

In the _Browse Tab_ of [Studio](../studio/README.md), using _'RETURN attraction.@Rid as Attaction_RID, attraction.Name as Attaction_Name, attraction.Type as Attaction_Type'_ as `RETURN` clause, this is the obtained list of records (only few records are shown in the image below):

![](../../../images/demo-dbs/social-travel-agency/query_15_browse.png)


#### Example 2

Find all Services connected with Customer with OrderedId 1:

<pre><code class="lang-sql">MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{Class: Services, as: service}
RETURN $pathelements
</code></pre>

In the _Graph Editor_ included in [Studio](../studio/README.md), using _'RETURN $pathelements'_ as `RETURN` clause, this is the obtained graph:

![](../../../images/demo-dbs/social-travel-agency/query_16_graph.png)

In the _Browse Tab_ of [Studio](../studio/README.md), using _'RETURN service.@Rid as Service_RID, service.Name as Service_Name, service.Type as Service_Type'_ as `RETURN` clause, this is the obtained list of records (only few records are shown in the image below):

![](../../../images/demo-dbs/social-travel-agency/query_16_browse.png)


#### Example 3

Find all Locations connected to Customer with Id 1:


#### Example 4

Find all Locations connected to Customer with Id 1, and their Reviews (if any):


#### Example 5

Find all Locations visited by Customer with OrderedId 2:

<pre><code class="lang-sql">MATCH {Class: Locations, as: location}<-HasVisited-{class: Customers, as: customer, where: (OrderedId=2)}
RETURN $pathelements
</code></pre>

In the _Graph Editor_ included in [Studio](../studio/README.md), using _'RETURN $pathelements'_ as `RETURN` clause, this is the obtained graph:

![](../../../images/demo-dbs/social-travel-agency/query_18_graph.png)

In the _Browse Tab_ of [Studio](../studio/README.md), using _'RETURN location.@Rid as Location_RID, location.Name as Location_Name, location.Type as Location_Type'_ as `RETURN` clause, this is the obtained list of records (only few records are shown in the image below):

![](../../../images/demo-dbs/social-travel-agency/query_18_browse.png)


#### Example 6

Find all Locations visited by Santo's friends:

```sql
MATCH {Class: Profiles, as: profile, where: (Name='Santo' and Surname='OrientDB')}-HasFriend->{Class: Profiles, as: friend}<-HasProfile-{Class: Customers, as: customer}-HasVisited->{Class: Locations, as: location} 
RETURN $pathelements
```

