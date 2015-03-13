# SQL - INSERT


The **Insert** command creates a new record in the database. Records can be schema-less or conform to rules you specify in your model.

## Syntax

```sql
INSERT INTO [class:]<class>|cluster:<cluster>|index:<index>
  [(<field>[,]*) VALUES (<expression>[,]*)[,]*]|
  [SET <field> = <expression>|<sub-command>[,]*]|
  [CONTENT {<JSON>}]|
  [RETURN <expression>] 
  [FROM <query>]
```

Where:
- `CONTENT`, JSON data as an option to set fields values
- `RETURN`, returns an expression instead of the number of inserted records. You can use any valid SQL expression. The most common use cases include:
 - `@rid` to return the record id of the new record
 - `@this`to return the entire new record
- `FROM`, inserts values from the resultset of a query. Since v1.7.

## Examples

### Insert a new record with name 'Jay' and surname 'Miner'

SQL-92 syntax:
```sql
insert into Profile (name, surname) values ('Jay', 'Miner' )
```

OrientDB abbreviated syntax:
```sql
insert into Profile SET name = 'Jay', surname = 'Miner'
```

JSON content syntax:
```sql
insert into Profile CONTENT {"name": "Jay", "surname" = "Miner"}
```

### Insert a new record of type Profile, but in a different cluster than the default one

```sql
insert into Profile cluster profile_recent (name, surname) values ('Jay', 'Miner' )
```

```sql
insert into Profile cluster profile_recent set name = 'Jay', surname = 'Miner'
```

### Insert several records at the same time

```sql
insert into Profile(name,surname) VALUES ('Jay','Miner'),('Frank','Hermier'),('Emily','Saut')
```

### Insert a new record adding a relationship

```sql
insert into Employee (name, boss) values ('jack', #11:99 )
```

```sql
insert into Employee SET name = 'jack', boss = #11:99
```


### Insert a new record adding a collection of relationship

```sql
insert into Profile (name, friends) values ('Luca', [#10:3, #10:4] )
```

```sql
insert into Profile SET name = 'Luca', friends =  [#10:3, #10:4]
```

### Sub-selects

```sql
insert into Diver SET name = 'Luca', buddy = (select from Diver where name = 'Marko')
```

### Sub-inserts

```sql
insert into Diver SET name = 'Luca', buddy = (insert into Diver name = 'Marko')
```

### Insert in a different cluster

This inserts a new document in the cluster 'asiaemployee':
```sql
insert into cluster:asiaemployee (name) values ('Mattew')
```

But note that the document will have no class assigned. To create a document of a certain class but in a different cluster than the default one use:

```sql
insert into cluster:asiaemployee (@class, content) values('employee', 'Mattew')
```

That will insert the document of type 'employee' in the cluster 'asiaemployee'.

### Insert a new record adding an embedded document

```sql
insert into Profile (name, address) values ('Luca', { "@type" : "d", "street" : "Melrose Avenue", "@version" : 0 } )
```

### Insert from query

#### Copy records in another class
```sql
insert into GermanyClient from ( select from Client where country = 'Germany' )
```

Will insert all the records from Client where the country is "Germany".

#### Copy records in another class adding a field
```sql
insert into GermanyClient from ( select *, true as copied from Client where country = 'Germany' )
```

Will insert all the records from Client where the country is "Germany" and will add an additional field called "copied" with value true.


To know more about other SQL commands look at [SQL commands](SQL.md).

