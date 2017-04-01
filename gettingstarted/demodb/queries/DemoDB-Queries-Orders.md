
### Orders

#### Example 1

{{book.demodb_query_9_text}}:

<pre><code class="lang-sql">SELECT sum(Amount) AS TotalRevenuesFromOrders FROM Orders;</code></pre>

In the _Browse Tab_ of [Studio](../studio/README.md), using the query above, this is the visualized result:

![](../../../images/demo-dbs/social-travel-agency/query_9_browse.png)


#### Example 2

{{book.demodb_query_11_text}}:

<pre><code class="lang-sql">SELECT count(*) as OrdersCount, OrderDate.format('yyyy') AS OrderYear FROM Orders GROUP BY OrderYear ORDER BY OrdersCount DESC</code></pre>

In the _Browse Tab_ of [Studio](../studio/README.md), using the query above, this is the visualized result:

![](../../../images/demo-dbs/social-travel-agency/query_11_browse.png)

