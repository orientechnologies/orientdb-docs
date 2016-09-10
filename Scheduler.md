---
search:
   keywords: ['scheduler', 'schedule']
---

# Scheduler

OrientDB has a Scheduler of events you can use to fire your events on regular basis. To manage events you can use both SQL and Java API. The scheduler gets the popular [CRON expression](https://en.wikipedia.org/wiki/Cron#CRON_expression) syntax. The scheduled event, when fired, executes a Database 

## Resources
- [CRON expressions on Wikipedia](https://en.wikipedia.org/wiki/Cron#CRON_expression)
- [CRON expression maker](http://www.cronmaker.com/) is an online resource to create CRON expressions

## Schedule an event

### Via SQL

In order to schedule a new event via SQL, all you need is to create a new record in the `OSchedule` class. Example on scheduling the event "myEvent" that calls the function "myFunction" every second:

```sql
INSERT INTO oschedule
  SET name = 'myEvent',
      function = (SELECT FROM ofunction WHERE name = 'myFunction'),
      rule = \"0/1 * * * * ?\"
```

### Via Java API
```java
db.getMetadata().getScheduler().scheduleEvent(
  new OScheduledEventBuilder().setName("myEvent").setRule("0/1 * * * * ?")
  .setFunction(func).build());
```
## Update an event

### Via SQL

To update the scheduling of an event, update the record with the new `rule`. Example:

```sql
UPDATE oschedule SET rule = "0/2 * * * * ?" WHERE name = 'myEvent'
```

### Via Java API

To update an event, remove it and reschedule it.

```java
db.getMetadata().getScheduler().removeEvent("myEvent");
db.getMetadata().getScheduler().scheduleEvent(
  new OScheduledEventBuilder().setName("myEvent").setRule("0/2 * * * * ?")
  .setFunction(func).build());
```

## Remove an event

### Via SQL

To cancel a scheduled event, just delete the record. Example:

```sql
DELETE oschedule WHERE name = 'myEvent'
```

### Via Java API

```java
db.getMetadata().getScheduler().removeEvent("myEvent");
```

## Tutorial

In this tutorial we want to purge all the records older than 1 year. 

### 1) Create a [Function](Functions-Creation.md)
First, create a SQL function that delete the records. To have the date of 1y ago you can use the expression `sysdate() - 31536000000`, where 31536000000 represents the number of milliseconds in a year.  You can this via SQL or Java API.

#### Via [SQL](SQL-Create-Function.md)
```sql
CREATE FUNCTION purgeHistoricalRecords
  "DELETE FROM Logs WHERE date < ( sysdate() - 31536000000 )"
  LANGUAGE SQL 
```

#### Via Java API
```java
OFunction func = db.getMetadata().getFunctionLibrary().createFunction("purgeHistoricalRecords");
func.setLanguage("SQL");
func.setCode("DELETE FROM Logs WHERE date < ( sysdate() - 31536000000 )");
func.save();
return func;
```

### 2) Schedule the event

The second step is scheduling the event. The CRON expression for "every midnight" is `00 00 * * * ?`. You can this via SQL or Java API.

#### Via SQL

```sql
INSERT INTO oschedule
 SET name = 'purgeHistoricalRecordsAtMidnight',
     function = (SELECT FROM ofunction WHERE name = 'purgeHistoricalRecords'),
     rule = \"00 00 * * * ?\"
```

#### Via Java API
```java
db.command(new OCommandSQL(
 "INSERT INTO oschedule SET name = 'purgeHistoricalRecordsAtMidnight', function = ?, rule = \"00 00 * * * ?\""))
 .execute(func.getId());
```
