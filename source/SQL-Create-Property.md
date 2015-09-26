# SQL - CREATE PROPERTY

The **Create Property** command creates a new property in the schema. An existing class is required to perform this command.

## Syntax

```
CREATE PROPERTY <class>.<property> <type> [<linked-type>|<linked-class>] [UNSAFE]
```

Where:

- **class** is the class of the property
- **property**, is the property created in the **class**
- **type**, the data type of the property. See [Types](Types.md). Valid options are:
    - **boolean**
    - **integer**
    - **short**
    - **long**
    - **float**
    - **double**
    - **date**
    - **string**
    - **binary**
    - **embedded**
    - **embeddedlist**, an ordered collection of items that supports duplicates. Optionally accepts the parameter *linked-type* or *linked-class* to specify the collection's content
    - **embeddedset**, an unordered collection of items that does not support duplicates. Optionally accepts the parameter *linked-type* or *linked-class* to specify the collection's content
    - **embeddedmap**, a map of key/value entries. Optionally accepts the parameter *linked-type* or *linked-class* to specify the map's value content
    - **link**
    - **linklist**, an ordered collection of items that supports duplicates. Optionally accepts the parameter *linked-class* to specify the linked record's class
    - **linkset**, an unordered collection of items that does not support duplicates. Optionally accepts the parameter *linked-class* to specify the linked record's class
    - **linkmap**, this is a map of key/<record> entries. Optionally accepts the parameter *linked-class* to specify the map's value record class
    - **byte**
- **linked-type**, the contained type in EMBEDDEDSET, EMBEDDEDLIST and EMBEDDEDMAP types (see above). See also [Types](Types.md). Valid options are:
    - **boolean**
    - **integer**
    - **short**
    - **long**
    - **float**
    - **double**
    - **date**
    - **string**
    - **binary**
    - **embedded**
    - **link**
    - **byte**
- **linked-class**, the contained class in containers (see above).
- **UNSAFE**, optional, avoid check on existent records. With millions of records this operation could take time. If you are sure the property is new, you can skip the check by using **UNSAFE**. Since 2.0. 

## Existing Data Validation

On Property creation the data is checked for **property** and **type**, in case the persistent data has not compatible values for the specified **type** the property creation fail, no other constraint are applied on the persistent data.


## Examples

Create the property 'name' of type 'STRING' in class 'User':

```
CREATE PROPERTY user.name STRING
```

Create a list of Strings as property 'tags' of type 'EMBEDDEDLIST' in class 'Profile'. The linked type is 'STRING':

```
CREATE PROPERTY profile.tags EMBEDDEDLIST STRING
```

Create the property 'friends' of type 'EMBEDDEDMAP' in class 'Profile'. The linked class is profile itself (circular references):

```
CREATE PROPERTY profile.friends EMBEDDEDMAP Profile
```

To remove a property use the [SQL Drop Property](SQL-Drop-Property.md) command.

To learn more about other SQL commands look at [SQL commands](SQL.md).

This is a command of the Orient console. To learn all available commands go to [Console-Commands](Console-Commands.md).
