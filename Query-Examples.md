# Query Examples

This pages collects example of query from users. Feel free to add your own use case and query to help further users.

--------
How to ask the graph what relationships exist between two vertices? In my case I have two known 'Person' nodes each connected via a 'member_of' edge to a shared 'Organization' node. Each 'Person' is also a 'member_of' other 'Organization's.  

```sql
select intersect(out('member_of').org_name) from Person where name in ["nagu", "rohit"]
```

--------
