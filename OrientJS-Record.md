# OrientJS Record API

Once you have initialized a database instance, you can fetch and manipulate records directly through their [Record ID's](Concepts.md#record-id). Unlike many Database API features, you don't need to initialize a record object in order to manipulate the data.   

>By convention, the variable on which you initialize the Database API is called `db`.  This designation is arbitrary and used only for convenience.


## Working with Records 

Methods tied to the Record API are accessible through the Database API: `db.record.<method>` and take Record ID's as an argument.

### Getting Records

Using the Record API, you can fetch records by their Record ID's using the `db.record.get()` method by their Record ID.  For instance,

```js
var rec = db.record.get('#1:1');
console.log('Loaded record: ', rec);
```

### Deleting Records

Using the Record API, you can delete records by their Record ID's using the `db.record.delete()` method.  For instance,

```js
db.record.delete('#1:1');
```
