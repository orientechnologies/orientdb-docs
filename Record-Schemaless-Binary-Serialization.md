# Schemaless Serialization

The binary schemaless serialization is an attempt to define a serialization format that can serialize a document containing all the information about the structure and the data, with no need of a external schema definition and with support for partial serialization/deserialization.

The whole record is structured in three main segments


    +---------------+------------------+---------------+-------------+
    | version:byte  | className:string | header:byte[] | data:byte[] |
    +---------------+------------------+---------------+-------------+

## Version
1 byte that contain the version of the current record serialization, to allow progressive serialization upgrade
## Class Name
A String containing the name of the class of the record, if the record has no class will be just an empty string, the serialization of the string is the same of the String value

## Header
The header contains the list of fields names of the current record with the association to the data location


    +----------------------------+
    | fields:field_definition[]  |
    +----------------------------+

field definition

    +-----------------------------+-------------------+-------------------------------+----------------+
    | field_name_length|id:varint | field_name:byte[] | pointer_to_data_structure:int | data_type:byte |
    +-----------------------------+-------------------+-------------------------------+----------------+

**field_name_length** varint that describe the field, if positive is the size of the string that fallow next if negative is and id of current property referred in the schema, if is 0 mark the end of the header.      
**field_name** the field name present only with **field_name_length** > 0  
**pointer_to_data** a pointer to the data structure in the data segment that contains the field value or 0 if the field is null  
**data_type** the field type id, the supported types are defined here[ OType](https://github.com/orientechnologies/orientdb/wiki/Types) present only with **field_name_length** > 0   

###Property ID
The property Id will be stored in **field_name_length** as negative value, for decode it should translated to positive value and decrased by 1: (**field_name_length** * -1) -1 == propertyId.  

the relative property will be found in the schema, stored in the globalProperty list at the root of the document that rapresent the schema definition.

## Data
The data segment is where the data is stored is composed by an array of data structure

    +------------------------+
    | data:data_structure[]  |
    +------------------------+

each data structures content is depended to the field type, each type have it's own serialization structure

## field_data serialization by type

### SHORT,INTEGER,LONG
The Integer numbers will be serialized as variable size integer
it use the same format of protobuf specified [HERE](https://developers.google.com/protocol-buffers/docs/encoding?csw=1)  
-64 < value < 64 1 byte  
-8192 < value <  8192 2 byte  
-1048576 < value < 1048576 3 byte  
-134217728 < value < 134217728 4 byte  
-17179869184 < value < 17179869184 5 byte  

all the negative value are translated to positive using the ZigZag encoding

the algorithm can be also extended for longer values!

### BYTE

The byte is stored as byte

### BOOLEAN
The boolean is serialized as a byte:
0 = false
1 = true

### FLOAT
This is stored as flat byte array copying the memory from the float memory

    +---------------+
    | float:byte[4] |
    +---------------+
### DOUBLE
This is stored as flat byte array copying the memory from the double memory

    +---------------+
    | float:byte[8] |
    +---------------+


### DATETIME

The date is converted to millisecond unix epoch and stored as the type LONG

### DATE

The date is converted to second unix epoch,moved at midnight UTC+0, divided by 86400(seconds in a day) and stored as the type LONG

### STRING
The string are stored as binary structure with UTF-8 encoding

    +-------------+----------------+
    | size:varInt | string:byte[]  |
    +-------------+----------------+

**size** the number of the bytes in the string stored(not the length of the string) as variable size integer
**string** the bytes of the string in UTF-8 encodings

### BINARY
The BINARY store bytes in a row way on the storage

    +--------------+----------------+
    | size:varInt  | bytes:byte[]   |
    +--------------+----------------+

**size** the number of the bytes to store
**bytes** the row bytes

### EMBEDDED
The  embedded document is serialized calling the document serializer in recursive fashion, in the following structure

embedded document

    +-----------------------------+
    | serialized_document:bytes[] |
    +-----------------------------+

**serialized_document the bytes of the serialized document

### EMBEDDEDLIST, EMBEDDEDSET

The embedded collections is stored as an array of bytes that contain the serialized document in the embedded mode.

    +-------------+------------+-------------------+
    |size:varInt  | type:Otype | items:item_data[] |
    +-------------+------------+-------------------+

**size** the number of items in the list
**type** the type of the types in the list or ANY if the type is unknown
**items** an array of value serialized by type or if the type is ANY the item will have it's own structure.

the item_data structure is:
    +------------------+--------------+
    | data_type:OType  | data:byte[]  |
    +------------------+--------------+
**data_type** the type of the data stored in the item.
**data** the data stored with the format choose by the OType.

### EMBEDDEDMAP

The link map allow to have as key the types:
STRING,SHORT,INTEGER,LONG,BYTE,DATE,DECIMAL,DATETIME,DATA,FLOAT,DOUBLE
the serialization of the map is divided in a header and a values

    +---------------------------+-------------------------+
    | header:headerStructure    | values:valueStructure   |
    +---------------------------+-------------------------+

header structure

    +--------------+------------------+
    | keyType:byte | keyValue:byte[]  |
    +--------------+------------------+

**_Current implementation convert all the keys to string_**
**keyType** is the type of the key, can be only one of the listed type.
**keyValue** the value of the key serialized with the serializer of the type

value structure

    +---------------+---------------+
    |valueType:byte | value:byte[]  |
    +---------------+---------------+

**valueType** the OType of the stored value
**value** the value serialized with the serializer selected by OType

### LINK
The link is stored as two 64 bit integer

    +--------------+--------------+
    |cluster:64int | record:64Int |
    +--------------+--------------+

**cluster** orientdb cluster id
**record** orientdb record id

### LINKLIST, LINKSET

    +-------------+---------------------+
    | size:varint | collection:LINK[] |
    +-------------+---------------------+

**size** the number of links in the collection
**collection** an array of LINK each element is serialized as LINK type.

### LINKMAP
The link map allow to have as key the types:
STRING,SHORT,INTEGER,LONG,BYTE,DATE,DECIMAL,DATETIME,DATA,FLOAT,DOUBLE
the serialization of the linkmap is a list of entry

    +----------------------------+
    | values:link_map_entry[]    |
    +----------------------------+

link_map_entry structure

    +--------------+------------------+------------+
    | keyType:byte | keyValue:byte[]  | link:LINK  |
    +--------------+------------------+------------+

**keyType** is the type of the key, can be only one of the listed type.
**keyValue** the value of the key serialized with the serializer of the type
**link** the link value store with the formant of a LINK

### DECIMAL

The Decimal is converted to an integer and stored as scale and value (example "10234.546" is stored as scale "3" and value as:"10234546")

    +---------------+-------------------+--------------+
    | scale:byte[4] | valueSize:byte[4] | value:byte[] |
    +---------------+-------------------+--------------+

**scale** an 4 byte integer that represent the scale of the value
**valueSize** the length of the value bytes
**value** the bytes that represent the value of the decimal in big-endian order.

### LINKBAG
