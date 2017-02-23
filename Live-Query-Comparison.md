---
search:
   keywords: ["live query", "live queries"]
---

# Comparison of Tradition and Live Queries

When you execute a [`SELECT`](sql/SQL-Query.md) statement, whether synchronous or asynchronous, you expect the system to return results that are currently present in the database and that match your selection criteria.  You also expect a finite result-set and that your query executes within a given time frame.

Live Queries operate in a slightly different way:

- They **do not** return data as it exists when the query executes.
- They return **changes** that occur on the database from that moment on that match your selection criteria.
- They continue until you terminate the query or an error occurs.
- They are asynchronous and push-based, (that is, the server sends new results to your callback as soon as they become available).

To make the differences more explicit, you can find a pair of simple examples below.

## Standard Queries

The client executes a [`SELECT`](sql/SQL-Query.md) statement on the `Person` class, which returns the current list of persons in the database.

<pre>
orientdb> <code class="lang-sql userinput">SELECT FROM Person</code>

+-------+------------+---------+
| @rid  | name       | surname |
+-------+------------+---------+
| #12:0 | John       | Milton  |
| #12:1 | Hieronymus | Bosch   |
+-------+------------+---------+
</pre>

From a different client, the user inserts a new entry into the database.

<pre>
orientdb> <code class="lang-sql userinput">INSERT INTO Person SET surname = "Augustus"</code>
</pre>

By issuing the [`INSERT`](sql/SQL-Insert.md) statement, the second client adds a new entry to the `Person` class.  However, OrientDB has closed the initial selection query made by the first client.

The first client remains unaware of the insertion until it reissues the [`SELECT`](sql/SQL-Query.md) statement.

## Live Queries

In this example, the client again queries the `Person` class, but this time uses a [`LIVE SELECT`](sql/SQL-Live-Select.md) statement.

<pre>
orientdb> <code class="lang-sql userinput">LIVE SELECT FROM Person</code>

token: 1234567 // Unique identifier of this live query, needed for unsubscribe.
</pre>

The immediate result of this query is to issue a unique identifier of the query itself.  The statement returns no other data, even if the data is available on the database.

### Insertion

From the second client, issue the above [`INSERT`](sql/SQL-Insert.md) statement.

<pre>
orientdb> <code class="lang-sql userinput">INSERT INTO Person SET surname = "Augustus"</code>
</pre>

When OrientDB executes this statement, the first client responds with the following content (schematic):

```
content: {@rid: 12:2, surname: 'Augustus'}
operation: insert
```

### Update

From the second client, issue an [`UPDATE`](sql/SQL-Update.md) statement.

<pre>
orientdb> <code class="lang-sql userinput">UPDATE Person SET surname = "Caesar"
          WHERE surname = "Augustus"</code>
</pre>

When OrientDB executes this statement, the first client responds with the following content (schematic):

```
content: {@rid: #12:2, surname = "Caesar"}
operation: update
``` 

### Unsubscribe

At any time you can unsubscribe the first client from the Live Query by issuing the [`LIVE UNSUBSCRIBE`](sql/SQL-Live-Unsubscribe.md) statement with the given token.

<pre>
orientdb> <code class="lang-sql userinput">LIVE UNSUBSCRIBE 1234567</code>
</pre>

From now on, the Live Query does not return any other results to the client.
