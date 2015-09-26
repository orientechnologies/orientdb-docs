# Export format

This page contains the format used by [EXPORT DATABASE](Console-Command-Export.md) and [IMPORT DATABASE](Console-Command-Import.md) tools. The file is a zipped JSON.

_NOTE: Even if the file is 100% JSON, there are some constraints in the JSON format, where the field order must be kept. If you prettify the file, the import couldn't work anymore._

## See also
- [EXPORT DATABASE](Console-Command-Export.md)
- [IMPORT DATABASE](Console-Command-Import.md)

## Sections

### Info Section

First section resuming the database information and all the version used to check compatibility on import.
```json
{
  "info":{
  "name": <database-name>,
  "default-cluster-id": <default-cluster-id>,
  "exporter-version": <exporter-format>,
  "engine-version": <engine-version>,
  "storage-config-version": <storage-version>,
  "schema-version": <schema-version>,
  "mvrbtree-version": <mvrbtree-version>
}
```

|Parameter|Description|JSON Type|
|---------|-----------|---------|
|database-name|Name of database|String|
|default-cluster-id|Cluster Id used by default. Range: 0-32,767|Integer|
|exporter-format|Version of Database exporter|Integer|
|engine-version|Version of OrientDB|String|
|storage-version|Version of Storage layer|Integer|
|schema-version|Version of the schema exporter|Integer|
|mvrbtree-version|Version of the MVRB-Tree|Integer|


#### Example


```json
{
  "info":{
  "name": "demo",
  "default-cluster-id": 2,
  "exporter-version": 2,
  "engine-version": "1.7-SNAPSHOT",
  "storage-config-version": 2,
  "schema-version": 4,
  "mvrbtree-version": 0
}
```

### Clusters Section

Contains the database structure in clusters.

```json
"clusters": [
  {"name": <cluster-name>, "id": <cluster-id>, "type": <cluster-type>}
]
```

|Parameter|Description|JSON Type|
|---------|-----------|---------|
|cluster-name|Name of cluster|String|
|cluster-id|Cluster id. Range: 0-32,767|Integer|
|cluster-type|Cluster type between "PHYSICAL", "LOGICAL" and "MEMORY"|String|




#### Example


```json
"clusters": [
  {"name": "internal", "id": 0, "type": "PHYSICAL"},
  {"name": "index", "id": 1, "type": "PHYSICAL"},
  {"name": "default", "id": 2, "type": "PHYSICAL"}
]
```


### Schema Section

Contains the schema as classes and properties.


```json
"schema":{
  "version": <schema-version>,
  "classes": [
    { "name": <class-name>,
      "default-cluster-id": <default-cluster-id>,
      "cluster-ids": [<cluster-ids>],
      "properties": [
        { "name": <property-name>,
          "type": <property-type>,
          "mandatory": <property-is-mandatory>,
          "not-null": <property-not-null> }
      ]
    }
  ]
}
```


|Parameter|Description|JSON Type|
|---------|-----------|---------|
|schema-version|Version of the record where the schema is stored. Range: 0-2,147,483,647|Integer|
|class-name|Class name|String|
|default-cluster-id|Default cluster id for the class. Represents the cluster where records will be stored|Integer|
|cluster-ids|Array of cluster ids where the class records can be stored. The first is always the <code>&lt;default-cluster-id&gt;</code>|Array of Integer|
|property-name|Name of the property|String|
|property-type|Property type between the [supported ones](Types.md)|String|
|property-is-mandatory|Is this property mandatory? true or false|Boolean|
|property-not-null|The property can't accept null? true or false|Boolean|



#### Example


```json
"schema":{
  "version": 210,
  "classes": [
    {"name": "Account", "default-cluster-id": 9, "cluster-ids": [9],
      "properties": [
        {"name": "binary", "type": "BINARY", "mandatory": false, "not-null": false},
        {"name": "birthDate", "type": "DATE", "mandatory": false, "not-null": false},
        {"name": "id", "type": "INTEGER", "mandatory": false, "not-null": false}
      ]
    }
  ]
}
```


### Records Section

Contains the exported records with metadata (prefixed by @) and fields.
```json
"records": [
  {
    "@type": <record-type>,
    "@rid": <record-id>,
    "@version": 0,
    "@class": <record-class>,

    <field-name>: <field-value>,

    ["@fieldTypes": "<field-name>=<field-type>"]
  }
]
```


