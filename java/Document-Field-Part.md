---
search:
   keywords: ['Document API', 'field', 'extract']
---

# Working with Fields

When you query OrientDB it normally returns complete fields.  In the event that you would like to only retrieve certain parts of the Document field, you can extract them through the Java API, ['WHERE'](../sql/SQL-Where.md) conditions and SQL projections.

To extract parts, use the brackets.


## Extracting Punctual Items

Under normal operations, when you issue a query to OrientDB the return value contains complete fields.  That is, if you issue [`SELECT`](../sql/SQL-Query.md) against a certain property, what you receive is the complete value on that property.  For instance,

<pre>
orientdb> <code class="userinput lang-sql">SELECT tags FROM BlogEntry</code>

+--------+-----------------------------------+
| @rid   | tags                              |
+--------+-----------------------------------+
| #10:34 | ['vim', 'vimscript', 'NERD Tree'] |
| #10:35 | ['sed', 'awk', 'bash', 'grep']    |
| #10:36 | ['Emacs', 'Elisp', 'org-mode']    |
+--------+-----------------------------------+
</pre>

Here we have a series of blog entries on editing text in unix-like environemnts.  The query returns the tags for each entry, which is an `EMBEDDEDSET` of strings.  Normally, you would need to add logic at the application layer to only extract portions of this list.  But, using brackets, you can do so from within the query.

- **Single Extraction**: When querying a sequenced proeprty, you can retrieve a specific entry by using an integer in the brackets.  For instance, `tag[0]`.

  <pre>
  orientdb> <code class="userinput lang-sql">SELECT tags[0] FROM BlogEntry</code>

  +--------+-----------+
  | @rid   | tags      |
  +--------+-----------+
  | #10:34 | ['vim']   |
  | #10:35 | ['sed']   |
  | #10:36 | ['Emacs'] |
  +--------+-----------+
  </pre>

- **Group Extraction**: When querying a sequenced property, you can retrieve groups of entries by separating them by a comma.  For instance, `tag[0,2]`.

  <pre>
  orientdb> <code class="userinput lang-sql">SELECT tags[0,2] FROM BlogEntry</code>

  +--------+-----------------------+
  | @rid   | tags                  |
  +--------+-----------------------+
  | #10:34 | ['vim', 'NERD Tree']  |
  | #10:35 | ['sed', 'bash']       |
  | #10:36 | ['Emacs', 'org-mode'] |
  +--------+-----------------------+
  </pre>

- **Range Extraction**: When querying a sequenced property, you can retrieve a range of entries by separating the lower and upper bounds by a hyphen.  For instance, `tag[1-2]`.

  <pre>
  orientdb> <code class="userinput lang-sql">SELECT tags[1-2] FROM BlogEntry</code>

  +--------+----------------------------+
  | @rid   | tags                       |
  +--------+----------------------------+
  | #10:34 | ['vimscript', 'NERD Tree'] |
  | #10:35 | ['awk', 'bash']            |
  | #10:36 | ['Elisp', 'org-mode']      |
  +--------+----------------------------+
  </pre>

- **Map Extraction**: When querying a mapped property, you can retrieve a specific entry from the map by passing the key.  For instance, `phone['home']`.

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM BlogEntry 
            WHERE author['group'] LIKE 'Club Linux'</code> 
  </pre>

- **Conditional Extraction** In addition to positional and map values, you can also perform extraction based on conditions.  For instance,

  <pre>
  orientdb> <code class="lang-sql userinput">SELECT FROM BlogEntry
            WHERE author[group = 'Club Linux']</code>
  </pre>

  For more information, see [Conditional Extraction](#using-condition-extraction).

### Using Extraction in SQL

You can use brackets to extract specific parts from the Document field.  For instance, consider an address book database that maps phone numbers to types of phone numbers, (such as their home number or mobile).

For instance, say you want to query the address book for the home numbers of users living in Italy:

<pre>
orientdb> <code class="userinput lang-sql">SELECT name, phones FROM Profile
          WHERE phones['home'] LIKE '+39%'</code>
</pre>

You can chain maps together, such as in cases where a property is a map of a map.

<pre>
orientdb> <code class="userinput lang-sql">SELECT name, contacts FROM Profile
          WHERE contacts[phones][home] LIKE '+39%'</code>
</pre>


### Using Conditional Extraction

In addition to sequential positions and map values, you can also use conditional statements in extraction.  For instance,

```
employees[label = 'Ferrari']
```

>Currently, only the equals condition is supported.

Consider the example of a Graph Database.  You can cross a graph using a projection, such as traversing all retrieved nodes with the name "Tom" and viewing their outgoing edges, (here, a collection field called `out`).  

Without extraction, you would do this using dot notation.  For instance,

<pre>
orientdb> <code class="lang-sql userinput">SELECT out.in FROM Person WHERE name = 'Tom'</code>
</pre>

You can filter collections using the equals operator.  For instance, you might want to find out how many Toms in the database own Ferraris.  You could do this by performing extraction on the `out` property, so that it matches the incoming edge to the label "Ferrari":

<pre>
orientdb> <code class="lang-sql userinput">SELECT out[in.label = 'Ferrari'] FROM Person
          WHERE name = 'Tom'</code>
</pre>

You might want a more generic return and only match by class the incoming edges that are cars.

<pre>
orientdb> <code class="userinput lang-sql">SELECT out[in.@class = 'Car'] FROM Person
          WHERE name = 'Tom'</code>
</pre>

Alternatively, you could use both together:

<pre>
orientdb> <code class='lang-sql userinput'>SELECT out[label = 'drives'][in.@class = 'Car']
          FROM Person WHERE name = 'Tom'</code>
</pre>

Where brackets follow brackets, OrientDB filters the result-set in steps as in a pipeline.

>Bear in mind, this does not replace [Gremlin](../gremlin/Gremlin.md) support.  There's a lot more that you can do with Gremlin than you can through extraction, but extraction is a simpler tool for traversing relationships.  

## Future directions

In the future you will be able to use the full expression of the OrientDB SQL language inside the square brackets [], like:
```sql
SELECT out[in.label.trim() = 'Ferrari' AND in.@class='Vehicle'] FROM v WHERE name = 'Tom'
```
But for this you have to wait yet :-) Monitor the issue: https://github.com/nuvolabase/orientdb/issues/513
