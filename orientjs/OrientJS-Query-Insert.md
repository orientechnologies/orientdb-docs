---
search:
   keywords: ['OrientJS', 'query', 'insert']
---

# OrientJS - `insert()`

Insertion queries in OrientJS are those that add records of a given class into the database.  The insertion query method is comparable to the [`INSERT`](../sql/SQL-Insert.md) commands on the OrientDB Console.

## Working with Insertion Queries

In OrientJS, inserting data into the database uses the `insert()` method.  For instance, say that you want to add batting averages, runs and runs batted in for Ty Cobb.


```js
db.insert().into('Player')
   .set({
     ba:  0.367,
     r:   2246,
     rbi: 1938
   }).where('name = "Ty Cobb"').one().then(function(player){
      console.log(player)
   });
```


## Raw Expressions

with set
```js
db.insert().into('Player')
   .set({
     uuid : db.rawExpression("format('%s',uuid())"),
     ba:  0.367,
     r:   2246,
     rbi: 1938
   }).where('name = "Ty Cobb"').one().then(function(player){
      console.log(player)
   });
```

Generated query

```sql
INSERT INTO Player SET uuid = format('%s',uuid()), ba = 0.367, r = 2246, rbi = 1938
```
