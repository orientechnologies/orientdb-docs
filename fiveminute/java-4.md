# OrientDB for Java Developers in Five Minutes

In the [previous step](java-3.md) you established a DB connection from Java, then you created the DB schema (two classes and an index)

Now it's time to insert and query some data

## Step 5/5 - Create and Query a Graph

First of all, let's create three vertices: Alice, Bob and Jim


#### Creating vertices 

We are good Java developers, aren't we? Let's encaplusate a single vertex creation in a method:

```java
  private static OVertex createPerson(ODatabaseSession db, String name, String surname) {
    OVertex result = db.newVertex("Person");
    result.setProperty("name", name);
    result.setProperty("surname", surname);
    result.save();
    return result;
  }
```

*Wow, we never mentioned that people have a `surname`!!! In the previous section we just defined the schema for `name` property...*

OrientDB can work *schemaful* (with all the property names and types defined), *schemaless* (schema-free, no schema defined) or *schema-mixed* like in this case, where we define a part of the schema (ie. the `name`) but we leave the developer the ability to add new properties at run time, without having to deal with further schema definitions.

Now let's create the three vertices:

```java
  private static void createPeople(ODatabaseSession db){
    OVertex alice = createPerson(db, "Alice", "Foo");
    OVertex bob = createPerson(db, "Bob", "Bar");
    OVertex jim = createPerson(db, "Jim", "Baz");
  }
```

#### Creating edges

Suppose that Alice is a friend of Bob and that Bob is a friend of Jim:

```
Alice --FriendOf--> Bob --FriendOf--> Jim
```

Let's create the edges in the database:

```java
    OEdge edge1 = alice.addEdge(bob, "FriendOf");
    OEdge edge2 = bob.addEdge(jim, "FriendOf");
```

Please cosider that edges are plain documents, so you can get/set properties on them exactly like for vertices.


#### Executing queries

Last step of this journey: let's write and execute a simple query that finds friends of friends (FoaF) of a person.
We will use a [SELECT](../SQL/SQL-Query.md) for this.

```java
  private static void executeAQuery(ODatabaseSession db) {
    String query = "SELECT expand(out('FriendOf').out('FriendOf')) from Person where name = ?";
    OResultSet rs = db.query(query, "Alice");

    while (rs.hasNext()) {
      OResult item = rs.next();
      System.out.println("friend: " + item.getProperty("name"));
    }

    rs.close(); //REMEMBER TO ALWAYS CLOSE THE RESULT SET!!!
  }
```

or, if you prefer Java Streams API:

```java
  private static void executeAQuery(ODatabaseSession db) {
    String query = "SELECT expand(out('FriendOf').out('FriendOf')) from Person where name = ?";
    OResultSet rs = db.query(query, "Alice");
    rs.stream().forEach(x -> System.out.println("friend: " + x.getProperty("name")));
    rs.close();
  }
```

Let's try a more complex query, let's find all the people that are friends of both Alice and Jim.
We will use a [MATCH](../SQL/SQL-MATCH.md) for this.

```java
  private static void executeAnotherQuery(ODatabaseSession db) {
    String query =
        " MATCH                                           " +
        "   {class:Person, as:a, where: (name = :name1)}, " +
        "   {class:Person, as:b, where: (name = :name2)}, " +
        "   {as:a} -FriendOf-> {as:x} -FriendOf-> {as:b}  " +
        " RETURN x.name as friend                         ";

    Map<String, Object> params = new HashMap<String, Object>();
    params.put("name1", "Alice");
    params.put("name2", "Jim");

    OResultSet rs = db.query(query, params);

    while (rs.hasNext()) {
      OResult item = rs.next();
      System.out.println("friend: " + item.getProperty("name"));
    }

    rs.close();
  }
```

### Good job!!! This is your first OrientDB Java program!

Here is the full source code of the main class:

```java
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.orientechnologies.orient.core.db.OrientDB;
import com.orientechnologies.orient.core.db.OrientDBConfig;
import com.orientechnologies.orient.core.metadata.schema.OClass;
import com.orientechnologies.orient.core.metadata.schema.OType;
import com.orientechnologies.orient.core.record.OEdge;
import com.orientechnologies.orient.core.record.OVertex;
import com.orientechnologies.orient.core.sql.executor.OResult;
import com.orientechnologies.orient.core.sql.executor.OResultSet;

import java.util.HashMap;
import java.util.Map;

public class Main {

  public static void main(String[] args) {

    OrientDB orient = new OrientDB("remote:localhost", OrientDBConfig.defaultConfig());
    ODatabaseSession db = orient.open("test", "admin", "admin");

    createSchema(db);

    createPeople(db);

    executeAQuery(db);

    executeAnotherQuery(db);

    db.close();
    orient.close();

  }

  private static void createSchema(ODatabaseSession db) {
    OClass person = db.getClass("Person");

    if (person == null) {
      person = db.createVertexClass("Person");
    }

    if (person.getProperty("name") == null) {
      person.createProperty("name", OType.STRING);
      person.createIndex("Person_name_index", OClass.INDEX_TYPE.NOTUNIQUE, "name");
    }

    if (db.getClass("FriendOf") == null) {
      db.createEdgeClass("FriendOf");
    }

  }

  private static void createPeople(ODatabaseSession db) {
    OVertex alice = createPerson(db, "Alice", "Foo");
    OVertex bob = createPerson(db, "Bob", "Bar");
    OVertex jim = createPerson(db, "Jim", "Baz");

    OEdge edge1 = alice.addEdge(bob, "FriendOf");
    OEdge edge2 = bob.addEdge(jim, "FriendOf");
  }

  private static OVertex createPerson(ODatabaseSession db, String name, String surname) {
    OVertex result = db.newVertex("Person");
    result.setProperty("name", name);
    result.setProperty("surname", surname);
    result.save();
    return result;
  }

  private static void executeAQuery(ODatabaseSession db) {
    String query = "SELECT expand(out('FriendOf').out('FriendOf')) from Person where name = ?";
    OResultSet rs = db.query(query, "Alice");

    while (rs.hasNext()) {
      OResult item = rs.next();
      System.out.println("friend: " + item.getProperty("name"));
    }

    rs.close(); //REMEMBER TO ALWAYS CLOSE THE RESULT SET!!!
  }

  private static void executeAnotherQuery(ODatabaseSession db) {
    String query =
        " MATCH                                           " +
        "   {class:Person, as:a, where: (name = :name1)}, " +
        "   {class:Person, as:b, where: (name = :name2)}, " +
        "   {as:a} -FriendOf-> {as:x} -FriendOf-> {as:b}  " +
        " RETURN x.name as friend                         ";

    Map<String, Object> params = new HashMap<String, Object>();
    params.put("name1", "Alice");
    params.put("name2", "Jim");

    OResultSet rs = db.query(query, params);

    while (rs.hasNext()) {
      OResult item = rs.next();
      System.out.println("friend: " + item.getProperty("name"));
    }

    rs.close();
  }

}
```

## Next steps:

You may be interested in:
- [More details about the Java Multi-Model API](java/Java-MultiModel-API.md)
- [Full SQL Syntax](sql/README.md)


