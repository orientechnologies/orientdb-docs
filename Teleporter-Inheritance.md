# Inheritance
Teleporter allows you to take advantage of OrientDB's polymorphism. Infact you can enrich the import phase via an ORM file which describes the inheritance relationships being between different tables (or Entities) of your source DB. 

At the moment **Hibernate's syntax** is supported, and you can exploit this feature even if you don't use the Hibernate framework, which can automatically build the requested file for you. In fact the ORM file is simply interpreted as a "mapping file" between Relational and Object-Oriented models. Thus you can also write the file by yourself and give it as input to Teleporter, this is all you need.

## Inheritance Patterns in Relational Databases
Because relational databases have no concept of inheritance, there isn't a standard way of implementing inheritance in a database, so the hardest part of persisting inheritance is choosing how to represent the inheritance in the database. There are three main patterns commonly used:
- [**Single Table Inheritance**](Teleporter-Single-Table-Inheritance.md)
- [**Table Per Class Inheritance**](Teleporter-Table-Per-Class-Inheritance.md)
- [**Table Per Concrete Class Inheritance**](Teleporter-Table-Per-Concrete-Class-Inheritance.md)

Teleporter can faithfully reproduce all inheritance relationships present in your source DB using the argument **'-inheritance'** and the following the syntax:
```
./oteleporter.sh -jdriver <jdbc-driver> -jurl <jdbc-url> -juser <username> 
                -jpasswd <password> -ourl <orientdb-url> -s <strategy>
                -inheritance hibernate:<ORM-file-url>
```

Example:
```
./oteleporter.sh -jdriver <jdbc-driver> -jurl <jdbc-url> -juser <username> 
                -jpasswd <password> -ourl <orientdb-url> -s <strategy>
                -inheritance hibernate:/home/orientdb-user/mapping.xml
```

The resulting hierarchy in OrientDB is the same for each adopted pattern, as shown in the specific pattern descriptions.

## Hibernate Syntax

The mapping file is an XML document having \<hibernate-mapping\> as the root element which contains all the <class> elements.
Now we analyze some details about the Hibernate syntax used for the mapping file definition:

- The **\<class\>** elements are used to define the correspondence between Java classes and the database tables. The **name** attribute of the class element specifies the Java class name and the **table** attribute specifies the database table name.
- The **\<meta\>** element is an optional element which can contain a class description.
- The **\<id\>** element maps the unique ID attribute of the Java class to the primary key of the  correspondent database table. This element can have a **name** attribute and a **column** attribute  which manage the correspondence between the Object Model and the Relational Model as previously described: here the column attribute refers to the column in the table corresponding to that name. The **type** attribute holds the hibernate mapping type, this mapping types will convert from Java to SQL data type. If you write this file by yourself you should know that this element with its three attributes are superfluous for Teleporter.
- The **\<generator\>** element within the **id** element is used to automatically generate the primary key values. Also this element is superfluous for Teleport.
- The **\<property\>** element maps a Java class property to a column in the database table. The **name** attribute and the **column** have the same role in the Object and the Relational models mapping. The **type** attribute holds the hibernate mapping type.

There are other attributes and elements available among which:

- **\<subclass\>** element, used in the Single Table Inheritance pattern.
- **\<subclass\>** with a nested **\<join\>** element, used in the Table Per Class Inheritance pattern.
- **\<joined-subclass\>** element, used in the Table Per Class Inheritance pattern.
- **\<union-subclass\>** element, used in the Table Per Concrete Class Inheritance pattern.

Their usage will be explained specifically in the description of each individual pattern.
