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

Here, an integer in your application is sent to OrientDB as a long integer.  When your application retrieves a long integer, it is set on your application as an integer. 


### Numeric Types

- **Integers**: `83` or `{:int, 83`
  - Typed in OrientDB as `java.lang.Integer` or `int`
  - Returned to MarcoPolo as `83` 
- **Short Integers**: `{:short, 83}`
  - Typed in OrientDB as `java.lang.Short` or `short`
  - Returned to MarcoPolo as `83`
- **Long Integer**: `{:long, 83}` 
  - Typed in OrientDB as `java.lang.Long` or `long`
  - Returned to MarcoPolo as `83`
- **Doubles**: `3.14`
  - Typed in OrientDB as `java.lang.Double` or `double`
  - Returned to MarcoPolo as `3.14`
- **Floats**: `{:float, 3.14}`
  - Typed in OrientDB as `java.lang.Float` or `float`
  - Returned to MarcoPolo as `3.14`
- **Decminals**: Using [Decimal](https://github.com/ericmj/decimal), `Decimal.new(3.14)`
  - Typed in OrientDB as `java.math.BigDecimal`
  - Returned to MarcoPolo as `Decimal.new(3.14)`

### Date and Time Types

- **Date**: Using [Date](MarcoPolo-Structs.md#date), `%MarcoPolo.Date{year: 2017, month: 5, day: 5}`
  - Typed in OrientDB as `java.util.Date`
  - Returned to MarcoPolo as `%MarcoPolo.Date{year: 2017 month: 5 day: 5}`
- **DateTime**: Using [DateTime](MarcoPolo-Structs.md#datetime), `%MarcoPolo.DateTime{year: 2017,i month: 5, day: 5, hour: 15, minute: 30, sec: 0, msec: 0}`
  - Typed in OrientDB as `java.util.Date`
  - Returned to MarcoPolo as `%MarcoPolo.DateTime{year: 2017,i month: 5, day: 5, hour: 15, minute: 30, sec: 0, msec: 0}`

### Embedded Types

- **Document**: Using [Document](MarcoPolo-Structs.md#document), `%MarcoPolo.Document{}`
  - Typed in OrientDB as `ORecord`
  - Returned to MarcoPolo as the same value.
- **List**: `[1, "foo", {:float, 3.14}]`
  - Typed in OrientDB as `List<Object>`
  - Returned ot MarcoPolo as `[1, "foo", 3.14`
- **Hash Set**: `#HashSet<[2, 1]>`
  - Typed in OrientDB as `Set<Object>`
  - Returned to MarcoPolo as `#HashSet<[2, 1]>`
- **Map**: `%{"foo" => true}`
  - Typed in OrientDB as `Map<String, ORecord>`
  - Returned to MarcoPolo as `%{"foo" => true}`

### Link Types

- **Link**: Using [RID](MarcoPolo-Structs.md#rid), `%MarcoPolo.RID{cluster_id: 21, position: 3}` 
  - Typed in OrientDB as `ORID` 
  - Returned to MarcoPolo as `%MarcoPolo.RID{cluster_id: 21, position: 3}`
- **Link List**: `{:link_list, [%MarcoPolo.RID{}, ...]}` 
  - Typed in OrientDB as `List<ORID>` 
  - Returned to MarcoPolo as `{:link_list, [%MarcoPolo.RID{}, ...]}`
- **Link Set**: `{:link_set, #HashSet<%MarcoPolo.RID{}, ...>}`
  - Typed in OrientDB as `SET<ORID>`
  - Returned to MarcoPolo as `{:link_set, #HashSet<%MarcoPolo.RID{}, ...>}`
- **Link Map**: `{:link_map, %{"foo" => %MarcoPolo.RID{}, ...}}`
  - Typed in OrientDB as `Map<String, ORID>`
  - Returned to MarcoPolo as `{:link_map, %{"foo" => %MarcoPolo.RID{}, ...}}`


### Other Types 

- **Binary**: `{:binary, <<7, 2>>`
  - Typed in OrientDB as `byte[]`
  - Returned to MarcoPolo as `<<7, 2>>`
- **Boolean**: `true` or `false`
  - Typed in OrientDB as `java.lang.Boolean`
  - Returned to MarcoPolo as same value. 
- **String**: `"foo"` or `<<1, 2, 3>>`
  - Typed in OrientDB as `java.lang.String`
  - Returned to MarcoPolo as the same value. 
