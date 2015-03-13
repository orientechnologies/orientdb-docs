# Graph Factory

[TinkerPop Blueprints](https://github.com/tinkerpop/blueprints/wiki) standard doesn’t define a proper "Factory" to get graph instances. For this reason OrientDB users that wanted to use a pool of instances had to mix 2 different API: Graph and Document one. Example:

```java
ODatabaseDocumentPool pool = new ODatabaseDocumentPool("plocal:/temp/mydb");
OrientGraph g = new OrientGraph(pool.acquire());
 ```

Now everything is simpler, thanks to the new OrientGraphFactory class to manage graphs in easy way. These are the main features:
- by default acts as a factory by creating new database instances every time
- can be configured to work as a pool, by recycling database instances
- if the database doesn’t exist, it’s created automatically (but in "remote" mode)
- returns transactional and non-transactional instances
- on `graph.shutdown()` the pooled instance is returned to the pool to be reused

This is the basic way to create the factory, by using the default "admin" user (with "admin" password by default):

```java
OrientGraphFactory factory = new OrientGraphFactory("plocal:/temp/mydb");
```

But you can also pass user and password:

```java
OrientGraphFactory factory = new OrientGraphFactory("plocal:/temp/mydb", "jayminer", "amigarocks");
```

To work with a recyclable pool of instances with minimum 1, maximum 10 instances:

```java
OrientGraphFactory factory = new OrientGraphFactory("plocal:/temp/mydb").setupPool(1, 10);
```

Once the factory is configured you can get a Graph instance to start working. OrientGraphFactory has 2 methods to retrieve a Transactional and Non-Transactional instance:

```java
OrientGraph txGraph = factory.getTx();
OrientGraphNoTx noTxGraph = factory.getNoTx();
```

Or again you can configure in the factory the instances you want and use the get() method every time:

```java
factory.setTransactional(false);
OrientGraphNoTx noTxGraph = (OrientGraphNoTx) factory.get();
```

To return the Graph instance to the pool, call the shutdown method on graph instance. `shutdown()` will not close the graph instance, but will keep open and available for the next requester:

```java
graph.shutdown();
```

To release all the instances and free all the resources (in case of pool usage), call the close():

```java
factory.close();
```
