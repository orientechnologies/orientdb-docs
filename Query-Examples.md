---
search:
   keywords: ['troubleshooting', 'query', 'queries', 'query example']
---

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
    select from (select expand(out('hasModel')) from DocElem where 
      type = "paragraph") where model like "%world%"
```

To find instead the DocElem vertices, use this (assuming that a DocElem is only connected to one Model):

```sql
    select * from DocElem where type = "paragraph" and 
      out('hasModel')[0].model like '%world%'
```

--------
How to apply built-in math functions on projections? For example, to use the sum() function over 2 values returned from sub-queries using projections, the following syntax may be used:

```sql
  select sum($a[0].count,$b[0].count) 
    let $a = (select count(*) from e), 
        $b = (select count(*) from v)
```

--------

Given the following schema: Vertices are connected with Edges of type _RELATED_ which have property _count_.
2 vertices can have connection in both ways at the same time.

V1--RELATED(count=17)-->V2

V2--RELATED(count=3)-->V1

Need to build a query that, for a given vertex _Vn_, will find all vertices connected with _RELATED_ edge to this _Vn_ and also, for each pair _[Vn, Vx]_ will calculate _SUM_ of _in_RELATED.count_ and _out_RELATED.count_.

For that simple example above, this query result for V1 would be

|  Vertex   |    Count    |
|-----------|-------------|
|    V2     |      20     |


Solution:

```sql 

insert into V (name) values ('V1'),('V2')
create edge E from (select from V where name = 'V1') to (select from V where name = 'V2') set count = 17
create edge E from (select from V where name = 'V2') to (select from V where name = 'V1') set count = 3

select v.name, sum(count) as cnt from (
  select if(eval("in=#9:0"),out,in) as v,count from E where (
    in=#9:0 or out=#9:0)
  ) group by v order by cnt desc     
```

(replace `#9:0` in the select statement to fit your specific case).

This was discussed in the google groups over here: "https://groups.google.com/forum/#!topic/orient-database/CRR-simpmLg". Thanks to Andrey for posing the problem.

--------
