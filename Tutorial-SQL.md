<!-- proofread 2015-11-26 SAM -->
# SQL

Most NoSQL products employ a custom query language.  In this, OrientDB differs by focusing on standards in query languages.  That is, instead of inventing "Yet Another Query Language," it begins with the widely used and well-understood language of SQL.  It then extends SQL to support more complex graphing concepts, such as Trees and Graphs.

Why SQL?  Because SQL is ubiquitous in the database development world. It is familiar and more readable and concise than its competitors, such as Map Reduce scripts or JSON based querying.


## `SELECT`

The [`SELECT`](SQL-Query.md) statement queries the database and returns results that match the given parameters.  For instance, earlier in [Getting Started](Tutorial-Introduction-to-the-NoSQL-world.md), two queries were presented that gave the same results: `BROWSE CLUSTER ouser` and `BROWSE CLASS OUser`. Here is a third option, available through a [`SELECT`](SQL-Query.md) statement.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM OUser</code>
</pre>

Notice that the query has no projections. This means that you do not need to enter a character to indicate that the query should return the entire record, such as the asterisk in the Relational model, (that is, `SELECT * FROM OUser`).

Additionally, OUser is a class. By default, OrientDB executes queries against classes. Targets can also be:

- **Clusters**  To execute against a cluster, rather than a class, prefix `CLUSTER` to the target name.

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM CLUSTER:Ouser</code>
  </pre>

- **Record ID** To execute against one or more [Record ID's](Concepts.md#recordId), use the identifier(s) as your target.  For example.

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM #10:3</code>
  orientdb> <code class="lang-sql userinput">SELECT FROM [#10:1, #10:30, #10:5]</code>
  </pre>

- **Indexes** To execute a query against an index, prefix ``INDEX`` to the target name.

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT VALUE FROM INDEX:dictionary WHERE key='Jay'</code>
  </pre>

### `WHERE`

Much like the standard implementation of SQL, OrientDB supports [`WHERE`](SQL-Where.md) conditions to filter the returning records too.  For example,

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM OUser WHERE name LIKE 'l%'</code>
</pre>

This returns all `OUser` records where the name begins with `l`.  For more information on supported operators and functions, see [`WHERE`](SQL-Where.md).

### `ORDER BY`

In addition to [`WHERE`](SQL-Where.md), OrientDB also supports `ORDER BY` clauses. This allows you to order the results returned by the query according to one or more fields, in either ascending or descending order.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Employee WHERE city='Rome' ORDER BY surname ASC, name ASC</code>
</pre>

The example queries the `Employee` class, it returns a listing of all employees in that class who live in Rome and it orders the results by surname and name, in ascending order.

### `GROUP BY`

In the event that you need results of the query grouped together according to the values of certain fields, you can manage this using the `GROUP BY` clause.


<pre>
orientdb> <code class="lang-sql userinput">SELECT SUM(salary) FROM Employee WHERE age < 40 GROUP BY job</code>
</pre>

In the example, you query the `Employee` class for the sum of the salaries of all employees under the age of forty, grouped by their job types.

### `LIMIT`

In the event that your query returns too many results, making it difficult to read or manage, you can use the `LIMIT` clause to reduce it to the top most of the return values.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Employee WHERE gender='male' LIMIT 20</code>
</pre>

In the example, you query the `Employee` class for a list of male employees.  Given that there are likely to be a number of these, you limit the return to the first twenty entries.


### `SKIP`

When using the `LIMIT` clause with queries, you can only view the topmost of the return results. In the event that you would like to view certain results further down the list, for instance the values from twenty to forty, you can paginate your results using the `SKIP` keyword in the `LIMIT` clause.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Employee WHERE gender='male' LIMIT 20</code>
orientdb> <code class="lang-sql userinput">SELECT FROM Employee WHERE gender='male' SKIP 20 LIMIT 20</code>
orientdb> <code class="lang-sql userinput">SELECT FROM Employee WHERE gender='male' SKIP 40 LIMIT 20</code>
</pre>

The first query returns the first twenty results, the second returns the next twenty results, the third up to sixty.  You can use these queries to manage pages at the application layer.


## `INSERT`

The [`INSERT`](SQL-Insert.md) statement adds new data to a class and cluster.  OrientDB supports three forms of syntax used to insert new data into your database.

- The standard ANSI-93 syntax:
  <pre>
  orientdb> <code class="lang-sql userinput">INSERT INTO	Employee(name, surname, gender)
          VALUES('Jay', 'Miner', 'M')</code>
  </pre>

- The simplified ANSI-92 syntax:

  <pre>
  orientdb> <code class="lang-sql userinput">INSERT INTO Employee SET name='Jay', surname='Miner', gender='M'</code>
  </pre>

- The JSON syntax:

  <pre>
  orientdb> <code class="lang-sql userinput">INSERT INTO Employee CONTENT</code> <code class="lang-json userinput">{name : 'Jay', surname : 'Miner',
          gender : 'M'}</code>
  </pre>

Each of these queries adds Jay Miner to the `Employee` class. You can choose whichever syntax that works best with your application. 


## `UPDATE`

The [`UPDATE`](SQL-Update.md) statement changes the values of existing data in a class and cluster.  In OrientDB there are two forms of syntax used to update data on your database.

- The standard ANSI-92 syntax:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Employee SET local=TRUE WHERE city='London'</code>
  </pre>

- The JSON syntax, used with the `MERGE` keyword, which merges the changes with the current record:

  <pre>
  orientdb> <code class="lang-sql userinput">UPDATE Employee MERGE { local : TRUE } WHERE city='London'</code>
  </pre>

Each of these statements updates the `Employee` class, changing the `local` property to `TRUE` when the employee is based in London.


## `DELETE`

The [`DELETE`](SQL-Delete.md) statement removes existing values from your class and cluster.  OrientDB supports the standard ANSI-92 compliant syntax for these statements:

<pre>
orientdb> <code class="lang-sql userinput">DELETE FROM Employee WHERE city <> 'London'
</pre>

Here, entries are removed from the `Employee` class where the employee in question is not based in London.

**See also:**

  - [The SQL Reference](SQL.md)
  - [The Console Command Reference](Console-Commands.md)