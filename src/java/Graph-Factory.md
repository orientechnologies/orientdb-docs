
# Graph Factory

The [TinkerPop Blueprints](https://github.com/tinkerpop/blueprints/wiki) standard does not implement a proper "factory" method for creating and pooling Graph Database instances.  In applications based on OrientDB, you may occasionally encounter legacy workarounds that attempt to implement this feature by mixing the Graph and Document API's.

With the introduction of the `OrientGraphFactory` class, managing graphs is much simpler.

- By default, the class acts as a factory, creating new Graph Database instances every time.
- You can configure it to work as a pool, recycling Graph Database instances as need.
- When running in PLocal mode, if the database itself doesn't exist, the class creates it for you.
- It returns both transactional and non-transactional Graph Database instances.
- When you call the `shutdown()` method, it returns the pooled instance so that you can reuse the pool.

## Using Graph Factories

Using a Graph Factory in your application is relatively straightforward.  First, create and configure a factory instance using the `OrientGraphFactory` class.  Then, use the factory whenever you need to create an `OrientGraph` instance and shut it down to return it to the pool.  When you're done with the factory, close it to release all instances and free up system resources.


### Creating Factories

The basic way to create the factory with the default user `admin`, (which passes the password `admin`, by default): 

```java
OrientGraphFactory factory = new OrientGraphFactory("plocal:/temp/mydb");
```

In the event that you have implemented basic security housekeeping on your database, like changing the default `admin` password or if you want to use a different user, you can pass the username and password as arguments to `OrientGraphFactory`:

```java
OrientGraphFactory factory = new OrientGraphFactory("plocal:/temp/mydb", "jayminer", "amigarocks");
```

#### Recycling Pools

In addition to creating new Graph Database instances, the factory can also create recyclable pools, by using the `setPool()` method:

```java
OrientGraphFactory factory = new OrientGraphFactory("plocal:/temp/mydb").setupPool(1, 10);
```

This sets the pool up to use a minimum of 1 and a maximum of 10 Graph Database instances.

### Using Graph Instances

Once you create and configure the factory, you can get the Graph Database instance to start using it with your application.  OrientDB provides three methods for getting this instance.  Which you use depends on preference and whether you want a transactional instance.

- To retrieve a transactional instance, use the `getTx()` method on your factory object:

  ```java
  OrientGraph txGraph = factory.getTx();
  ```
  
- To retrieve a non-transactional instance, use the `getNoTx()` method on your factory object:

  ```java
  OrientGraphNoTx noTxGraph = factory.getNoTx();
  ```
- Alternatively, if you plan to get several Graph Database instances of the same type, you can use the `setTransactional()` method to define the kind you want, then use the `get()` method for each instance you retrieve:

  ```java
  factory.setTransactional(false);
  OrientGraphNoTx noTxGraph = (OrientGraphNoTx) factory.get();
  ```

### Shutting Down Graph Instances

When you're done with a Graph Database instance, you can return it to the pool by calling the `shutdown()` method on the instance.  This method does not close the instance.  The instance remains open and available for the next requester:
 
```java
graph.shutdown();
```

### Releasing the Graph Factory

When you're ready to release all instances, call the `close()` method on the factory.  In the case of pool usage, this also frees up the system resources claimed by the pool:

```java
factory.close();
```



