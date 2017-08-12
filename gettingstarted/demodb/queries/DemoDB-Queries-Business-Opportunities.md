
# Business-Opportunities 

## Example 1

{% include "./include-file-1.md" %}


## Example 2

Find all the Customer Friends that are not Customers (so that a product can be proposed):

In the _Graph Editor_ included in [Studio](../../../studio/README.md), using the query below, this is the obtained graph:

```sql
SELECT * FROM (
  SELECT expand(customerFriend) 
  FROM ( 
    MATCH 
      {Class:Customers, as: customer}-HasProfile-{Class:Profiles, as: profile}-HasFriend-{Class:Profiles, as: customerFriend} 
    RETURN customerFriend
  )
) 
WHERE in('HasProfile').size()=0"
```

![](../../../images/demo-dbs/social-travel-agency/query_14_graph.png)

In the _Browse Tab_ of [Studio](../../../studio/README.md), using the query below, this is the obtained list of records (only few records are shown in the image below):

<pre><code class="lang-sql">SELECT @Rid as Friend_RID, Name as Friend_Name, Surname as Friend_Surname 
FROM (
  SELECT expand(customerFriend) 
  FROM (
    MATCH 
      {Class:Customers, as: customer}-HasProfile-{Class:Profiles, as: profile}-HasFriend-{Class:Profiles, as: customerFriend} 
    RETURN customerFriend
  )
) 
WHERE in('HasProfile').size()=0"</code></pre>

![](../../../images/demo-dbs/social-travel-agency/query_14_browse.png)

 
	