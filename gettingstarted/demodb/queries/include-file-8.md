Find all Locations connected to Customer with Id 1, and their Reviews (if any):

```sql
MATCH {class: Customers, as: c, where: (OrderedId=1)}--{class: Locations, as: loc}-HasReview-{class: Reviews, as: r, optional: true} 
RETURN $pathelements
```