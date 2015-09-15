# Using Schema with Graphs

OrientDB is a Graph Database "on steroids" because it supports concepts taken from both the Document Database and Object-Oriented worlds. This Tutorial step shows the power of Graphs used in conjunction with schema and constraints.

Take a look at this use case:  Creating a graph to map the relationships between Person and Cars.

Let's open a shell (or command prompt in Windows) and launch the OrientDB Console (use `console.bat` on Windows):

```sh
$ cd $ORIENTDB_HOME/bin
$ ./console.sh
```

Now we're going to use the console to create a brand new local database:

<pre>
orientdb> <code class="lang-sql userinput">CREATE DATABASE plocal:../databases/cars admin admin plocal</code>
</pre>

Ok, now let's create the first graph schema with "Person" and "Car" as 2 new Vertex types and "Owns" as an Edge type:

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Person EXTENDS V</code>

orientdb> <code class="lang-sql userinput">CREATE CLASS Car EXTENDS V</code>

orientdb> <code class="lang-sql userinput">CREATE CLASS Owns EXTENDS E</code>
</pre>

And let's go populate the database with the first Graph elements:

<pre>
orientdb> <code class="lang-sql userinput">CREATE VERTEX Person SET name = 'Luca'</code>

Created vertex 'Person#11:0{name:Luca} v1' in 0,012000 sec(s).


orientdb> <code class="lang-sql userinput">CREATE VERTEX Car SET name = 'Ferrari Modena'</code>

Created vertex 'Car#12:0{name:Ferrari Modena} v1' in 0,001000 sec(s).


orientdb> <code class="lang-sql userinput">CREATE EDGE Owns FROM ( SELECT FROM Person ) TO ( SELECT FROM Car )</code>

Created edge '[e[#11:0->#12:0][#11:0-Owns->#12:0]]' in 0,005000 sec(s).
</pre>

Ok, now we can traverse vertices. For example, what is Luca's car? Traverse from Luca vertex to the outgoing vertices following the "Owns" relationships:

<pre>
orientdb> <code class="lang-sql userinput">SELECT NAME FROM ( SELECT EXPAND( OUT('Owns') ) FROM Person
          WHERE name='Luca' )</code>

----+-------+-----------------
 #  | @RID  | name
----+-------+-----------------
 0  | #-2:1 | Ferrari Modena
----+-------+-----------------
</pre>

Perfect. Now we want to have the location of each Person. We need another Vertex type called "Country" to connect to the Person with a new "Lives" Edge type:

<pre>
orientdb> <code class="lang-sql userinput">CREATE CLASS Country EXTENDS V</code>

orientdb> <code class="lang-sql userinput">CREATE CLASS Lives EXTENDS E</code>

orientdb> <code class="lang-sql userinput">CREATE VERTEX Country SET name='UK'</code>

Created vertex 'Country#14:0{name:UK} v1' in 0,004000 sec(s).
</pre>

Next, let's associate Luca with the UK Country:

<pre>
orientdb> <code class="lang-sql userinput">CREATE EDGE Lives FROM ( SELECT FROM Person ) TO ( SELECT FROM Country</code>

Created edge '[e[#11:0->#14:0][#11:0-Lives->#14:0]]' in 0,006000 sec(s).
</pre>

So far so good.  Our graph has been extended. Now, try to search the country where there are "Ferrari" cars in our database.

<pre>
orientdb> <code class="lang-sql userinput">SELECT name FROM ( SELECT EXPAND( IN('Owns').OUT('Lives') )
          FROM Car WHERE name LIKE '%Ferrari%' )</code>

---+-------+--------
 # | @RID  | name
---+-------+--------
 0 | #-2:1 | UK
---+-------+--------
</pre>

## Setting constraints on Edges

Now we've modeled our graph using a schema without any constraints. But it would be useful to require an Owns relationship to exist only between the Person and Car vertices. So, let's create these constraints:

<pre>
orientdb> <code class="lang-sql userinput">CREATE PROPERTY Owns.out LINK Person</code>

orientdb> <code class="lang-sql userinput">CREATE PROPERTY Owns.in LINK Car</code>
</pre>

The `MANDATORY` setting against a property prevents OrientDB from using a lightweight edge (no physical document is created).  Be sure to pay attention and not put spaces between `MANDATORY=TRUE`.

<pre>
orientdb> <code class="lang-sql userinput">ALTER PROPERTY Owns.out MANDATORY=TRUE</code>
orientdb> <code class="lang-sql userinput">ALTER PROPERTY Owns.in MANDATORY=TRUE</code>
</pre>

If we want to prohibit a Person vertex from having 2 edges against the same Car vertex, we have to define a `UNIQUE` index against out and in properties.

<pre>
orientdb> <code class="lang-sql userinput">CREATE INDEX UniqueOwns ON Owns(out,in) UNIQUE</code>

Created index successfully with 0 entries in 0,023000 sec(s).
</pre>

Unfortunately, the index tells us 0 entries are indexed. Why?  We have already created the Owns relationships between "Luca" and "Ferrari Modena." In that case, OrientDB had already created a lightweight edge before we set the rule to force creation documents for Owns instances. So, you need to drop and recreate the edge.

<pre>
orientdb> <code class="lang-sql userinput">DELETE EDGE FROM #11:0 TO #12:0</code>
orientdb> <code class="lang-sql userinput">CREATE EDGE Owns FROM ( SELECT FROM Person ) TO ( SELECT FROM Car )</code>
</pre>

Now check that the record has been created.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Owns</code>

---+-------+-------+--------
 # | @RID  | out   | in
---+-------+-------+--------
 0 | #13:0 | #11:0 | #12:0
---+-------+-------+--------
</pre>

So far so good.  The constraints works.  Now try to create a "Owns" edge between Luca and UK (Country vertex):

<pre>
orientdb> <code class="lang-sql userinput">CREATE EDGE Owns FROM ( SELECT FROM Person ) TO ( SELECT FROM Country )</code>

Error: com.orientechnologies.orient.core.exception.OCommandExecutionException:
Error on execution of command: sql.create edge Owns from (select from Person)...
Error: com.orientechnologies.orient.core.exception.OValidationException: The
field 'Owns.in' has been declared as LINK of type 'Car' but the value is the
document #14:0 of class 'Country'
</pre>

Now we have a typed graph with constraints.

For more information look at [Graph Schema](Graph-Schema.md).
