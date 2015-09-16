# SQL - INSERT


The **Insert** command creates a new record in the database. Records can be schema-less or conform to rules you specify in your model.

## Syntax

```sql
INSERT INTO [class:]<class>|cluster:<cluster>|index:<index>
  [(<field>[,]*) VALUES (<expression>[,]*)[,]*]|
  [SET <field> = <expression>|<sub-command>[,]*]|
  [CONTENT {<JSON>}]
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
INSERT INTO Profile (name, surname) VALUES ('Jay', 'Miner' )
```

OrientDB abbreviated syntax:
```sql
INSERT INTO Profile SET name = 'Jay', surname = 'Miner'
```

JSON content syntax:
```sql
INSERT INTO Profile CONTENT {"name": "Jay", "surname" = "Miner"}
```

### Insert a new record of type Profile, but in a different cluster than the default one

```sql
INSERT INTO Profile CLUSTER profile_recent (name, surname) VALUES ('Jay', 'Miner' )
```

```sql
INSERT INTO Profile CLUSTER profile_recent SET name = 'Jay', surname = 'Miner'
```

### Insert several records at the same time

```sql
INSERT INTO Profile(name,surname) VALUES ('Jay','Miner'),('Frank','Hermier'),('Emily','Saut')
```

### Insert a new record adding a relationship

```sql
INSERT INTO Employee (name, boss) VALUES ('jack', #11:99 )
```

```sql
INSERT INTO Employee SET name = 'jack', boss = #11:99
```


### Insert a new record adding a collection of relationship

```sql
INSERT INTO Profile (name, friends) VALUES ('Luca', [#10:3, #10:4] )
```

```sql
INSERT INTO Profile SET name = 'Luca', friends =  [#10:3, #10:4]
```

### Sub-selects

```sql
INSERT INTO Diver SET name = 'Luca', buddy = (SELECT FROM Diver WHERE name = 'Marko')
```

### Sub-inserts

```sql
insert into Diver SET name = 'Luca', buddy = (insert into Diver name = 'Marko')
```

### Insert in a different cluster

This inserts a new document in the cluster 'asiaemployee':
```sql
INSERT INTO CLUSTER:asiaemployee (name) VALUES ('Mattew')
```

But note that the document will have no class assigned. To create a document of a certain class but in a different cluster than the default one use:

```sql
INSERT INTO CLUSTER:asiaemployee (@class, content) VALUES ('employee', 'Mattew')
```

That will insert the document of type 'employee' in the cluster 'asiaemployee'.

### Insert a new record adding an embedded document

```sql
INSERT INTO Profile (name, address) VALUES ('Luca', { "@type" : "d", "street" : "Melrose Avenue", "@version" : 0 } )
```

### Insert from query

#### Copy records in another class
```sql
INSERT INTO GermanyClient FROM SELECT FROM Client WHERE country = 'Germany'
```

Will insert all the records from Client where the country is "Germany".

#### Copy records in another class adding a field
```sql
INSERT INTO GermanyClient FROM SELECT *, true AS copied FROM Client WHERE country = 'Germany'
```

Will insert all the records from Client where the country is "Germany" and will add an additional field called "copied" with value true.


To know more about other SQL commands look at [SQL commands](SQL.md).

