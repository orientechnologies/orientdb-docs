<!-- proofread 2015-12-10 SAM -->
# Spatial Module

(Versions 2.2 and after only)Replacement for [Spatial-Index](Spatial-Index.md)

OrientDB offers a brand new module to handle geospatial information provided as external plugin.  

##Install

Download the plugin jar from maven central

    http://central.maven.org/maven2/com/orientechnologies/orientdb-spatial/VERSION/orientdb-spatial-VERSION-dist.jar

where **VERSION** must be the same of the OrientDB installation.
After download, copy the jar to orient plugins directory.
On *nix system it could be done this way:

```console
wget  http://central.maven.org/maven2/com/orientechnologies/orientdb-spatial/VERSION/orientdb-spatial-VERSION-dist.jar
cp orientdb-spatial-VERSION-dist.jar /PATH/orientdb-community-VERSION/plugins/
```

Orient db will load the spatial plugin on startup.

##Geometry Data

OrientDB supports the following Geometry objects :

* Point
* Line
* Polygon
* MultiPoint
* MultiLine
* MultiPolygon
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


OrientDB follows The Open Geospatial Consortium [OGC](http://www.opengeospatial.org/standards/sfs) for extending SQL to support spatial data.
OrientDB implements a subset of SQL-MM functions with ST prefix (Spatial Type)

## Functions

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

## Install 

### 2.2.0-SNAPSHOT

The module has been merged into the main repository branch [develop](https://github.com/orientechnologies/orientdb/tree/develop)
* Take the latest OrientDB 2.2.0-Snapshot [here](https://oss.sonatype.org/content/repositories/snapshots/com/orientechnologies/orientdb-community/2.2.0-SNAPSHOT/)

Or

build the develop branch from scratch


### 2.2 GA

This module is part of orientdb-lucene plugin and will be included in OrientDB 2.2 GA
