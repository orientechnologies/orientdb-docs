# PyOrient OGM - Brokers

The mapping that the PyOrient OGM creates between Python classes and the OrientDB database schema happens on a few different levels.  In [Schemas](PyOrient-OGM-Schemas.md) you can see how it forms connections between classes in your application and database.  Brokers handle the mapping between objects in a given Python class and the specific vertices and edges in the OrientDB database.

## Using Brokers

When the OGM creates a mapping between Python classes and vertex or edges classes in the OrientDB schema, for each class it creates a broker to handle instances of that class.  The broker provides you with an interface in working with various types of vertices and edges in your graph.  They can also reduce coupling and hide the classes that you have mapped, to help focus on the interfaces that they expose.

For instance, consider the example of a smart home application that uses OrientDB as its back-end database.  You might create a class in your application and on OrientDB to manage home-built Arduino or Micro Python environmental sensors.

```py
# Initialize Graph Database
graph = pyorient.ogm.Graph(
   pyorient.ogm.Config.from_url(
      'smarthome', 'root', 'root'))
Node = pyorient.ogm.declarative.declarative_node()

# Sensor Control Class
class Sensor(Node):
   element_plural = 'sensors'
   name = String()
   zone = String()

# Create a 'sensors' bject and set the 'objects' attribute
graph.include(Node.registry)
```

In the example, you create a Python class for your sensors and register it with the OGM.  Given that you already have sensor data on OrientDB, you use the `include()` method to map the registry to a vertex class in OrientDB.

When you create classes that map to vertex and edge classes in OrientDB, you must define a particular attribute: `element_plural` for a node and `label` for a relationship.  PyOrient uses this class variable in setting the broker attribute for the class.  Meaning that, in the example above, `Sensor.objects` and `graph.sensors` are synonymous.  Thus,

```py
# Create Smoke Alarm (Method 1)
g.sensors.create(
   name = 'smokeAlarm',
   zone = 'kitchen')

# Create Light Sensor (Method 2)
Sensor.objects.create(
   name = 'lightSensor',
   zone = 'kitchen')
```

When you create vertex classes without `element_plural` attribute or edge classes without the `label` attribute, PyOrient does not create a broker.  Meaning, in such cases, the first method shown above won't work.

You can then query the results using the `query()` method:

```py
results = graph.query(Sensor, name = 'smokeAlarm')
```

### Manual Vertex and Edge Creation

The `create()` method show above hides whether you are creating a vertex or an edge in OrientDB.  Using the manual create methods `create_vertex()` and `create_edge()`, you can optionally make your application more explicit.  For instance,

```py
graph.create_vertex(
   Sensor,
   name = 'smokeAlarm', 
   zone = 'kitchen')
```


## Working with Properties

In the example above, when the OGM maps the Python `Sensor` class to OrientDB, attributes on that class map to properties on the vertex, (that is, `name` and `zone`).  OrientDB and PyOrient support a range of property types.  Some basic examples are,

| Numeric Types | Other |
|---|---|
| Boolean | String |
| Byte | Date |
| Integer | DateTime |
| Short | Binary |
| Long | Embedded |
| Float |  |
| Double | |
| Decimal| |

>For more information on types supported by OrientDB, see [Types](Types.md).
