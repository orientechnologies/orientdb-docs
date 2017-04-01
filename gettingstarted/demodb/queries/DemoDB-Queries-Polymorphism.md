
### Polymorphism 

#### Example 1

{{book.demodb_query_17_text}}:

<pre><code class="lang-sql">MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{Class: Locations, as: location} 
RETURN $pathelements
</code></pre>

In the _Graph Editor_ included in [Studio](../studio/README.md), using _'RETURN $pathelements'_ as `RETURN` clause, this is the obtained graph:

![](../../../images/demo-dbs/social-travel-agency/query_17_graph.png)

In the _Browse Tab_ of [Studio](../studio/README.md), using _'RETURN location.@Rid as Location_RID, location.Name as Location_Name, location.Type as Location_Type'_ as `RETURN` clause, this is the obtained list of records (only few records are shown in the image below):

![](../../../images/demo-dbs/social-travel-agency/query_17_browse.png)


#### Example 2

{% include "../../../general/include-demodb-query-file-1.md" %}
