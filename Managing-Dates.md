# Managing Dates

In OrientDB dates are first class citizen. OrientDB internally saves dates in [unixtime format](https://en.wikipedia.org/wiki/Unix_time) as a long containing the milliseconds since Jan 1st 1970.

## Dates before 1970

To save dates before Jan 1st 1970, use negative numbers.

Example on setting the date of funding of Rome city (April 21st 753 BC)
```sql
alter database datetimeformat "MMM dd HH:mm:ss yyyy GG"
create vertex v set date = date("APR 21 00:00:00 753 BC")
select date.asLong() from #9:4
```


