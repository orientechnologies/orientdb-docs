# Console - CREATE PROPERTY

The **SQL CREATE PROPERTY** command creates a new property in the schema. You need to create the class before.

## Syntax

```
CREATE PROPERTY <class>.<property> <type>
```

Where:
- *class* is the class of the schema
- *property*, is the property created into the *class*
- *type*, the type of the property. It can be:
 - *boolean*
 - *integer*
 - *short*
 - *long*
 - *float*
 - *double*
 - *date*
 - *string*
 - *binary*
 - *embedded*
 - *embeddedlist*, this is a container and needs the parameter *linked-type* or *linked-class*
 - *embeddedset*, this is a container and needs the parameter *linked-type* or *linked-class*
 - *embeddedmap*, this is a container and needs the parameter *linked-type* or *linked-class*
 - *link*
 - *linklist*, this is a container and needs the parameter *linked-type* or *linked-class*
 - *linkset*, this is a container and needs the parameter *linked-type* or *linked-class*
 - *linkmap*, this is a container and needs the parameter *linked-type* or *linked-class*
 - *byte*
- *linked-type*, the contained type in containers (see above). It can be:
 - *boolean*
 - *integer*
 - *short*
 - *long*
 - *float*
 - *double*
 - *date*
 - *string*
 - *binary*
 - *embedded*
 - *link*
 - *byte*
- *linked-class*, the contained class in containers (see above).

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


To remove a property use the [DROP PROPERTY](SQL-Drop-Property.md) command.

To know more about other SQL commands look at [SQL commands](Commands.md).

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
