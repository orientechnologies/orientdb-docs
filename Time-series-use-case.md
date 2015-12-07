<!-- proofread 2015-11-26 SAM -->
# Time Series Use Case

Managing records related to historical information is pretty common. When you have millions of records, indexes start show their limitations, because the cost to find the records is O(logN). This is also the main reason why Relational DBMS are so slow with huge databases.

So when you have millions of record the best way to scale up linearly is avoid using indexes at all or as much as you can. But how can you retrieve records in a short time without indexes? Should OrientDB scan the entire database at every query? No. You should use the Graph properties of OrientDB. Let's look at a simple example, where the domain are logs.

A typical log record has some information about the event and a date. Below is the Log record to use in our example. We're going to use the JSON format to simplify reading:

```json
{
  "date" : 12293289328932,
  "priority" : "critical",
  "note" : "System reboot"
}
```

Now let's create a tree (that is a directed, non cyclic graph) to group the Log records based on the granularity we need. Example:
```
Year -> month (map) -> Month -> day (map) -> Day -> hour  (map) -> Hour
```
Where Year, Month, Day and Hour are vertex classes. Each Vertex links the other Vertices of smaller type. The links should be handled using a Map to make easier the writing of queries.

Create the classes:
```sql
CREATE CLASS Year
CREATE CLASS Month
CREATE CLASS Day
CREATE CLASS Hour

CREATE PROPERTY Year.month LINKMAP Month
CREATE PROPERTY Month.day LINKMAP Day
CREATE PROPERTY Day.hour LINKMAP Hour
```

Example to retrieve the vertex relative to the date March 2012, 20th at 10am (2012/03/20 10:00:00):
```sql
SELECT month[3].day[20].hour[10].logs FROM Year WHERE year = "2012"
```
If you need more granularity than the Hour you can go ahead until the Time unit you need:

    Hour -> minute (map) -> Minute -> second (map) -> Second

Now connect the record to the right Calendar vertex. If the usual way to retrieve Log records is by hour you could link the Log records in the Hour. Example:

    Year -> month (map) -> Month -> day (map) -> Day -> hour  (map) -> Hour -> log (set) -> Log

The "log" property connects the Time Unit to the Log records. So to retrieve all the log of March 2012, 20th at 10am:

```sql
SELECT expand( month[3].day[20].hour[10].logs ) FROM Year WHERE year = "2012"
```
That could be used as starting point to retrieve only a sub-set of logs that satisfy certain rules. Example:

```sql
SELECT FROM (
  SELECT expand( month[3].day[20].hour[10].logs ) FROM Year WHERE year = "2012"
) WHERE priority = 'critical'
```
That retrieves all the CRITICAL logs of March 2012, 20th at 10am.

# Join multiple hours #

If you need multiple hours/days/months as result set you can use the UNION function to create a unique result set:
```sql
SELECT expand( records ) from (
  SELECT union( month[3].day[20].hour[10].logs, month[3].day[20].hour[11].logs ) AS records
  FROM Year WHERE year = "2012"
)
```
In this example we create a union between the 10th and 11th hours. But what about extracting all the hours of a day without writing a huge query? The shortest way is using the Traverse. Below the Traverse to get all the hours of one day:

```sql
TRAVERSE hour FROM (
  SELECT expand( month[3].day[20] ) FROM Year WHERE year = "2012"
)
```

So putting all together this query will extract all the logs of all the hours in a day:

```sql
SELECT expand( logs ) FROM (
  SELECT union( logs ) AS logs FROM (
    TRAVERSE hour FROM (
     SELECT expand( month[3].day[20] ) FROM Year WHERE year = "2012"
    )
  )
)
```

# Aggregate #

Once you built up a Calendar in form of a Graph you can use it to store aggregated values and link them to the right Time Unit. Example: store all the winning ticket of Online Games. The record structure in our example is:
```json
{
  "date" : 12293289328932,
  "win" : 10.34,
  "machine" : "AKDJKD7673JJSH",
}
```

You can link this record to the closest Time Unit like in the example above, but you could sum all the records in the same Day and link it to the Day vertex. Example:

Create a new class to store the aggregated daily records:
```sql
CREATE CLASS DailyLog
```
Create the new record from an aggregation of the hour:
```sql
INSERT INTO DailyLog
SET win = (
  SELECT SUM(win) AS win FROM Hour WHERE date BETWEEN '2012-03-20 10:00:00' AND '2012-03-20 11:00:00'
)
```
Link it in the Calendar graph assuming the previous command returned #23:45 as the RecordId of the brand new DailyLog record:
```sql
UPDATE (
  SELECT expand( month[3].day[20] ) FROM Year WHERE year = "2012"
) ADD logs = #23:45
```
