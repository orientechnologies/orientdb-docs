## API Changes

 
**ODatabase hierarchy and factories**

TODO


**OProperty**

`OProperty.getFullName()` now returns ``` "`ClassName`.`propertyName`" ``` instead of ```"ClassName.propertyName"```


**OrientBaseGraph**

`setUseVertexFieldsForEdgeLabels(boolean)` is now deprecated and has no effect. All the edge labels are represented as edge classes.
