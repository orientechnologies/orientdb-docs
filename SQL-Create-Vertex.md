# SQL - `CREATE VERTEX`

Creates a new vertex in the database.

The Vertex and Edge are the main components of a Graph database.  OrientDB supports polymorphism on vertices.  The base class for a vertex is `V`.


**Syntax**

```sql
CREATE VERTEX [<class>] [CLUSTER <cluster>] [SET <field> = <expression>[,]*]
```

- **`<class>`** Defines the class to which the vertex belongs.
- **`<cluster>`** Defines the cluster in which it stores the vertex.
- **`<field>`** Defines the field you want to set.
- **`<expression>`** Defines the express to set for the field.

|----|----|
| ![NOTE](images/warning.png) | **NOTE**: When using a distributed database, you can create vertexes through two steps (creation and update).  Doing so can break constraints defined at the class-level for vertices.  To avoid these issues, disable constraints in the vertex class.|

**Examples**

- Create a new vertex on the base class `V`:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE VERTEX</code>
  </pre>

- Create a new vertex class, then create a vertex in that class:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE CLASS V1 EXTENDS V</code>
  orientdb> <code class="lang-sql userinput">CREATE VERTEX V1</code>
  </pre>

- Create a new vertex within a particular cluster:

  <pre>
  orientdb> <code class="userinput lang-sql">CREATE VERTEX V1 CLUSTER recent</code>
  </pre>

- Create a new vertex, defining its properties:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE VERTEX SET brand = 'fiat'</code>
  </pre>

- Create a new vertex of the class `V1`, defining its properties:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE VERTEX V1 SET brand = 'fiat', name = 'wow'</code>
  </pre>

- Create a vertex using JSON content:

  <pre>
  orientdb> <code class="lang-sql userinput">CREATE VERTEX Employee CONTENT { "name" : "Jay", "surname" : "Miner" }</code>
  </pre>

>For more information, see
>
>- [`CREATE EDGE`](SQL-Create-Edge.md)
>- [SQL Commands](SQL.md)

## History

### 1.4

- Command begins using the Blueprints API.  When using Java with the OGraphDatabase API, you may experience unexpected results in how it manages edges.

  To force the command to work with the older API, update the GraphDB settings, use the [`ALTER DATABASE`](SQL-Alter-Database.md) command.

### 1.1

- Initial implementation of feature.