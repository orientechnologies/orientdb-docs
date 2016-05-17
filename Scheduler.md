# Scheduler

OrientDB has a scheduler of events you can use to fire your events on regular basis.

## Tutorial

In this tutorial we want to purge all the records older than 1 year. 

### 1) Create a [Function](Function.md)
First, create a SQL function that delete the records. To have the date of 1y ago you can use the expression `sysdate() - 31536000`, where 31536000000 represents the number of milliseconds in a year.  You can this via SQL or Java API.

From SQL:
```sql
INSERT INTO ofunction SET name = "purgeHistoricalRecords", language = "SQL", code = "DELETE FROM Logs WHERE date < ( sysdate() - 31536000000 )"
```

From Java API:
```java
OFunction func = db.getMetadata().getFunctionLibrary().createFunction("purgeHistoricalRecords");
func.setLanguage("SQL");
func.setCode("DELETE FROM Logs WHERE date < ( sysdate() - 31536000000 )");
func.save();
return func;
```

### 2) Schedule the event

The second step is scheduling the event. The CRON expression for "every midnight" is `00 00 * * * ?`. You can this via SQL or Java API.
From SQL:
```sql
INSERT INTO oschedule SET name = 'test', function = purgeHistoricalRecords, rule = \"00 00 * * * ?\"
```

From Java API:
```java
db.command(new OCommandSQL("insert into oschedule set name = 'test', function = ?, rule = \"00 00 * * * ?\""))
  .execute(func.getId());
```
