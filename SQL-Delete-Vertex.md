# SQL - DELETE VERTEX

This command deletes one or more vertices from the database. Use this command if you work against graphs. The "Delete Vertex" (like the [Delete Edge](SQL-Delete-Edge.md)) command takes care to remove all the cross references to the vertices in all the edges involved.

## Syntax

```sql
DELETE VERTEX <rid>|<class>|FROM (<subquery>) [WHERE <conditions>] [LIMIT <MaxRecords>>] [BATCH <batch-size>]
```
Where:
- [WHERE](SQL-Where.md) clause is common to the other SQL commands.
- `BATCH` optional block (since v2.1) gets the `<batch-size>` to execute the command in small blocks, avoiding memory problems when the number of vertices is high (Transaction consumes RAM). By default is 100.


# History and Compatibility
- 1.1: first version
- starting from v.1.4 the command uses the Blueprints API under the hood, so if you're working in Java using the OGraphDatabase API you could experience in some difference how edges are managed. To force the command to work with the "old" API change the GraphDB settings described in [Graph backward compatibility](SQL-Alter-Database.md#use-graphdb-created-with-releases-before-14)
- 2.1: added optional BATCH block

# Examples

Deletes the vertex, and disconnects all vertices pointing towards it:
```sql
DELETE VERTEX #10:231
```

Deletes all user accounts which are marked with an incoming edge of class BadBehaviorInForum:
```sql
DELETE VERTEX Account WHERE in.@Class CONTAINS 'BadBehaviorInForum'
```

Deletes all those EmailMessages which are marked as spam by isSpam property
```sql
DELETE VERTEX EMailMessage WHERE isSpam = true
```

Deletes every vertex of class 'Attachment', which has an edge towards it of class 'HasAttachment', with a property 'date' of condition to be all (HasAttachment edges) which are older than 1990, and secondly, the vertex 'Email' which is connected to class Attachment has a condition on its property 'from' to be 'some...@example.com':
```sql
DELETE VERTEX Attachment WHERE in[@Class = 'HasAttachment'].date <= "1990" AND in.out[@Class = "Email"].from = 'some...@example.com'
```

Deletes all the vertices in blocks of 1000 each (Since v2.1)
```sql
DELETE VERTEX v BATCH 1000
```
