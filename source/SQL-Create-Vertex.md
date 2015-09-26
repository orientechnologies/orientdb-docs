# SQL - CREATE VERTEX

This command creates a new Vertex into the database. Vertices, together with Edges, are the main components of a Graph. OrientDB supports polymorphism on vertices. The base class is "V". Look also how to [Create Edges](SQL-Create-Edge.md).

| ![NOTE](images/warning.png) | _NOTE: While running as distributed, vertex creation could be done in two steps (create+update). This could break some constraint defined at Vertex's class level. To avoid this kind of problem disable the constrains in Vertex's class._ |
|----|----|

## Syntax

```sql
CREATE VERTEX [<class>] [CLUSTER <cluster>] [SET <field> = <expression>[,]*]
```

## Examples

### Create a new vertex of the base class 'V'

```sql
CREATE VERTEX
```

### Create a new vertex type and a new vertex of the new type

```sql
CREATE CLASS V1 EXTENDS V
CREATE VERTEX V1
```

### Create a new vertex in a particular cluster

```sql
CREATE VERTEX V1 CLUSTER recent
```

### Create a new vertex setting properties

```sql
CREATE VERTEX SET brand = 'fiat'
```

### Create a new vertex of type V1 setting properties

```sql
CREATE VERTEX V1 SET brand = 'fiat', name = 'wow'
```

### Create a vertex with JSON content
```sql
CREATE VERTEX Employee CONTENT { "name" : "Jay", "surname" : "Miner" }
```


## History and Compatibility

- 1.1: first version
- starting from v.1.4 the command uses the Blueprints API under the hood, so if you're working in Java using the OGraphDatabase API you could experience in some difference how edges are managed. To force the command to work with the "old" API change the GraphDB settings described in [Graph backward compatibility](SQL-Alter-Database.md#use-graphdb-created-with-releases-before-14)


To know more about other SQL commands look at [SQL commands](SQL.md).
