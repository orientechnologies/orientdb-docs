
### Reviews 

#### Example 1

{{book.demodb_query_36_text}}:

```sql
SELECT Stars, count(*) as count FROM HasReview GROUP BY Stars ORDER BY count DESC
```


#### Example 2

{{book.demodb_query_37_text}}:

```sql
MATCH {class: Services, as: s}-HasReview->{class: Reviews, as: r} 
RETURN $pathelements
```


#### Example 3

{{book.demodb_query_38_text}}:

```sql
MATCH {class: Services, as: s}-HasReview->{class: Reviews, as: r}<-MadeReview-{class: Customers, as: c} 
RETURN $pathelements 
```


#### Example 4

{{book.demodb_query_39_text}}:

```sql
SELECT *, out("HasReview").size() AS ReviewNumbers FROM `Services` ORDER BY ReviewNumbers DESC 
```


#### Example 5

{% include "../../../general/include-demodb-query-file-1.md" %}


#### Example 6

{{book.demodb_query_30_text}}:

```sql
SELECT *, out("MadeReview").size() AS ReviewNumbers FROM `Customers` ORDER BY ReviewNumbers DESC LIMIT 3
```
 