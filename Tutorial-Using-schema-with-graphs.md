<!-- proofread 2015-11-26 SAM -->
# Using Schema with Graphs


OrientDB, through the Graph API, offers a number of features above and beyond the traditional Graph Databases given that it supports concepts drawn from both the Document Database and the Object Oriented worlds. For instance, consider the power of graphs, when used in conjunction with schemas and constraints.

## Use Case: Car Database

For this example, consider a graph database that maps the relationship between individual users and their cars.  First, create the graph schema for the `Person` and `Car` vertex classes, as well as the `Owns` edge class to connect the two:

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Person EXTENDS V</code>

orientdb> <code class="lang-sql userinput">CREATE CLASS Car EXTENDS V</code>

orientdb> <code class="lang-sql userinput">CREATE CLASS Owns EXTENDS E</code>
</pre>

These commands lay out the schema for your graph database.  That is, they define two vertex classes and an edge class to indicate the relationship between the two.  With that, you can begin to populate the database with vertices and edges.

<pre>
orientdb> <code class="lang-sql userinput">CREATE VERTEX Person SET name = 'Luca'</code>

Created vertex 'Person#11:0{name:Luca} v1' in 0,012000 sec(s).


orientdb> <code class="lang-sql userinput">CREATE VERTEX Car SET name = 'Ferrari Modena'</code>

Created vertex 'Car#12:0{name:Ferrari Modena} v1' in 0,001000 sec(s).


orientdb> <code class="lang-sql userinput">CREATE EDGE Owns FROM ( SELECT FROM Person ) TO ( SELECT FROM Car )</code>

Created edge '[e[#11:0->#12:0][#11:0-Owns->#12:0]]' in 0,005000 sec(s).
</pre>

### Querying the Car Database

In the above section, you create a car database and populated it with vertices and edges to map out the relationship between drivers and their cars.  Now you can begin to query this database, showing what those connections are.  For example, what is Luca's car?  You can find out by traversing from the vertex Luca to the outgoing vertices following the `Owns` relationship.

<pre>
orientdb> <code class="lang-sql userinput">SELECT NAME FROM ( SELECT EXPAND( OUT('Owns') ) FROM Person
          WHERE name='Luca' )</code>

----+-------+-----------------+
 #  | @RID  | name            |
----+-------+-----------------+
 0  | #-2:1 | Ferrari Modena  |
----+-------+-----------------+
</pre>

As you can see, the query returns that Luca owns a Ferrari Modena.  Now consider expanding your database to track where each person lives.

### Adding a Location Vertex

Consider a situation, in which you might want to keep track of the countries in which each person lives. In practice, there are a number of reasons why you might want to do this, for instance, for the purposes of promotional material or in a larger database to analyze the connections to see how residence affects car ownership.

To begin, create a vertex class for the country, in which the person lives and an edge class that connects the individual to the place.

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Country EXTENDS V</code>

orientdb> <code class="lang-sql userinput">CREATE CLASS Lives EXTENDS E</code>

</pre>

This creates the schema for the feature you're adding to the cars database.  The vertex class `Country` recording countries in which people live and the edge class `Lives` to connect individuals in the vertex class `Person` to entries in `Country`.

With the schema laid out, create a vertex for the United Kingdom and connect it to the person Luca.

<pre>

orientdb> <code class="lang-sql userinput">CREATE VERTEX Country SET name='UK'</code>

Created vertex 'Country#14:0{name:UK} v1' in 0,004000 sec(s).


