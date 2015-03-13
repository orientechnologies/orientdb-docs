When planning an OrientDB [SELECT](SQL-Query.md) query, it is important to determine the model class that will be used as the pivot class of the query.  This class is expressed in the FROM clause. It affects other elements in the query as follows:
- projections will be relative to the pivot class. It is possible to traverse within a projection to refer to neighboring classes by chaining edge syntax expressions  (i.e. ```in[label='office'].out.out[label='office'].size()```). However, consider that multiple results from a projection traversed from the pivot class will be returned as a collection within the result set (unless there is only a single value).
- filtering conditions in the WHERE clause are also relative to the pivot class. It is also possible to traverse to neighboring classes in order to compose advanced conditions by using edge syntax expressions (e.g. ```and in[label='company'].out.out[label='employee'].in.id IN '0000345'```).
- the ORDER BY clause will be relative to one of the projections and must be returned as a single value per record (i.e. an attribute of the pivot class or a single attribute of a neighboring class). It will not be possible to order by traversed projections in a single query if they return multiple results (as a collection). Therefore, in queries using an ORDER BY clause, there is only one possible choice for the pivot class as it must be the class containing the attribute to order by.

Additionally, there are performance considerations that should be considered on selecting the pivot class. Assuming 2 classes as follows:

```
+--------------------+           +-------------------+
| Class: CountryType | --------> | Class: PersonType |
| attr: name         |           |  attr: name       |
| atr: code          |           |  attr: lat        |
|                    |           |  attr: long       |
+--------------------+           +-------------------+
  (tens of vertices)             (millions of vertices)
```

Queries:

```sql
 SELECT [...] FROM CountryType WHERE [...]

 SELECT [...] FROM PersonType WHERE [...]
```

The first query will apply the WHERE filtering and projections to fewer vertices, and as a result will perform faster that the second query. Therefore, it is advisable to assign the pivot class to the class that contains the most relevant items for the query to avoid unnecessary loops from the evaluation, i.e. usually the one with lower multiplicity.

# Switching the pivot class within a query

Based on the previous discussion, there may be conflicting requirements on determining the pivot class. Take the case where we need to ORDER BY a class with a very high multiplicity (say, millions of vertices), but most of these vertices are not relevant for the outcome of our query.

On one hand, according to the requirements of the ORDER BY clause, we are forced to choose the class containing the attribute to order by as the pivot class. But, as we also saw, this class can not be an optimal choice from a performance point of view if only a small subset of vertices is relevant to the query. In this case, we have a choice between poor performance resulting from setting the pivot class as the class containing the attribute to order by even though it has a higher multiplicity, or good performance by taking out the ORDER BY clause and ordering results after the fact in the invoking Java code, which is more work. If we choose to execute the full operation in one query, indices can be used to improve the poor performance, but it would be usually an overkill as a consequence of a bad query planning.

A more elegant solution can be achieved by using the nested query technique, as shown below:
```sql
SELECT                                                              -- outer query
  in[label='city'].out.name AS name,
  in[label='city'].out.out[label='city'].size() AS city_count,
  CityLat,
  CityLong,
  distance(CityLat, CityLong, 51.513363, -0.089178) AS distance     -- order by parameter
FROM (                                                              -- inner query
  SELECT flatten( in[label='region'].out.out[label='city'].in )
  FROM CountryType WHERE id IN '0032'
)
WHERE CityLat <> '' AND CityLong  <> ''
ORDER BY distance
```

This nested query represents a two-fold operation, taking the best of both worlds. The inner query uses the `CountryType` class which has lower multiplicity as pivot class, so the number of required loops is smaller, and as a result delivers better performance. The set of vertices resulting from the inner query is taken as pivot class for the outer query. The `flatten()` function is required to expose items from the inner query as a flat structure to the outer query. The higher the multiplicity and number of irrelevant records in the class with the parameter to order by, the more convenient using this approach becomes.