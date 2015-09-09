# Spatial Module

(since 2.2) Replace for [Spatial-Index](Spatial-Index.md)


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
The "coordinates" field of a geometry object is composed of one position (in the case of a Point geometry), an array of positions (LineString or MultiPoint geometries), an array of arrays of positions (Polygons, MultiLineStrings), or a multidimensional array of positions (MultiPolygon).

### Geometry data Example 

Restaurants Domain

```
create class Restaurant extends V
create property Restaurant.name STRING
create property Restaurant.location EMBEDDED Point
```

To insert restaurants with location

```
create vertex Restar
```


OrientDB follows The Open Geospatial Consortium [OGC](http://www.opengeospatial.org/standards/sfs) for extending SQL to support spatial data.
OrientDB implements a subset of SQL-MM functions with ST prefix (Spatial Type)

## Functions

## Operators

### A && B
Overlaps operator. Returns true if bounding box of A overlaps bounding box of B.
This operator will use an index if available.



## Install 