orientdb> <code class="lang-sql userinput">CREATE EDGE Lives FROM ( SELECT FROM Person ) TO ( SELECT FROM Country</code>

Created edge '[e[#11:0->#14:0][#11:0-Lives->#14:0]]' in 0,006000 sec(s).
</pre>

The second command creates an edge connecting the person Luca to the country United Kingdom.  Now that your cars database is defined and populated, you can query it, such as a search that shows the countries where there are users that own a Ferrari.

<pre>
orientdb> <code class="lang-sql userinput">SELECT name FROM ( SELECT EXPAND( IN('Owns').OUT('Lives') )
          FROM Car WHERE name LIKE '%Ferrari%' )</code>

---+-------+--------+
 # | @RID  | name   |
---+-------+--------+
 0 | #-2:1 | UK     |
---+-------+--------+
</pre>

### Using `in` and `out` Constraints on Edges

In the above sections, you modeled the graph using a schema without any constraints, but you might find it useful to use some.  For instance, it would be good to require that an `Owns` relationship only exist between the vertex `Person` and the vertex `Car`.

<pre>
orientdb> <code class="lang-sql userinput">CREATE PROPERTY Owns.out LINK Person</code>

orientdb> <code class="lang-sql userinput">CREATE PROPERTY Owns.in LINK Car</code>
</pre>

These commands link outgoing vertices of the `Person` class to incoming vertices of the `Car` class.  That is, it configures your database so that a user can own a car, but a car cannot own a user.

### Using `MANDATORY` Constraints on Edges

By default, when OrientDB creates an edge that lacks properties, it creates it as a Lightweight Edge.  That is, it creates an edge that has no physical record in the database.  Using the `MANDATORY` setting, you can stop this behavior, forcing it to create the standard Edge, without outright disabling Lightweight Edges.

<pre>
orientdb> <code class="lang-sql userinput">ALTER PROPERTY Owns.out MANDATORY=TRUE</code>
orientdb> <code class="lang-sql userinput">ALTER PROPERTY Owns.in MANDATORY=TRUE</code>
</pre>

### Using `UNIQUE` with Edges

For the sake of simplicity, consider a case where you want to limit the way people are connected to cars to where the user can only match to the car once.  That is, if Luca owns a Ferrari Modena, you might prefer not to have a double entry for that car in the event that he buys a new one a few years later.  This is particularly important given that our database covers make and model, but not year.

To manage this, you need to define a `UNIQUE` index against both the out and in properties.


<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX UniqueOwns ON Owns(out,in) UNIQUE</code>

Created index successfully with 0 entries in 0,023000 sec(s).
</pre>

The index returns tells us that no entries are indexed.  You have already created the `Onws` relationship between Luca and the Ferrari Modena.  In that case, however, OrientDB had created a Lightweight Edge before you set the rule to force the creation of documents for `Owns` instances.  To fix this, you need to drop and recreate the edge.

<pre>
orientdb> <code class="lang-sql userinput">DELETE EDGE FROM #11:0 TO #12:0</code>
orientdb> <code class="lang-sql userinput">CREATE EDGE Owns FROM ( SELECT FROM Person ) TO ( SELECT FROM Car )</code>
</pre>

To confirm that this was successful, run a query to check that a record was created:

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Owns</code>

---+-------+-------+--------+
 # | @RID  | out   | in     |
---+-------+-------+--------+
 0 | #13:0 | #11:0 | #12:0  |
---+-------+-------+--------+
</pre>

This shows that a record was indeed created.  To confirm that the constraints work, attempt to create an edge in `Owns` that connects Luca to the United Kingdom.

<pre>
orientdb> <code class="lang-sql userinput">CREATE EDGE Owns FROM ( SELECT FROM Person ) TO ( SELECT FROM Country )</code>

Error: com.orientechnologies.orient.core.exception.OCommandExecutionException:
Error on execution of command: sql.create edge Owns from (select from Person)...
Error: com.orientechnologies.orient.core.exception.OValidationException: The
field 'Owns.in' has been declared as LINK of type 'Car' but the value is the
document #14:0 of class 'Country'
</pre>

This shows that the constraints effectively blocked the creation, generating a set of errors to explain why it was blocked.

You now have a typed graph with constraints.  For more information, see [Graph Schema](Graph-Schema.md).
