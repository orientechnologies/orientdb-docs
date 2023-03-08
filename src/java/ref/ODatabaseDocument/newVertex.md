
# ODatabaseDocument - newVertex()

This method creates a new vertex on the database.

## Creating Vertices

When using OrientDB to host a Graph database, this method allows you to create vertices on the database.  To create new edges, see the [`newEdge()`](newEdge.md) method.

### Syntax

This method comes in three forms.  The first creates the vertex in the default OrientDB class `V`.  The others allow you to manually define what class the new vertex belongs to:

```
// METHOD 1
default OVertex ODatabaseDocument().newVertex()

// METHOD 2
OVertex ODatabaseDocument().newVertex(OClass class)

// METHOD 3
OVertex ODatabaseDocument().newVertex(String class-name)
```

| Argument | Type | Description |
|---|---|---|
| **`class`** | [`OClass`](../OClass.md) | Defines the OrientDB class |
| **`class-name`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the name of the OrientDBG class |

#### Return Value

This method returns an [`OVertex`](../OVertex.md) instance.  You can call additional methods on this instance to set data to it, then call `save()` to make that data persistent on OrientDB.

### Example

Imagine you have a social networking application.  The application stores users under the `User` class on OrientDB and content sources under the `Feed` class.  Whenever a new user sets up their account, they're automatically subscribed to a series of content sources, which provides news, popular feeds and sponsored results.

To accomplish this, you might use a method to create new user accounts and default subscriptions:

```java
// INITIALIZE DEFAULT VARIABLES
private ODatabaseDocument db;
private List<ORID> defaultFeeds;
...

// CREATE NEW USER
public void newUser(String name, String email){

   // Log Operation
   logger.info("Creating New User");

   // Create New User
   OVertex user = db.newVertex("User");
   user.setProperty("name", name);
   user.setProperty("email", email);
   user.save();

   // Set Default Subscriptions
   for (int i = 0; i < defaultFeeds.size(); i++){

      // Fetch Record ID
	  ORID rid = defaultFeeds.get(i);

      // Fetch Feed Vertex
	  OVertex feed = db.getRecord(rid);

	  // Create and Save Edge
	  OEdge edge = db.newEdge(user, feed);
	  edge.save();

   }
}
```
