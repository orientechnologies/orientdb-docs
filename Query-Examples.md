# Query Examples

This pages collects example of query from users. Feel free to add your own use case and query to help further users.

--------
How to ask the graph what relationships exist between two vertices? In my case I have two known 'Person' nodes each connected via a 'member_of' edge to a shared 'Organization' node. Each 'Person' is also a 'member_of' other 'Organization's.  

```sql
select intersect(out('member_of').org_name) from
 Person where name in ["nagu", "rohit"]
```

--------
This example shows how to form where clause in order to query/ filter based on properties of connected vertices.

DocElem and Model are subclasses of V and hasModel of E.

```sql
    insert into DocElem set uri = 'domain.tdl', type = "paragraph"
    insert into Model set hash = '0e1f', model = "hello world"
    create edge hasModel from #12:2738 to #13:2658
```

User wishes to query those vertices filtering on certain properties of DocElem and Model.

To fetch the Model vertices where DocElem.type = "paragraph" and connected vertex Model has the property model like '%world%'

```sql
    select from (select expand(out('hasModel')) from DocElem where type = "paragraph") where model like "%world%"
```

To find instead the DocElem vertices, use this (assuming that a DocElem is only connected to one Model):

```sql
    select * from DocElem where type = "paragraph" and out('hasModel')[0].model like '%world%'
```

--------