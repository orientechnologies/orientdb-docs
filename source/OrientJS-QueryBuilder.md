
### Query Builder: Insert Record

```js
db.insert().into('OUser').set({name: 'demo', password: 'demo', status: 'ACTIVE'}).one()
.then(function (user) {
  console.log('created', user);
});
```

### Query Builder: Update Record

```js
db.update('OUser').set({password: 'changed'}).where({name: 'demo'}).scalar()
.then(function (total) {
  console.log('updated', total, 'users');
});
```

### Query Builder: Delete Record

```js
db.delete().from('OUser').where({name: 'demo'}).limit(1).scalar()
.then(function (total) {
  console.log('deleted', total, 'users');
});
```


### Query Builder: Select Records

```js
db.select().from('OUser').where({status: 'ACTIVE'}).all()
.then(function (users) {
  console.log('active users', users);
});
```

### Query Builder: Text Search

```js
db.select().from('OUser').containsText({name: 'er'}).all()
.then(function (users) {
  console.log('found users', users);
});
```

### Query Builder: Select Records with Fetch Plan

```js
db.select().from('OUser').where({status: 'ACTIVE'}).fetch({role: 5}).all()
.then(function (users) {
  console.log('active users', users);
});
```

### Query Builder: Select an expression

```js
db.select('count(*)').from('OUser').where({status: 'ACTIVE'}).scalar()
.then(function (total) {
  console.log('total active users', total);
});
```

### Query Builder: Traverse Records

```js
db.traverse().from('OUser').where({name: 'guest'}).all()
.then(function (records) {
  console.log('found records', records);
});
```

### Query Builder: Return a specific column

```js
db
.select('name')
.from('OUser')
.where({status: 'ACTIVE'})
.column('name')
.all()
.then(function (names) {
  console.log('active user names', names.join(', '));
});
```


### Query Builder: Transform a field

```js
db
.select('name')
.from('OUser')
.where({status: 'ACTIVE'})
.transform({
  status: function (status) {
    return status.toLowerCase();
  }
})
.limit(1)
.one()
.then(function (user) {
  console.log('user status: ', user.status); // 'active'
});
```


### Query Builder: Transform a record

```js
db
.select('name')
.from('OUser')
.where({status: 'ACTIVE'})
.transform(function (record) {
  return new User(record);
})
.limit(1)
.one()
.then(function (user) {
  console.log('user is an instance of User?', (user instanceof User)); // true
});
```


### Query Builder: Specify default values

```js
db
.select('name')
.from('OUser')
.where({status: 'ACTIVE'})
.defaults({
  something: 123
})
.limit(1)
.one()
.then(function (user) {
  console.log(user.name, user.something);
});
```


### Query Builder: Put a map entry into a map

```js
db
.update('#1:1')
.put('mapProperty', {
  key: 'value',
  foo: 'bar'
})
.scalar()
.then(function (total) {
  console.log('updated', total, 'records');
});
```
