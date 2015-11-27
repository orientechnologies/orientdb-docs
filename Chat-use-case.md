<!-- proofread 2015-11-26 SAM -->
# Chat Use Case

OrientDB allows modeling of rich and complex domains. If you want to develop a chat based application, you can use whatever you want to create the relationships between User and Room.

We suggest avoiding using Edges or Vertices connected with edges for messages. The best way is using the document API by creating one class per chat room, with no index, to have super fast access to last X messages. In facts, OrientDB stores new records in append only, and the @rid is auto generated as incrementing. 

The 2 most common use cases in a chat are:
- writing a message in a chat room
- load last page of messages in a chat room

## Create the initial schema

In order to work with the chat rooms, the rule of the thumb is creating a base abstract class ("ChatRoom") and then let to the concrete classes to represent individual ChatRooms.

### Create the base ChatRoom class

```sql
create class ChatRoom
alter class ChatRoom abstract true
create property ChatRoom.date datetime
create property ChatRoom.text string
create property ChatRoom.user LINK OUser
```

### Create a new ChatRoom

```sql
create class ItalianRestaurant extends ChatRoom
```

Class "ItalianRestaurant" will extend all the properties from ChatRoom.

Why creating a base class? Because you could always execute polymorphic queries that are cross-chatrooms, like get all the message from user "Luca":

```sql
select from ChatRoom where user.name = 'Luca'
```

## Create a new message in the Chat Room

To create a new message in the chat room you can use this code:

```java
public ODocument addMessage(String chatRoom, String message, OUser user) {
  ODocument msg = new ODocument(chatRoom);
  msg.field( "date", new Date() );
  msg.field( "text", message );
  msg.field( "user", user );
  msg.save();
  return msg;
}
```

Example:

```java
addMessage("ItalianRestaurant", "Have you ever been at Ponza island?", database.getUser());
```

## Retrieve last messages
You can easily fetch pages of messages ordered by date in descending order, by using the OrientDB's `@rid`. Example:

```sql
select from ItalianRestaurant order by @rid desc skip 0 limit 50
```

You could write a generic method to access to a page of messages, like this:

```java
public Iterable<ODocument> loadMessages(String chatRoom, fromLast, pageSize) {
  return graph.getRawGraph().command("select from " + chatRoom + " order by @rid desc skip " + fromLast + " limit " + pageSize).execute();
}
```

Loading the 2nd (last) page from chat "ItalianRestaurant", would become this query (with pageSize = 50):

```sql
select from ItalianRestaurant order by @rid desc skip 50 limit 50
```

This is super fast and O(1) even with million of messages.

## Limitations

Since OrientDB can handle only 32k clusters, you could have maximum 32k chat rooms. Unless you want to rewrite the entire [FreeNode](https://freenode.net/index.shtml), 32k chat rooms will be more than enough for most of the cases. 

However, if you need more than 32k chat rooms, the suggested solution is still using this approach, but with multiple databases (even on the same server, because one OrientDB Server instance can handle thousands of databases concurrently).

In this case you could use one database to handle all the metadata, like the following classes:
- **ChatRoom**, containing all the chatrooms, and the database where are stored. Example: `{ "@class": "ChatRoom", "description": "OrientDB public channel", "databaseName", "db1", "clusterName": "orientdb" }`
- **User**, containing all the information about accounts with the edges to the ChatRoom vertices where they are subscribed

OrientDB cannot handle cross-database links, so when you want to know the message's author, you have to look up into the "Metadata" database by @RID (that is O(1)).