
### Polymorphism 

#### Example 1

{{book.demodb_query_17_text}}:

<pre><code class="lang-sql">MATCH {class: Customers, as: customer, where: (OrderedId=1)}--{Class: Locations, as: location} 
{{book.demodb_query_17_return_graph}} 
</code></pre>

In the _Graph Editor_ included in [Studio](../studio/README.md), using '{{book.demodb_query_17_return_graph}}' as `RETURN` clause, this is the obtained graph:

![](../../../images/demo-dbs/social-travel-agency/query_17_graph.png)

In the _Browse Tab_ of [Studio](../studio/README.md), using '{{book.demodb_query_17_return_browse}}' as `RETURN` clause, this is the obtained list of records (only few records are shown in the image below):

![](../../../images/demo-dbs/social-travel-agency/query_17_browse.png)


#### Example 2

{% include "../../../general/include-demodb-query-file-1.md" %}
