# Chat Use Case

OrientDB allows modeling of rich and complex domains. If you want to develop a chat based application, you can use whatever you want to create the relationships between User and Room.

What we suggest is to avoid using Edges or Vertices connected with edges for messages. The best way is using the document API with no index to have super fast access to last X messages. In facts, OrientDB stores new records in append only, and the @rid is auto generated as incrementing. 

The 2 most common use cases in a chat are:
- writing a message in a chat room
- load last page of messages in a chat room

## Create a new message in the Chat Room

To create a new message in the chat room you can use this code:

```java
public addMessage(String chatRoom, String message, OUser user) {
  ODocument msg = new ODocument(chatRoom);
  msg.field( "date", new Date() );
  msg.field( "text", message );
  msg.field( "user", user );
  msg.save();
}
```

Example:

```java
addMessage("Client_34", "This is a test", database.getUser());
```

## Retrieve last messages
You can easily fetch pages of messages order by date desc by using the OrientDB's `@rid`:

```sql
select from Message order by @rid desc skip 0 limit 50
```

To load the 2nd (last) page:

```sql
select from Message order by @rid desc skip 50 limit 50
```

This is super fast and O(1) even with million of messages.
