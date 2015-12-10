<!-- proofread 2015-12-10 SAM -->

# Lucene Spatial

For now the Index Engine can only index Points. Other Shapes like rectangles and polygons will be added in the future.

## How to create a Spatial Index

The index can be created on a class that has two fields declared as `DOUBLE` (`latitude`,`longitude`) that are the coordinates of the Point.

For example we have a class `Place` with 2 double fields `latitude` and `longitude`.  To create the spatial index on `Place` use this syntax.

```sql
CREATE INDEX Place.l_lon ON Place(latitude,longitude) SPATIAL ENGINE LUCENE
```

The Index can also be created with the Java Api. Example:

```java
OSchema schema = databaseDocumentTx.getMetadata().getSchema();
OClass oClass = schema.createClass("Place");
oClass.createProperty("latitude", OType.DOUBLE);
oClass.createProperty("longitude", OType.DOUBLE);
oClass.createProperty("name", OType.STRING);
oClass.createIndex("Place.latitude_longitude", "SPATIAL", null, null, "LUCENE", new String[] { "latitude", "longitude" });
```

## How to query the Spatial Index

Two custom operators has been added to query the Spatial Index:
1. `NEAR`: to find all Points near a given location (`latitude`, `longitude`)
2. `WITHIN`: to find all Points that are within a given Shape

### NEAR operator

Finds all Points near a given location (`latitude`, `longitude`).

#### Syntax

```sql
SELECT FROM Class WHERE [<lat-field>,<long-field>] NEAR [lat,lon]
```

To specify `maxDistance` we have to pass a special variable in the context:

```sql
SELECT FROM Class WHERE [<lat-field>,<long-field>,$spatial] NEAR [lat,lon,{"maxDistance": distance}]
```

The `maxDistance` field has to be in kilometers, not radians. Results are sorted from nearest to farthest.

To know the exact distance between your Point and the Points matched, use the special variable in the context
$distance.

```sql
SELECT *, $distance FROM Class WHERE [<lat-field>,<long-field>,$spatial] NEAR [lat,lon,{"maxDistance": distance}]
```

#### Examples

Let's take the example we have written before. We have a Spatial Index on Class `Place` on properties `latitude` and `longitude`.

Example: How to find the nearest Place of a given point:

```sql
SELECT *,$distance FROM Place WHERE [latitude,longitude,$spatial] NEAR [51.507222,-0.1275,{"maxDistance":1}]
```

### WITHIN operator
Finds all Points that are within a given Shape.

| | |
|----|-----|
|![](images/warning.png)|The current release supports only **Bounding Box** shape|

#### Syntax

```sql
SELECT FROM Class WHERE [<lat field>,<long field>] WITHIN [ [ <lat1>, <lon1> ] , [ <lat2>, <lon2> ] ... ]
```

#### Examples

Example with previous configuration:

```sql
SELECT * FROM Places WHERE [latitude,longitude] WITHIN [[51.507222,-0.1275],[55.507222,-0.1275]]
```

This query will return all Places within the given Bounding Box.

## Future Plans

In OrientDB 2.2 a new [Spatial-Module](Spatial-Module.md) will replace this implementation
with:

- GeoSpatial standard (ST_*) functions 
- Index All types of shape

