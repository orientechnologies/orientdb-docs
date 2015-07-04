# Managing Dates

In OrientDB dates are first class citizen. OrientDB internally saves dates in [unixtime format](https://en.wikipedia.org/wiki/Unix_time) as a `long` containing the milliseconds since **Jan 1st 1970**.

## Date and Datetime formats

By default the following formats are used on a new database:
- Date format: `yyyy-MM-dd`
- Datetime format: `yyyy-MM-dd HH:mm:ss`

To change this global setting, use the [ALTER DATABASE](SQL-Alter-Database) SQL comamnd. Example on setting dates with English format:

```sql
alter database dateformat "dd MMMM yyyy"
```

## SQL
In order to simplify management of dates, OrientDB SQL parses automatically dates from/to strings and longs. The following functions come in rescue to have more control on how dates are managed:
- [date()](SQL-Functions.md#date) to convert dates from/to string/date, also with custom format
- [sysdate()](SQL-Functions.md#sysdate) to represent current date
- [.format()](SQL-Methods.md#format) to format the date using different formats
- [.asDate()](SQL-Methods.md#asdate) to convert any type into a date
- [.asDatetime()](SQL-Methods.md#asdatetime) to convert any type into a datetime
- [.asLong()](SQL-Methods.md#aslong) to convert any date in long format (unixtime)

## Dates before 1970

To save dates before Jan 1st 1970, use negative numbers.

Example on setting the date about the fundation of [Rome, Italy](https://en.wikipedia.org/wiki/Unix_time) (April 21st 753 BC). To insert dates Before Christ, let's add the "era/epoch" as "GG" in database date and datetimes formats:

```sql
alter database datetimeformat "yyyy-MM-dd HH:mm:ss GG"

create vertex v set city = "Rome", date = date("0753-04-21 00:00:00 BC")
```

This is the result:
```
#9:10 | Rome | 0753-04-21 00:00:00 BC
```

You could also not change the database date/time format, and use the format onat insertion time:

```sql
create vertex v set city = "Rome", date = date("0753-04-21 00:00:00 BC", "yyyy-MM-dd HH:mm:ss GG")
```

To see the underlying long (unixtime) stored, let's convert it to long with `asLong()` for the record just inserted:

```sql
select date.asLong() from #9:4
```

This is the result:
```
-85889120400000
```

So Apr 21st 753 BC is represented as `-85889120400000` in unixtime. We can also work with dates directly with longs:

```sql
create vertex v set city = "Rome", date = date(-85889120400000)
```

The result is identical to the previous one:
```
#9:11 | 1 | V | Rome |0753-04-21 00:00:00 BC
```

