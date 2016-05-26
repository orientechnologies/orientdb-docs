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

### Creating Raw Binary Records

There are several methods available to you in creating records on the database.  Using the Record API, you can create records through raw binary data, writing directly into OrientDB.  For instance,

```js
// Initialize Buffer
var binary_data = new Buffer(...);

// Define Type and Cluster
binary_data['@type'] = 'b';
binary_data['@class'] = 'Player';

// Create Record
var data = db.record.create(binary_data);
console.log('Created Record ID: ', binary_data['@rid']);
```

Here, you initialize the `binary_data` variable as a new `Buffer()` instance.  Then you set the type and cluster on which it's stored, (`@class` in this case refers to the cluster).  Finally, you create the record in OrientDB, printing its Record ID to the console.
