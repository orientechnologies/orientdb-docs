---
search:
   keywords: ['OrientJS', 'transactions']
---

# Transactions in OrientJS

Rather than writing out SQL commands to manage transactions, you can use the OrientJS Transaction Builder to construction transactions using a series of methods connected through the Database API.


## Working with the Transaction Builder

Transactions are built through a string of `let()` methods.  With each, define functions that execute commands on the database.  When the operation is complete, call the `commit()` method to commit your changes to the database.

Methods used in transactions include,

- **`let()`** Method takes as arguments a name and a function that defines one operation in the transaction.  You can reference the name elsewhere in the transaction using the `$` symbol, (for instance, `$name`).
- **`commit()`** Method commits the transaction to the database.
- **`return()`** Method defines the transaction return value.

For instance, this transaction adds vertices for Ty Cobb and the Detroit Tigers to the database, then defines an edge for the years in which Cobb played for the Tigers.

```js
var trx = db.let('player', function(p){
      p.create('vertex', 'Player')
         .set({
            name:      'Ty Cobb',
            birthDate: '1886-12-18',
            deathDate: '1961-7-17',
            batted:    'left',
            threw:     'right'
         })
   })
   .let('team', function(t){
      t.create('vertex', 'Team')
         .set({
            name: 'Tigers',
            city: 'Detroit',
            state: 'Michigan'
         })
   })
   .let('career', function(c){
      c.create('edge', 'playsFor')
         .from('$player')
         .to('$team')
         .set({
            startYear: '1905',
            endYear:   '1926'
         })
   })
   .commit().return('$edge').all()
   .then(
      function(results){
         console.log(results);
      }
    );
```

## Working with Batch Scripts

In addition to the standard transactions, you can also execute raw batch scripts, without using the transaction builder.  These are the equivalent of [SQL Batch](SQL-batch.md) scripting in the OrientDB Console.

```js
db.query('begin;'
   + 'let $t0 = SELECT FROM V LIMIT 1;'
   + 'return $t0'
   ,{class: 's'}).then(function(res){
      console.log(res);
   });

```
