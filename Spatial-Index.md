---
search:
   keywords: ['index', 'spatial index', 'Lucene']
---

# Lucene Spatial

(Versions 2.2 and after only, otherwise look at [Legacy](Spatial-Index.md#legacy) section)

This module is provided as external plugin. You can find it bundled in the GeoSpatial distribution, or you can add this plugin by yourself into any OrientDB distribution (Community and Enterprise Editions).

## Install

Download the plugin jar from maven central:

<pre><code class="lang-sh">http://central.maven.org/maven2/com/orientechnologies/orientdb-spatial/{{book.lastGA}}/orientdb-spatial-{{book.lastGA}}-dist.jar</code></pre>

After download, copy the jar to OrientDB lib directory (please make sure that the version of your OrientDB server and the version of the plugin are the same. Upgrade your OrientDB server, if necessary).
On *nix system it could be done this way:

<pre><code class="lang-sh">wget http://central.maven.org/maven2/com/orientechnologies/orientdb-spatial/{{book.lastGA}}/orientdb-spatial-{{book.lastGA}}-dist.jar
cp orientdb-spatial-{{book.lastGA}}-dist.jar /PATH/orientdb-community-{{book.lastGA}}/lib/
</code></pre>

OrientDB will load the spatial plugin on startup.

##Geometry Data

OrientDB supports the following Geometry objects :

* Point (**OPoint**)
* Line (**OLine**)
* Polygon (**OPolygon)**
* MultiPoint (**OMultiPoint**)
* MultiLine (**OMultiline**)
* MultiPolygon (**OMultiPlygon**)
* Geometry Collections 

OrientDB stores those objects like embedded documents with special classes.
The module creates abstract classes that represent each Geometry object type, and those classes
can be embedded in user defined classes to provide geospatial information.

Each spatial classes (Geometry Collection excluded) comes with field coordinates that will be used to store the geometry structure.
The "coordinates" field of a geometry object is composed of one position (Point), an array of positions (LineString or MultiPoint), an array of arrays of positions (Polygons, MultiLineStrings) or a multidimensional array of positions (MultiPolygon).

### Geometry data Example 

Restaurants Domain

```SQL
CREATE class Restaurant
CREATE PROPERTY Restaurant.name STRING
CREATE PROPERTY Restaurant.location EMBEDDED OPoint
```

To insert restaurants with location

From SQL
```SQL
INSERT INTO  Restaurant SET name = 'Dar Poeta', location = {"@class": "OPoint","coordinates" : [12.4684635,41.8914114]}
```

or as an alternative, if you use [WKT](https://it.wikipedia.org/wiki/Well-Known_Text) format you can use the function `ST_GeomFromText` to create the OrientDB geometry object.

```SQL
INSERT INTO  Restaurant SET name = 'Dar Poeta', location = St_GeomFromText("POINT (12.4684635 41.8914114)")
```


From JAVA

```JAVA
ODocument location = new ODocument("OPoint");
location.field("coordinates", Arrays.asList(12.4684635, 41.8914114));

ODocument doc = new ODocument("Restaurant");
doc.field("name","Dar Poeta");
doc.field("location",location);

doc.save();
```

A spatial index on the *location* field s defined by

```SQL
CREATE INDEX Restaurant.location ON Restaurant(location) SPATIAL ENGINE LUCENE"
```


## Functions

OrientDB follows The Open Geospatial Consortium [OGC](http://www.opengeospatial.org/standards/sfs) for extending SQL to support spatial data.
OrientDB implements a subset of SQL-MM functions with ST prefix (Spatial Type)

### ST_AsText

Syntax : ST_AsText(geom)

Example

```SQL
SELECT ST_AsText({"@class": "OPoint","coordinates" : [12.4684635,41.8914114]})

Result
----------
POINT (12.4684635 41.8914114)
```

### ST_GeomFromText

Syntax : ST_GeomFromText(text)

Example

```SQL
select ST_GeomFromText("POINT (12.4684635 41.8914114)")

Result
----------------------------------------------------------------------------------
{"@type":"d","@version":0,"@class":"OPoint","coordinates":[12.4684635,41.8914114]}

```

### ST_Equals

Returns true if geom1 is spatially equal to geom2

Syntax : ST_Equals(geom1,geom2)

Example
```SQL

SELECT ST_Equals(ST_GeomFromText('LINESTRING(0 0, 10 10)'), ST_GeomFromText('LINESTRING(0 0, 5 5, 10 10)'))

Result
-----------
true
```
### ST_Within

Returns true if geom1 is inside geom2

Syntax : ST_Within(geom1,geom2)

This function will use an index if available.

Example
```SQL
select * from City where  ST_WITHIN(location,'POLYGON ((12.314015 41.8262816, 12.314015 41.963125, 12.6605063 41.963125, 12.6605063 41.8262816, 12.314015 41.8262816))') = true
```

### ST_DWithin

Returns true if the geometries are within the specified distance of one another

Syntax : ST_DWithin(geom1,geom2,distance)


Example

```SQL
SELECT ST_DWithin(ST_GeomFromText('POLYGON((0 0, 10 0, 10 5, 0 5, 0 0))'), ST_GeomFromText('POLYGON((12 0, 14 0, 14 6, 12 6, 12 0))'), 2.0d) as distance
```

```SQL
SELECT from Polygon where ST_DWithin(geometry, ST_GeomFromText('POLYGON((12 0, 14 0, 14 6, 12 6, 12 0))'), 2.0) = true
```

### ST_Contains
Returns true if geom1 contains geom2

Syntax : ST_Contains(geom1,geom2)

This function will use an index if available.

Example
```SQL
SELECT ST_Contains(ST_Buffer(ST_GeomFromText('POINT(0 0)'),10),ST_GeomFromText('POINT(0 0)'))

Result
----------
true
```

```SQL
SELECT ST_Contains(ST_Buffer(ST_GeomFromText('POINT(0 0)'),10),ST_Buffer(ST_GeomFromText('POINT(0 0)'),20))

Result
----------
false
```

### ST_Disjoint
Returns true if geom1 does not spatially intersects geom2

Syntax: St_Disjoint(geom1,geom2)

This function does not use indexes

Example

```SQL
SELECT ST_Disjoint(ST_GeomFromText('POINT(0 0)'), ST_GeomFromText('LINESTRING ( 2 0, 0 2 )'));

Result
-----------------
true
```

```SQL
SELECT ST_Disjoint(ST_GeomFromText('POINT(0 0)'), ST_GeomFromText('LINESTRING ( 0 0, 0 2 )'));

Result
-----------------
false
```

### ST_Intersects
Returns true if geom1 spatially intersects geom2

Syntax: ST_Intersects(geom1,geom2)

Example

```SQL
SELECT ST_Intersects(ST_GeomFromText('POINT(0 0)'), ST_GeomFromText('LINESTRING ( 2 0, 0 2 )'));

Result
-------------
false
```

```SQL
SELECT ST_Intersects(ST_GeomFromText('POINT(0 0)'), ST_GeomFromText('LINESTRING ( 0 0, 0 2 )'));

Result
-------------
true
```

### ST_AsBinary
Returns the Well-Known Binary (WKB) representation of the geometry

Syntax :  ST_AsBinary(geometry)

Example

```SQL
SELECT ST_AsBinary(ST_GeomFromText('POINT(0 0)'))
```
### ST_Envelope 
Returns a geometry representing the bounding box of the supplied geometry

Syntax : ST_Envelope(geometry)

Example 

```SQL
SELECT ST_AsText(ST_Envelope(ST_GeomFromText('POINT(1 3)')));

Result
----------
POINT (1 3)
```

```SQL
SELECT ST_AsText(ST_Envelope(ST_GeomFromText('LINESTRING(0 0, 1 3)')))

Result
-----------------------------------
POLYGON ((0 0, 0 3, 1 3, 1 0, 0 0))
```
### ST_Buffer
Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance.

Syntax:  ST_Buffer(geometry,distance [,config])

where config is an additional parameter (JSON) that can be use to set:

quadSegs: int  ->  number of segments used to approximate a quarter circle (defaults to 8).

```JSON
{ 
  quadSegs : 1
}
```

endCap : round|flat|square ->  endcap style (defaults to "round").

```JSON
{
  endCap : 'square'
}
```

join : round|mitre|bevel  -> join style (defaults to "round")

``` JSON
{ 
  join : 'bevel'
}
```

mitre : double  -> mitre ratio limit (only affects mitered join style).


```JSON
{ 
  join : 'mitre', 
  mitre : 5.0
}
```


Example

```SQL
SELECT ST_AsText(ST_Buffer(ST_GeomFromText('POINT(100 90)'),50))
```


```SQL
SELECT ST_AsText(ST_Buffer(ST_GeomFromText('POINT(100 90)'), 50, { quadSegs : 2 }));
```
## Operators

### A && B

Overlaps operator. Returns true if bounding box of A overlaps bounding box of B.
This operator will use an index if available.

Example

```SQL
CREATE CLASS TestLineString
CREATE PROPERTY TestLineString.location EMBEDDED OLineString
INSERT INTO TestLineSTring SET name = 'Test1' , location = St_GeomFromText("LINESTRING(0 0, 3 3)")
INSERT INTO TestLineSTring SET name = 'Test2' , location = St_GeomFromText("LINESTRING(0 1, 0 5)")
SELECT FROM TestLineString WHERE location && "LINESTRING(1 2, 4 6)"
```

## Spatial Indexes

To speed up spatial search and match condition, spatial operators and functions can use a spatial index if defined to avoid sequential full scan of every records.

The current spatial index implementation is built upon lucene-spatial.

The syntax for creating a spatial index on a geometry field is :

```SQL
CREATE INDEX <name> ON <class-name> (geometry-field) SPATIAL ENGINE LUCENE
```


## Legacy

Before v2.2, OrientDB was able to only index Points. Other Shapes like rectangles and polygons are managed starting from v2.2 (look above). This is the legacy section for databases created before v2.2.

### How to create a Spatial Index

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

### How to query the Spatial Index

Two custom operators has been added to query the Spatial Index:
1. `NEAR`: to find all Points near a given location (`latitude`, `longitude`)
2. `WITHIN`: to find all Points that are within a given Shape

#### NEAR operator

Finds all Points near a given location (`latitude`, `longitude`).

##### Syntax

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

##### Examples

Let's take the example we have written before. We have a Spatial Index on Class `Place` on properties `latitude` and `longitude`.

Example: How to find the nearest Place of a given point:

```sql
SELECT *,$distance FROM Place WHERE [latitude,longitude,$spatial] NEAR [51.507222,-0.1275,{"maxDistance":1}]
```

#### WITHIN operator
Finds all Points that are within a given Shape.

| | |
|----|-----|
|![](images/warning.png)|The current release supports only **Bounding Box** shape|

##### Syntax

```sql
SELECT FROM Class WHERE [<lat field>,<long field>] WITHIN [ [ <lat1>, <lon1> ] , [ <lat2>, <lon2> ] ... ]
```

##### Examples

Example with previous configuration:

```sql
SELECT * FROM Places WHERE [latitude,longitude] WITHIN [[51.507222,-0.1275],[55.507222,-0.1275]]
```

This query will return all Places within the given Bounding Box.
