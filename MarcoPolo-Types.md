---
search:
   keywords: ['Elixir', 'MarcoPolo', 'Types']
---

# MarcoPolo - Types

When you store data on the database, OrientDB sets it using the typing conventions of Java.  In turn, when MarcoPolo retrieves data from OrientDB, the return values use the typing conventions of Elixir.  This ensures that the Erlang VM can understand these return values.

Typing in Java is somewhat more granular than it is in Elixir.  For instance, where Elixir has the integer, Java has the 2-byte short, the 4-byte integer, and the 8-byte long.  Records created in MarcoPolo encode Elixir integers as the 4-byte Java integers.  In cases where you want to take advantage of Java typing in data storage or simply use the more granular types available in that language, you can set the type you want MarcoPolo to use when sending data to OrientDB.


## Typing in MarcoPolo

In any situation where you send data from your application to OrientDB, MarcoPolo converts the internal type in Elixir to a default type in Java.  So, for instance, if you set a boolean value on a record it gets set in OrientDB as the `java.lang.Boolean` type.

Java types that you retrieve from OrientDB are converted to their approximate Elixir type.  So, if you query OrientDB and retrieve an instance of `java.lang.Long` it is set in your application as an Elixir integer.

You can also force the type to store on OrientDB by using a tuple, where the first value is the type you want and the second the value you want to set.  For instance,

```elixir
data = {:long, 944}
```

Here, an integer in your application is sent to OrientDB as a long integer.

