# Schemaless Serialization

The binary schemaless serialization is an attempt to define a serialization format that can serialize a document containing all the information about the structure and the data with support for partial serialization/deserialization.

The types described here are different from the types used in the binary protocol.

A serialized record has the following shape:

    (serialization-version:byte)(class-name:string)(header:byte[])(data:byte[])

## Version

1 byte that contains the version of the current serialization (in order to allow progressive serialization upgrades).

## Class Name

A string containing the name of the class of the record. If the record has no class, `class-name` will be just an empty string.

## Header

The header contains a list of fields of the serialized records, along with their position in the `data` field. The header has the following shape:

    (field:field-definition)+

Where `field-definition` has this shape:

    (field-type:varint)(field-contents:byte[])

The field contents depend on the value of the `field-type` varint. Once decoded to an integer, its value can be:

- `0` - signals the end of the header
- a positive number `i` - signals that what follows is a named field (and it's the length of the field name, see below)
- a negative number `i` - signals that what follows is a property (and it encodes the property id, see below)

#### Named fields

Named fields are encoded as:

    (field-name:string)(pointer-to-data-structure:int32)(data-type:byte)

- `field-name` - the name of the field. The `field-type` varint is included in `field-name` (as per the string encoding) as mentioned above.
- `pointer-to-data-structure` - a pointer to the data structure for the current field in the `data` segment. It's `0` if the field is null.
- `data-type` - the type id of the type of the value for the current field. The supported types (with their ids) are defined in [this section](Types.md).

#### Properties

Properties are encoded as:

    (property-id:varint)(pointer-to-data-structure:int32)

- `property-id` - is the `field-type` described above. It's a negative value that encodes a property id. Decoding of this value into the corresponding property id can be done using this formula: `(property-id * -1) - 1`. The property identified by this id will be found in the schema (with its name and its type), stored in the `globalProperties` field at the root of the document that represents the schema definition.
- `pointer-to-data-structure` - a pointer to the data structure for the current field in the `data` segment. It's `0` if the field is null.

## Data

The data segment is where the values of the fields are stored. It's an array of data structures (each with a type described by the corresponding field).

    (data:data-structure[])

Each type is serialized differently, as described below.

## Type serialization

### SHORT, INTEGER, LONG

Integers are encoded using the varint (with ZigZag) algorithm used by Google's ProtoBuf (and specified [here](https://developers.google.com/protocol-buffers/docs/encoding?csw=1)).

### BYTE

Bytes is stored raw, as single bytes.

### BOOLEAN

Booleans are serialized using a single byte, `0` meaning false and `1` meaning true.

### FLOAT

This is stored as flat byte array copying the memory from the float memory.

    (float:byte[4])

### DOUBLE

This is stored as flat byte array copying the memory from the double memory.

    (double:byte[8])

### DATETIME

The date is converted to milliseconds (from the Unix epoch) and stored as the type LONG.

### DATE

The date is converted to seconds (from the Unix epoch), moved to midnight UTC+0, divided by 86400 (the number of seconds in a day) and stored as the type LONG.

### STRING

Strings are stored as binary structures (encoded as UTF-8). Strings are preceded by their size (in bytes).

    (size:varint)(string:byte[])

- **size** - the number of the bytes in the string stored as a varint
- **string** - the bytes of the string encoded as UTF-8

### BINARY

Byte arrays are stored like STRINGs.

    (size:varint)(bytes:byte[])

- **size** - the number of the bytes to store
- **bytes** - the raw bytes

### EMBEDDED

Embedded documents are serialized using the protocol described in this document (recursively). The serialized document is just a byte array.

    (serialized-document:bytes[])

### EMBEDDEDLIST, EMBEDDEDSET

The embedded collections are stored as an array of bytes that contain the serialized document in the embedded mode.

    (size:varint)(collection-type:byte)(items:item[])

- **size** - the number of items in the list/set
- **collection-type** - the type of the elements in the list or ANY if the type is unknown.
- **items** an array of values serialized by type or if the type of the collection is ANY the item will have it's own structure.

The `item` data structure has the following shape:

    (data-type:byte)(data:byte)

- **data-type** - the type id of the data in the item
- **data** - the data in the item serialized according to the **data-type**

### EMBEDDEDMAP

Maps can have keys with the following types:

- STRING
- SHORT
- INTEGER
- LONG
- BYTE
- DATE
- DATETIME
- DECIMAL
- FLOAT
- DOUBLE

As of now though, **all keys are converted to STRINGs**.

An EMBEDDEDMAP is serialized as an header and a list of values.

    (size:varint)(header:header-structure)(values:byte[][])

- **size** - the number of key-value pairs in the map
- **header** - serialized as `(key-type:byte)(key-value:byte[])(pointer-to-data:int32)(value-type:byte)` (where `pointer-to-data` is the same as the one in the header, offsetting from the start of the top-level document).
- **values** - the values serialized according to their type.

### LINK

The link is stored as two 64 bit integers: the cluster id and the record's position in the cluster.

    (cluster-id:int64)(record-position:int64)

### LINKLIST, LINKSET

Link collections (lists and sets) are serialized as the size of the collection and then a list of LINKs.

    (size:varint)(links:LINK[])

### LINKMAP

Maps of links can have keys with the following types:

- STRING
- SHORT
- INTEGER
- LONG
- BYTE
- DATE
- DATETIME
- DECIMAL
- FLOAT
- DOUBLE

As of now though, **all keys are converted to STRINGs**.

A LINKMAP is serialized as the number of key-value pairs and then the list of key-value pairs.

    (size:varint)(key-value-pairs:key-value[])

A `key-value` pair is serialized as:

    (key-type:byte)(key-value:byte[])(link:LINK)

- **key-type** - the type id of the type of the key
- **key-value** - the value of the key, serialized according to **key-type**
- **link** - the link value

### DECIMAL

Decimals are converted to integers and stored as the scale and the value. For example, `10234.546` is storead as scale `3` and value `10234546`.

    (scale:int32)(value-size:int32)(value:byte[])

- **scale** - the scale of the decimal.
- **value-size** - the number of bytes that form the `value`.
- **value** - the bytes representing the value of the decimal (in big-endian order).

### LINKBAG

No documentation yet. :(
