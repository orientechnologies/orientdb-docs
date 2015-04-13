# Pattern Matching Proposal

## Use Cases

1. find a specific type of node or relationship at variable depth

2. find a specific type of node or relationship at variable depth, and following a specific type of relationship or node1

3. retrive one or more nodes/relationships from a specific point in a path

4. retrieve one or more nodes/relationship ordering by or filtering by one or more atributes in a path.

5. retrieve one or more value as a result of an aggregation of attributes on nodes/relationship of a specific path.


## Proposal

Til now we got two main proposal, that can be merged together but i'll keep them separate for sake of brainstorming.

1. a select based query where the 'where' clause is replaced by a 'match' clause that can be used for filter and declare return 'variable'

2. a match query where for each step of the path can be declared a activity block where can be added condition,operation,variable declaration


## Use Case Apply

### Use case 1

#### Prop 1
``` select B from V as A match A.[2..3]out() as B ```
#### Prop 2
``` match V.[2..3]out(){#alias:A}  return A ```

### Use Case 2

#### Prop 1
``` select B from V as A match A.[2..3]out('friend') as B ```
#### Prop 2
``` match V.[2..3]out('friend'){#alias:A} return A```

### Use Case 3

#### Prop 1
``` select B from V as A match A.out('friend') as B and B.out('live').name ='rome' ```
#### Prop 2
``` match V.[2..3]out('friend'){#alias:A}.out('live').name = 'rome' return A```


### Use Case 4

#### Prop 1
``` select B from V as A match A.out('friend') as B and B.out('live').name ='rome' and B.name='jonh' and A.outE('friend') as C and C.since > 1999 order by C.since ```
In this case i have to explain an additional thing, the match key have to change the behaviour of the out/in functions and merge the condtion on the paths 
for example the `A.out('friend') as B` declare as B only the friend where the edge match `A.outE('friend').since  > 1999 `

the order by query is weird as well because we return B and not A, but i think is possible to be implemented

#### Prop 2
``` match V.[2..3]out('friend'){#alias:A, #cond:'since > 1999', #orderBy:'since'}.out('live').name = 'rome' return A```
that look easier in this case


### Use Case 5

#### Prop 1

``` select avg(B.salary) from V as A match A.out('friend') as B and B.out('live').name ='rome' and B.name='jonh' and A.outE('friend') as C and C.since > 1999 order by C.since ```

#### Prop 2

``` match V.[2..3]out('friend'){#alias:A, #cond:'since > 1999', #orderBy:'since',#apply:'avg(in().salary)'}.out('live').name = 'rome' return A```

