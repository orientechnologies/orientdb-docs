# Spatial Module

(since 2.2)


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
The module creates abstract classes that represent each Geometry object, and those classes
can be used as embedded document in user defined classes to provide geospatial information.
