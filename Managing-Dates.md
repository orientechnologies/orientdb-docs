---
search:
   keywords: ['concept', 'date', 'time', 'datetime']
---

<!-- proofread 2015-11-26 SAM -->
# Managing Dates

OrientDB treats dates as first class citizens. Internally, it saves dates in the [Unix time](https://en.wikipedia.org/wiki/Unix_time) format.  Meaning, it stores dates as a `long` variable, which contains the count in milliseconds since the Unix Epoch, (that is, 1 January 1970).

## Date and Datetime Formats

In order to make the internal count from the Unix Epoch into something human readable, OrientDB formats the count into date and datetime formats.  By default, these formats are:

- Date Format: `yyyy-MM-dd`
- Datetime Format: `yyyy-MM-dd HH:mm:ss`

In the event that these default formats are not sufficient for the needs of your application, you can customize them through [`ALTER DATABASE...DATEFORMAT`](SQL-Alter-Database.md) and [`DATETIMEFORMAT`](SQL-Alter-Database.md) commands.  For instance,

<pre>
orientdb> <code class="lang-sql userinput">ALTER DATABASE DATEFORMAT "dd MMMM yyyy"</code>
</pre>

This command updates the current database to use the English format for dates.  That is, 14 Febr 2015.

## SQL Functions and Methods

To simplify the management of dates, OrientDB SQL automatically parses dates to and from strings and longs.  These functions and methods provide you with more control to manage dates:

| SQL | Description |
|----|----|
| [`DATE()`](SQL-Functions.md#date) | Function converts dates to and from strings and dates, also uses custom formats.|
| [`SYSDATE()`](SQL-Functions.md#sysdate) | Function returns the current date.|
| [`.format()`](SQL-Methods.md#format) | Method returns the date in different formats.|
| [`.asDate()`](SQL-Methods.md#asdate) | Method converts any type into a date.|
| [`.asDatetime()`](SQL-Methods.md#asdatetime) | Method converts any type into datetime.|
| [`.asLong()`](SQL-Methods.md#aslong)| Method converts any date into long format, (that is, Unix time).|

For example, consider a case where you need to extract only the years for date entries and to arrange them in order.  You can use the [`.format()`](SQL-Methods.md#format) method to extract dates into different formats.

<pre>
orientdb> <code class="lang-sql userinput">SELECT @RID, id, date.format('yyyy') AS year FROM Order</code>

--------+----+------+
 @RID   | id | year |
--------+----+------+
 #31:10 | 92 | 2015 |
 #31:10 | 44 | 2014 |
 #31:10 | 32 | 2014 |
 #31:10 | 21 | 2013 |
--------+----+------+
</pre>

In addition to this, you can also group the results. For instance, extracting the number of orders grouped by year.

<pre>
orientdb> <code class="lang-sql userinput">SELECT date.format('yyyy') AS Year, COUNT(*) AS Total 
          FROM Order ORDER BY Year</code>

------+--------+
 Year |  Total |
------+--------+
 2015 |      1 |
 2014 |      2 |
 2013 |      1 |
------+--------+
</pre>

## Dates before 1970

While you may find the default system for managing dates in OrientDB sufficient for your needs, there are some cases where it may not prove so.  For instance, consider a database of archaeological finds, a number of which date to periods not only before 1970 but possibly even before the Common Era.  You can manage this by defining an era or epoch variable in your dates.

For example, consider an instance where you want to add a record noting the date for the foundation of Rome, which is traditionally referred to as April 21, 753 BC.  To enter dates before the Common Era, first run the [`ALTER DATABASE DATETIMEFORMAT`] command to add the `GG` variable to use in referencing the epoch.

<pre>
orientdb> <code class="lang-sql userinput">ALTER DATABASE DATETIMEFORMAT "yyyy-MM-dd HH:mm:ss GG"</code>
</pre>

Once you've run this command, you can create a record that references date and datetime by epoch.

<pre>
orientdb> <code class="lang-sql userinput">CREATE VERTEX V SET city = "Rome", date = DATE("0753-04-21 00:00:00 BC")</code>
orientdb> <code class="lang-sql userinput">SELECT @RID, city, date FROM V</code>

-------+------+------------------------+
 @RID  | city | date                   |
-------+------+------------------------+
 #9:10 | Rome | 0753-04-21 00:00:00 BC |
-------+------+------------------------+
</pre>

### Using `.format()` on Insertion

In addition to the above method, instead of changing the date and datetime formats for the database, you can format the results as you insert the date.

<pre>
orientdb> <code class="lang-sql userinput">CREATE VERTEX V SET city = "Rome", date = DATE("yyyy-MM-dd HH:mm:ss GG")</code>
orientdb> <code class="lang-sql userinput">SELECT @RID, city, date FROM V</code>

------+------+------------------------+
 @RID | city | date                   |
------+------+------------------------+
 #9:4 | Rome | 0753-04-21 00:00:00 BC |
------+------+------------------------+
</pre>

Here, you again create a vertex for the traditional date of the foundation of Rome.  However, instead of altering the database, you format the date field in [`CREATE VERTEX`](SQL-Create-Vertex.md) command.

### Viewing Unix Time

In addition to the formatted date and datetime, you can also view the underlying count from the Unix Epoch, using the [`asLong()`](SQL-Methods.md#aslong) method for records.  For example,

<pre>
orientdb> <code class='lang-sql userinput'>SELECT @RID, city, date.asLong() FROM #9:4</code>

------+------+------------------------+
 @RID | city | date                   |
------+------+------------------------+
 #9:4 | Rome | -85889120400000        |
------+------+------------------------+
</pre>

Meaning that, OrientDB represents the date of April 21, 753 BC, as -85889120400000 in Unix time.  You can also work with dates directly as longs.

<pre>
orientdb> <code class="lang-sql userinput">CREATE VERTEX V SET city = "Rome", date = DATE(-85889120400000)</code>
orientdb> <code class="lang-sql userinput">SELECT @RID, city, date FROM V</code>

-------+------+------------------------+
 @RID  | city | date                   |
-------+------+------------------------+
 #9:11 | Rome | 0753-04-21 00:00:00 BC |
-------+------+------------------------+
</pre>


### Use ISO 8601 Dates
According to ISO 8601, Combined date and time in UTC: 2014-12-20T00:00:00. To use this standard change the datetimeformat in the database:

```sql
ALTER DATABASE DATETIMEFORMAT "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
```
