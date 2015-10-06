# Spatial Module

(since 2.2) Replacement for [Spatial-Index](Spatial-Index.md)


OrientDB offers a brand new module to handle geospatial information. 


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

Each spatial classes (Geometry Collection excluded) comes with a field coordinates that will be used to store the geometry structure.
The "coordinates" field of a geometry object is composed of one position ( Point), an array of positions (LineString or MultiPoint ), an array of arrays of positions (Polygons, MultiLineStrings), or a multidimensional array of positions (MultiPolygon).

### Geometry data Example 

Restaurants Domain

```SQL
create class Restaurant
create property Restaurant.name STRING
create property Restaurant.location EMBEDDED OPoint
```

To insert restaurants with location

From SQL
```SQL
insert into  Restaurant set name = 'Dar Poeta', location = {"@class": "OPoint","coordinates" : [12.4684635,41.8914114]}
```

or in alternative if you use [WKT](https://it.wikipedia.org/wiki/Well-Known_Text) format you can use the function
ST_GeomFromText to create the OrientDB geometry object.

```SQL
insert into  Restaurant set name = 'Dar Poeta', location = St_GeomFromText("POINT (12.4684635 41.8914114)")
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
select ST_AsText({"@class": "OPoint","coordinates" : [12.4684635,41.8914114]})

ST_AsText
----------
POINT (12.4684635 41.8914114)
```

### ST_GeomFromText

Syntax : ST_GeomFromText(text)

Example

```SQL
select ST_GeomFromText("POINT (12.4684635 41.8914114)")

ST_GeomFromText
----------------------------------------------------------------------------------
{"@type":"d","@version":0,"@class":"OPoint","coordinates":[12.4684635,41.8914114]}

```

### ST_Equals

Returns true if geom1 is spatially equal to geom2

Syntax : ST_Equals(geom1,geom2)

Example
```SQL

SELECT ST_Equals(ST_GeomFromText('LINESTRING(0 0, 10 10)'), ST_GeomFromText('LINESTRING(0 0, 5 5, 10 10)'))

ST_Equals
-----------
true
```
### ST_Within

Returns true if geom1 is inside geom2

Syntax : ST_Within(geom1,geom2)

This function will use an index if available.

Example
```SQL
select * from City where  ST_WITHIN(location,'POLYGON ((12.314015 41.8262816, 12.314015 41.963125, 12.6605063 41.963125, 12.6605063 41.8262816, 12.314015 41.8262816))')
```
### ST_Contains
TODO

### ST_Disjoint
TODO

### ST_Intersect
TODO

### ST_AsBinary
TODO

### ST_Envelope
Returns a geometry representing the bounding box of the supplied geometry

Syntax : ST_Envelope(geometry)

Example 

```SQL
SELECT ST_AsText(ST_Envelope(ST_GeomFromText('POINT(1 3)')));

ST_AsText
----------
POINT (1 3)
```

```SQL
SELECT ST_AsText(ST_Envelope(ST_GeomFromText('LINESTRING(0 0, 1 3)')))

ST_AsText
-----------------------------------
POLYGON ((0 0, 0 3, 1 3, 1 0, 0 0))
```
### ST_Buffer
TODO
## Operators

### A && B

Overlaps operator. Returns true if bounding box of A overlaps bounding box of B.
This operator will use an index if available.

Example

```SQL
create class TestLineString
create property TestLineString.location EMBEDDED OLineString
insert into TestLineSTring set name = 'Test1' , location = St_GeomFromText("LINESTRING(0 0, 3 3)")
insert into TestLineSTring set name = 'Test2' , location = St_GeomFromText("LINESTRING(0 1, 0 5)")
select from TestLineString where location && "LINESTRING(1 2, 4 6)"
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

* Take the latest OrientDB 2.2.0-Snapshot [here](https://oss.sonatype.org/content/repositories/snapshots/com/orientechnologies/orientdb-community/2.2.0-SNAPSHOT/)
* `git clone git@github.com:orientechnologies/orientdb-lucene.git`
* enter orientdb-lucene directory
* ` mvn assembly:assembly` add -DskipTests if you want to skip tests
* grab the jar orientdb-lucene-2.x.x-snaphost-dist.jar in target directory and copy it into plugins folder of OrientDB distribution


### 2.2 GA

This module is part of orientdb-lucene plugin and will be included in OrientDB 2.2 GA
