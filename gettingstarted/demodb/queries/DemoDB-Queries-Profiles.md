
### Profiles


#### Profiles - Example 1

{{ book.demodb_query_8_text }}:

In the _Browse Tab_ of [Studio](../studio/README.md), using the query below, this is the obtained list of records (only few records are shown in the image below):

<pre><code class="lang-sql">SELECT count(*) as NumberOfProfiles, Birthday.format('yyyy') AS YearOfBirth FROM Profiles GROUP BY YearOfBirth ORDER BY NumberOfProfiles DESC</code></pre>

![](../../../images/demo-dbs/social-travel-agency/query_8_browse.png)


#### Profiles - Example 2

{{ book.demodb_query_12_text }}:

In the _Graph Editor_ included in [Studio](../studio/README.md), using the query below, this is the obtained graph:

<pre><code class="lang-sql">SELECT *, @rid as Profile_RID, Name, Surname, (out('HasFriend').size() + in('HasFriend').size()) AS FriendsNumber FROM `Profiles` ORDER BY FriendsNumber DESC LIMIT 3</code></pre>

![](../../../images/demo-dbs/social-travel-agency/query_12_graph.png)

In the _Browse Tab_ of [Studio](../studio/README.md), using the query below, this is the obtained list of records:

<pre><code class="lang-sql">SELECT @rid as Profile_RID, Name, Surname, (out('HasFriend').size() + in('HasFriend').size()) AS FriendsNumber FROM `Profiles` ORDER BY FriendsNumber DESC LIMIT 3</code></pre>

![](../../../images/demo-dbs/social-travel-agency/query_12_browse.png)