|Parameter|Description|JSON Type|
|---------|-----------|---------|
|record-type|Record type: d = document, b = binary|String|
|record-id|[RecordID](Concepts.md#recordid) in the format <code>#&lt;cluster-id&gt;:&lt;cluster-position&gt;</code>|String|
|record-version|Record version from 0 to 2,147,483,647|Integer|
|record-class|Record class name|String|
|field-name|Field name|String|
|field-value|Field value|Any|
|field-type|Optional, it's the field type: 'l'=Long, 'f'=Float, 'd'=Double, 's'=Short, 't'=Datetime, 'd'=Date, 'c'=Decimal, 'b'=Byte|Any|


#### Example


```json
"records": [
  {
    "@type": "d", "@rid": "#12:476", "@version": 0, "@class": "Whiz",
    "id": 476,
    "date": "2011-12-09 00:00:00:000",
    "text": "Los a went chip, of was returning cover, In the",
    "@fieldTypes": "date=t"
  },{
    "@type": "d", "@rid": "#12:477", "@version": 0, "@class": "Whiz",
    "id": 477,
    "date": "2011-12-09 00:00:00:000",
    "text": "He in office return He inside electronics for $500,000 Jay",
    "@fieldTypes": "date=t"
  }
]
```

## Full Example

```json
{
  "info":{
    "name": "demo",
    "default-cluster-id": 2,
    "exporter-version": 2,
    "engine-version": "1.0rc8-SNAPSHOT",
    "storage-config-version": 2,
    "schema-version": 4,
    "mvrbtree-version": 0
  },
  "clusters": [
    {"name": "internal", "id": 0, "type": "PHYSICAL"},
    {"name": "index", "id": 1, "type": "PHYSICAL"},
    {"name": "default", "id": 2, "type": "PHYSICAL"},
    {"name": "orole", "id": 3, "type": "PHYSICAL"},
    {"name": "ouser", "id": 4, "type": "PHYSICAL"},
    {"name": "orids", "id": 5, "type": "PHYSICAL"},
    {"name": "csv", "id": 6, "type": "PHYSICAL"},
    {"name": "binary", "id": 8, "type": "PHYSICAL"},
    {"name": "account", "id": 9, "type": "PHYSICAL"},
    {"name": "company", "id": 10, "type": "PHYSICAL"},
    {"name": "profile", "id": 11, "type": "PHYSICAL"},
    {"name": "whiz", "id": 12, "type": "PHYSICAL"},
    {"name": "address", "id": 13, "type": "PHYSICAL"},
    {"name": "city", "id": 14, "type": "PHYSICAL"},
    {"name": "country", "id": 15, "type": "PHYSICAL"},
    {"name": "dummy", "id": 16, "type": "PHYSICAL"},
    {"name": "ographvertex", "id": 26, "type": "PHYSICAL"},
    {"name": "ographedge", "id": 27, "type": "PHYSICAL"},
    {"name": "graphvehicle", "id": 28, "type": "PHYSICAL"},
    {"name": "graphcar", "id": 29, "type": "PHYSICAL"},
    {"name": "graphmotocycle", "id": 30, "type": "PHYSICAL"},
    {"name": "newv", "id": 31, "type": "PHYSICAL"},
    {"name": "mappoint", "id": 33, "type": "PHYSICAL"},
    {"name": "person", "id": 35, "type": "PHYSICAL"},
    {"name": "order", "id": 36, "type": "PHYSICAL"},
    {"name": "post", "id": 37, "type": "PHYSICAL"},
    {"name": "comment", "id": 38, "type": "PHYSICAL"}
  ],
  "schema":{
    "version": 210,
    "classes": [
      {"name": "Account", "default-cluster-id": 9, "cluster-ids": [9],
        "properties": [
          {"name": "binary", "type": "BINARY", "mandatory": false, "not-null": false},
          {"name": "birthDate", "type": "DATE", "mandatory": false, "not-null": false},
          {"name": "id", "type": "INTEGER", "mandatory": false, "not-null": false}
        ]
      },
      {"name": "Address", "default-cluster-id": 13, "cluster-ids": [13]
      },
      {"name": "Animal", "default-cluster-id": 17, "cluster-ids": [17]
      },
      {"name": "AnimalRace", "default-cluster-id": 18, "cluster-ids": [18]
      },
      {"name": "COMMENT", "default-cluster-id": 38, "cluster-ids": [38]
      },
      {"name": "City", "default-cluster-id": 14, "cluster-ids": [14]
      },
      {"name": "Company", "default-cluster-id": 10, "cluster-ids": [10], "super-class": "Account",
        "properties": [
        ]
      },
      {"name": "Country", "default-cluster-id": 15, "cluster-ids": [15]
      },
      {"name": "Dummy", "default-cluster-id": 16, "cluster-ids": [16]
      },
      {"name": "GraphCar", "default-cluster-id": 29, "cluster-ids": [29], "super-class": "GraphVehicle",
        "properties": [
        ]
      },
      {"name": "GraphMotocycle", "default-cluster-id": 30, "cluster-ids": [30], "super-class": "GraphVehicle",
        "properties": [
        ]
      },
      {"name": "GraphVehicle", "default-cluster-id": 28, "cluster-ids": [28], "super-class": "OGraphVertex",
        "properties": [
        ]
      },
      {"name": "MapPoint", "default-cluster-id": 33, "cluster-ids": [33],
        "properties": [
          {"name": "x", "type": "DOUBLE", "mandatory": false, "not-null": false},
          {"name": "y", "type": "DOUBLE", "mandatory": false, "not-null": false}
        ]
      },
      {"name": "OGraphEdge", "default-cluster-id": 27, "cluster-ids": [27], "short-name": "E",
        "properties": [
          {"name": "in", "type": "LINK", "mandatory": false, "not-null": false, "linked-class": "OGraphVertex"},
          {"name": "out", "type": "LINK", "mandatory": false, "not-null": false, "linked-class": "OGraphVertex"}
        ]
      },
      {"name": "OGraphVertex", "default-cluster-id": 26, "cluster-ids": [26], "short-name": "V",
        "properties": [
          {"name": "in", "type": "LINKSET", "mandatory": false, "not-null": false, "linked-class": "OGraphEdge"},
          {"name": "out", "type": "LINKSET", "mandatory": false, "not-null": false, "linked-class": "OGraphEdge"}
        ]
      },
      {"name": "ORIDs", "default-cluster-id": 5, "cluster-ids": [5]
      },
      {"name": "ORole", "default-cluster-id": 3, "cluster-ids": [3],
        "properties": [
          {"name": "mode", "type": "BYTE", "mandatory": false, "not-null": false},
          {"name": "name", "type": "STRING", "mandatory": true, "not-null": true},
          {"name": "rules", "type": "EMBEDDEDMAP", "mandatory": false, "not-null": false, "linked-type": "BYTE"}
        ]
      },
      {"name": "OUser", "default-cluster-id": 4, "cluster-ids": [4],
        "properties": [
          {"name": "name", "type": "STRING", "mandatory": true, "not-null": true},
          {"name": "password", "type": "STRING", "mandatory": true, "not-null": true},
          {"name": "roles", "type": "LINKSET", "mandatory": false, "not-null": false, "linked-class": "ORole"}
        ]
      },
      {"name": "Order", "default-cluster-id": 36, "cluster-ids": [36]
      },
      {"name": "POST", "default-cluster-id": 37, "cluster-ids": [37],
        "properties": [
          {"name": "comments", "type": "LINKSET", "mandatory": false, "not-null": false, "linked-class": "COMMENT"}
        ]
      },
      {"name": "Person", "default-cluster-id": 35, "cluster-ids": [35]
      },
      {"name": "Person2", "default-cluster-id": 22, "cluster-ids": [22],
        "properties": [
          {"name": "age", "type": "INTEGER", "mandatory": false, "not-null": false},
          {"name": "firstName", "type": "STRING", "mandatory": false, "not-null": false},
          {"name": "lastName", "type": "STRING", "mandatory": false, "not-null": false}
        ]
      },
      {"name": "Profile", "default-cluster-id": 11, "cluster-ids": [11],
        "properties": [
          {"name": "hash", "type": "LONG", "mandatory": false, "not-null": false},
          {"name": "lastAccessOn", "type": "DATETIME", "mandatory": false, "not-null": false, "min": "2010-01-01 00:00:00"},
          {"name": "name", "type": "STRING", "mandatory": false, "not-null": false, "min": "3", "max": "30"},
          {"name": "nick", "type": "STRING", "mandatory": false, "not-null": false, "min": "3", "max": "30"},
          {"name": "photo", "type": "TRANSIENT", "mandatory": false, "not-null": false},
          {"name": "registeredOn", "type": "DATETIME", "mandatory": false, "not-null": false, "min": "2010-01-01 00:00:00"},
          {"name": "surname", "type": "STRING", "mandatory": false, "not-null": false, "min": "3", "max": "30"}
        ]
      },
      {"name": "PropertyIndexTestClass", "default-cluster-id": 21, "cluster-ids": [21],
        "properties": [
          {"name": "prop1", "type": "STRING", "mandatory": false, "not-null": false},
          {"name": "prop2", "type": "INTEGER", "mandatory": false, "not-null": false},
          {"name": "prop3", "type": "BOOLEAN", "mandatory": false, "not-null": false},
          {"name": "prop4", "type": "INTEGER", "mandatory": false, "not-null": false},
          {"name": "prop5", "type": "STRING", "mandatory": false, "not-null": false}
        ]
      },
      {"name": "SQLDropIndexTestClass", "default-cluster-id": 23, "cluster-ids": [23],
        "properties": [
          {"name": "prop1", "type": "DOUBLE", "mandatory": false, "not-null": false},
          {"name": "prop2", "type": "INTEGER", "mandatory": false, "not-null": false}
        ]
      },
      {"name": "SQLSelectCompositeIndexDirectSearchTestClass", "default-cluster-id": 24, "cluster-ids": [24],
        "properties": [
          {"name": "prop1", "type": "INTEGER", "mandatory": false, "not-null": false},
          {"name": "prop2", "type": "INTEGER", "mandatory": false, "not-null": false}
        ]
      },
      {"name": "TestClass", "default-cluster-id": 19, "cluster-ids": [19],
        "properties": [
          {"name": "name", "type": "STRING", "mandatory": false, "not-null": false},
          {"name": "testLink", "type": "LINK", "mandatory": false, "not-null": false, "linked-class": "TestLinkClass"}
        ]
      },
      {"name": "TestLinkClass", "default-cluster-id": 20, "cluster-ids": [20],
        "properties": [
          {"name": "testBoolean", "type": "BOOLEAN", "mandatory": false, "not-null": false},
          {"name": "testString", "type": "STRING", "mandatory": false, "not-null": false}
        ]
      },
      {"name": "Whiz", "default-cluster-id": 12, "cluster-ids": [12],
        "properties": [
          {"name": "account", "type": "LINK", "mandatory": false, "not-null": false, "linked-class": "Account"},
          {"name": "date", "type": "DATE", "mandatory": false, "not-null": false, "min": "2010-01-01"},
          {"name": "id", "type": "INTEGER", "mandatory": false, "not-null": false},
          {"name": "replyTo", "type": "LINK", "mandatory": false, "not-null": false, "linked-class": "Account"},
          {"name": "text", "type": "STRING", "mandatory": true, "not-null": false, "min": "1", "max": "140"}
        ]
      },
      {"name": "classclassIndexManagerTestClassTwo", "default-cluster-id": 25, "cluster-ids": [25]
      },
      {"name": "newV", "default-cluster-id": 31, "cluster-ids": [31], "super-class": "OGraphVertex",
        "properties": [
          {"name": "f_int", "type": "INTEGER", "mandatory": false, "not-null": false}
        ]
      },
      {"name": "vertexA", "default-cluster-id": 32, "cluster-ids": [32], "super-class": "OGraphVertex",
        "properties": [
          {"name": "name", "type": "STRING", "mandatory": false, "not-null": false}
        ]
      },
      {"name": "vertexB", "default-cluster-id": 34, "cluster-ids": [34], "super-class": "OGraphVertex",
        "properties": [
          {"name": "map", "type": "EMBEDDEDMAP", "mandatory": false, "not-null": false},
          {"name": "name", "type": "STRING", "mandatory": false, "not-null": false}
        ]
      }
    ]
  },
  "records": [{
          "@type": "d", "@rid": "#12:476", "@version": 0, "@class": "Whiz",
          "id": 476,
          "date": "2011-12-09 00:00:00:000",
          "text": "Los a went chip, of was returning cover, In the",
          "@fieldTypes": "date=t"
        },{
          "@type": "d", "@rid": "#12:477", "@version": 0, "@class": "Whiz",
          "id": 477,
          "date": "2011-12-09 00:00:00:000",
          "text": "He in office return He inside electronics for $500,000 Jay",
          "@fieldTypes": "date=t"
        }
  ]
}
```
