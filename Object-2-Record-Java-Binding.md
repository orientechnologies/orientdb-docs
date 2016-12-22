---
search:
   keywords: ['Object API', 'object binding']
---

# Object Binding

The ObjectDatabase implementation makes things easier for the Java developer since the binding between Objects to Records is transparent.

## How it works?

OrientDB uses Java reflection and [Javassist](http://www.javassist.org/) Proxy to bound POJOs to Records directly. Those proxied instances take care about the synchronization between the POJO and the underlying record. Every time you invoke a setter method against the POJO, the value is early bound into the record. Every time you call a getter method the value is retrieved from the record if the POJO's field value is null. Lazy loading works in this way too.

So the Object Database class works as wrapper of the underlying [Document-Database](Document-Database.md).

*NOTE: In case a non-proxied object is found it will be serialized, proxied and bounded to a corresponding Record.*

# Requirements

## Declare persistent classes

Before to use persistent POJOs OrientDB needs to know which classes are persistent (between thousands in your classpath) by registering the persistent packages and/or classes. Example:
```java
database.getEntityManager().registerEntityClasses("com.orientechnologies.orient.test.domain");
```
This must be done only right after the database is created or opened.

## Naming conventions

OrientDB follows some naming conventions to avoid writing tons of configuration files but just applying the rule "Convention over Configuration". Below those used:
1. Java classes will be bound to persistent classes defined in the OrientDB schema with the same name. In OrientDB class names are case insensitive. The Java class name is taken without the full package. For example registering the class <code>Account</code> in the package <code>com.orientechnologies.demo</code>, the expected persistent class will be "Account" and not the entire <code>com.orientechnologies.demo.Account</code>. This means that class names, in the database, are always unique and can't exist two class with the same name even if declared in different packages.
1. Java class's attributes will be bound to the fields with the same name in the persistent classes. Field names are case sensitive.

## Empty constructor

All the Java classes must have an empty constructor to let to OrientDB to create instances.

## Getters and Setters

All your classes must have [getters and setters](http://en.wikipedia.org/wiki/Mutator_method#Java_example) of every field that needs to be persistent in order to let to OrientDB to manage proxy operations.
[Getters and Setters](http://en.wikipedia.org/wiki/Mutator_method#Java_example) also need to be named same as the declaring field:
Example:
```java
public class Test {

  private String textField;
  private int intField;

  public String getTextField() {
    return textField;
  }

  public void setTextField( String iTextField ) {
    textField = iTextField;
  }

  // THIS DECLARATION WON'T WORK, ORIENTDB WON'T BE ABLE TO RECOGNIZE THE REAL FIELD NAME
  public int getInt(){
    return intField;
  }

  // THIS DECLARATION WON'T WORK, ORIENTDB WON'T BE ABLE TO RECOGNIZE THE REAL FIELD NAME
  public void setInt(int iInt){
    intField = iInt;
  }
}
```

## Collections and Maps

To avoid ClassCastExecption when the Java classes have Collections and Maps, the interface must be used rather than the Java implementation. The classic mistake is to define in a persistent class the types ArrayList, HashSet, HashMap instead of List, Set and Map.

Example:
```java
public class MyClass{
   // CORRECT
   protected List<MyElement> correctList;

   // WRONG: WILL THROW A ClassCastException
   protected ArrayList<MyElement> wrongList;

   // CORRECT
   protected Set<MyElement> correctSet;

   // WRONG: WILL THROW A ClassCastException
   protected TreeSet<MyElement> wrongSet;

   // CORRECT
   protected Map<String,MyElement> correctMap;

   // WRONG: WILL THROW A ClassCastException
   protected HashMap<String,MyElement> wrongMap;
}
```

# POJO binding

OrientDB manages all the POJO attributes in persistent way during read/write from/to the record, except for the fields those:
- have the *transient* modifier
- have the *static* modifier,
- haven't getters and setters
- are set with anonymous class types.

OrientDB uses the Java reflection to discovery the POJO classes. This is made only once during the registration of the domain classes.

## Default binding

This is the default. It tries to use the getter and setter methods for the field if they exist, otherwise goes in RAW mode (see below). The convention for the getter is the same as Java: <code>get&lt;field-name&gt;</code> where field-name is capitalized. The same is for setter but with 'set' as prefix instead of 'get': <code>set&lt;field-name&gt;</code>. If the getter or setter is missing, then the raw binding will be used.

Example:
Field '<code>String name</code>' -> <code>getName()</code> and <code>setName(String)</code>

## Custom binding

Since v1.2 Orient provides the possibility of custom binding extending the OObjectMethodFilter class and registering it to the wanted class.
- The custom implementation must provide the <code>public boolean isHandled(Method m)</code> to let Orient know what methods will be managed by the ProxyHandler and what methods won't.
- The custom implementation must provide the <code>public String getFieldName(Method m)</code> to let orient know how to parse a field name starting from the accessing method name.
In the case those two methods are not provided the [default binding](Object-2-Record-Java-Binding.md#default_binding) will be used

The custom MethodFilter can be registered by calling <code>OObjectEntityEnhancer.getInstance().registerClassMethodFilter(Class&lt;?&gt;, customMethodFilter);</code>

Domain class example:
```java
public class CustomMethodFilterTestClass {

  protected String standardField;

  protected String UPPERCASEFIELD;

  protected String transientNotDefinedField;

  // GETTERS AND SETTERS
  ...

}
```

Method filter example:
```java
 public class CustomMethodFilter extends OObjectMethodFilter {
    @Override
    public boolean isHandled(Method m) {
      if (m.getName().contains("UPPERCASE")) {
        return true;
      } else if (m.getName().contains("Transient")) {
        return false;
      }
      return super.isHandled(m);
    }

    @Override
    public String getFieldName(Method m) {
      if (m.getName().startsWith("get")) {
        if (m.getName().contains("UPPERCASE")) {
          return "UPPERCASEFIELD";
        }
        return getFieldName(m.getName(), "get");
      } else if (m.getName().startsWith("set")) {
        if (m.getName().contains("UPPERCASE")) {
          return "UPPERCASEFIELD";
        }
        return getFieldName(m.getName(), "set");
      } else
        return getFieldName(m.getName(), "is");
    }
  }
```

Method filter registration example:
```java
OObjectEntityEnhancer.getInstance().registerClassMethodFilter(CustomMethodFilterTestClass.class, new CustomMethodFilter());
```

# Read a POJO

You can read a POJO from the database in two ways:
- by calling the method <code>load(ORID)</code>
- by executing a query <code>query(q)</code>

When OrientDB loads the record, it creates a new POJO by calling the empty constructor and filling all the fields available in the source record. If a field is present only in the record and not in the POJO class, then it will be ignored. Even when the POJO is updated, any fields in the record that are not available in the POJO class will be untouched.

# Save a POJO

You can save a POJO to the database by calling the method <code>save(pojo)</code>. If the POJO is already a proxied instance, then the database will just save the record bounded to it. In case the object is not proxied the database will serialize it and save the corresponded record: **In this case the object MUST be reassinged with the one returned by the database**

# Fetching strategies

Starting from release 0.9.20, OrientDB supports [Fetching-Strategies](Fetching-Strategies.md) by using the **Fetch Plans**. Fetch Plans are used to customize how OrientDB must load linked records. The ODatabaseObjectTx uses the Fetch Plan also to determine how to bind the linked records to the POJO by building an object tree.

# Custom types

To let OrientDB use not supported types use the custom types. They MUST BE registered before domain classes registration, if not all custom type fields will be treated as domain classes.
In case of registering a custom type that is already register as a domain class said class will be removed.

**Important: java.lang classes cannot be managed this way**

Example to manage an enumeration as custom type:

**Enum declaration**
```java
public enum SecurityRole {
	ADMIN("administrador"), LOGIN("login");
	private String	id;

	private SecurityRole(String id) {
		this.id = id;
	}

	public String getId() {
		return id;
	}

	@Override
	public String toString() {
		return id;
	}

	public static SecurityRole getByName(String name) {
		if (ADMIN.name().equals(name)) {
			return ADMIN;
		} else if (LOGIN.name().equals(name)) {
			return LOGIN;
		}
		return null;
	}

	public static SecurityRole[] toArray() {
		return new SecurityRole[] { ADMIN, LOGIN };
	}
}
```
**Custom type management**
```java
  OObjectSerializerContext serializerContext = new OObjectSerializerContext();
  serializerContext.bind(new OObjectSerializer<SecurityRole, String>() {

    public Object serializeFieldValue(Class<?> type, SecurityRole role) {
      return role.name();
    }

    public Object unserializeFieldValue(Class<?> type, String str) {
      return SecurityRole.getByName(str);
    }
  });

  OObjectSerializerHelper.bindSerializerContext(null, serializerContext);

// NOW YOU CAN REGISTER YOUR DOMAIN CLASSES
database.getEntityManager().registerEntityClass(User.class);
```

OrientDB will use that custom serializer to marshall and unmarshall special types.

# ODatabaseObjectTx (old deprecated implementation)

*Available since v1.0rc9*

The ObjectDatabase implementation makes things easier for the Java developer since the binding between Objects to Records is transparent.

## How it works?

OrientDB uses Java reflection and doesn't require that the POJO is enhanced in order to use it according to the [JDO standard](http://java.sun.com/jdo) and doesn't use Proxies as do many [JPA](http://java.sun.com/developer/technicalArticles/J2EE/jpa) implementations such as [Hibernate](http://www.hibernate.org). So how can you work with plain POJOs?

OrientDB works in two ways:
- Connected mode
- Detached mode

### Connected mode

The ODatabaseObjectTx implementation is the gateway between the developer and OrientDB. ODatabaseObjectTx keeps track of the relationship between the POJO and the Record.

Each POJO that's read from the database is created and tracked by ODatabaseObjectTx.  If you change the POJO and call the <code>ODatabaseObjectTx.save(pojo)</code> method, OrientDB recognizes the POJO bound with the underlying record and, before saving it, will copy the POJO attributes to the loaded record.

This works with POJOs that belong to the same instance. For example:

```java
ODatabaseObjectTx db = new ODatabaseObjectTx("remote:localhost/demo");
db.open("admin", "admin");

try{
  List<Customer> result = db.query( new OSQLSynchQuery<Customer>(db, "select from customer") );
  for( Customer c : result ){
    c.setAge( 100 );
    db.save( c ); // <- AT THIS POINT THE POJO WILL BE RECOGNIZED AS KNOWN BECAUSE IS
                 // ALWAYS LOADED WITH THIS DB INSTANCE
  }

} finally {
  db.close;
}
```


When the <code>db.save( c )</code> is called, the ODatabaseObjectTx instance already knows obout it because has been retrieved by using a query through the same instance.

### Detached mode

In a typical Front-End application you need to load objects, display them to the user, capture the changes and save them back to the database. Usually this is implemented by using a database pool in order to avoid leaving a database instance open for the entire life cycle of the user session.

The database pool manages a configurable number of database instances. These instances are recycled for all database operations, so the list of connected POJOs is cleared at every release of the database pool instance. This is why the database instance doesn't know the POJO used by the application and in this mode if you save a previously loaded POJO it will appear as a NEW one and is therefore created as new instance in the database with a new [RecordID](Concepts.md#recordid).

This is why OrientDB needs to store the record information inside the POJO itself. This is retrieved when the POJO is saved so it is known if the POJO already has own identity (has been previously loaded) or not (it's new).

To save the [Record Identity](Concepts.md#recordid) you can use the [JPA](http://java.sun.com/developer/technicalArticles/J2EE/jpa) **[@Id](http://download.oracle.com/javaee/5/api/javax/persistence/Id.html)** annotation above the property interested. You can declare it as:
- **Object**, the suggested, in this case OrientDB will store the ORecordId instance
- **String**, in this case OrientDB will store the string representation of the ORecordId
- **Long**, in this case OrientDB will store the right part of the [RecordID](Concepts.md#recordid). This works only if you've a schema for the class. The left side will be rebuilt at save time by getting the class id.

Example:

```java
public class Customer{
  @Id
  private Object id; // DON'T CREATE GETTER/SETTER FOR IT TO PREVENT THE CHANGING BY THE USER APPLICATION,
                  // UNLESS IT'S NEEDED

  private String name;
  private String surname;

  public String getName(){
    return name;
  }
  public void setName(String name){
    this.name = name;
  }

  public String getSurname(){
    return name;
  }
  public void setSurname(String surname){
    this.surname = surname;
  }
}
```

OrientDB will save the [Record Identity](Concepts.md#recordid) in the **id** property even if getter/setter methods are not created.

If you work with transactions you also need to store the Record Version in the POJO to allow MVCC. Use the [JPA](http://java.sun.com/developer/technicalArticles/J2EE/jpa) **[@Version](http://download.oracle.com/javaee/5/api/javax/persistence/Version.html)** annotation above the property interested. You can declare it as:
- **java.lang.Object** (suggested) - a **com.orientechnologies.orient.core.version.OSimpleVersion** is used
- **java.lang.Long**
- **java.lang.String**

Example:

```java
public class Customer{
  @Id
  private Object id; // DON'T CREATE GETTER/SETTER FOR IT TO PREVENT THE CHANGING BY THE USER APPLICATION,
                  // UNLESS IT'S NEEDED

  @Version
  private Object version; // DON'T CREATE GETTER/SETTER FOR IT TO PREVENT THE CHANGING BY THE USER APPLICATION,
                       // UNLESS IT'S NEEDED

  private String name;
  private String surname;

  public String getName(){
    return name;
  }
  public void setName(String name){
    this.name = name;
  }

  public String getSurname(){
    return name;
  }
  public void setSurname(String surname){
    this.surname = surname;
  }
}
```

### Save Mode

Since OrientDB doesn't know what object is changed in a tree of connected objects, by default it saves all the objects. This could be very expensive for big trees. This is the reason why you can control manually what is changed or not via a setting in the ODatabaseObjectTx instance:

```java
db.setSaveOnlyDirty(true);
```

or by setting a global parameter (see [Parameters](Configuration.md)):
```java
OGlobalConfiguration.OBJECT_SAVE_ONLY_DIRTY.setValue(true);
```

To track what object is dirty use:
```java
db.setDirty(pojo);
```

To unset the dirty status of an object use:
```java
db.unsetDirty(pojo);
```

Dirty mode doesn't affect in memory state of POJOs, so if you change an object without marking it as dirty, OrientDB doesn't know that the object is changed. Furthermore if you load the same changed object using the same database instance, the modified object is returned.

## Requirements

## Declare persistent classes

In order to know which classes are persistent (between thousands in your classpath), you need to tell OrientDB. Using the Java API is:
```java
database.getEntityManager().registerEntityClasses("com.orientechnologies.orient.test.domain");
```

OrientDB saves only the final part of the class name without the package. For example if you're using the class <code>Account</code> in the package <code>com.orientechnologies.demo</code>, the persistent class will be only "Account" and not the entire <code>com.orientechnologies.demo.Account</code>. This means that class names, in the database, are always unique and can't exist two class with the same name even if declared in different packages.

### Empty constructor

All your classes must have an empty constructor to let to OrientDB to create instances.

## POJO binding

All the POJO attributes will be read/stored from/into the record except for fields with the *transient* modifier. OrientDB uses Java reflection but the discovery of POJO classes is made only the first time at startup. Java Reflection information is inspected only the first time to speed up the access to the fields/methods.

There are 2 kinds of binding:
- Default binding and
- Raw binding

### Default binding

This is the default. It tries to use the getter and setter methods for the field if they exist, otherwise goes in RAW mode (see below). The convention for the getter is the same as Java: <code>get&lt;field-name&gt;</code> where field-name is capitalized. The same is for setter but with 'set' as prefix instead of 'get': <code>set&lt;field-name&gt;</code>. If the getter or setter is missing, then the raw binding will be used.

Example:
Field '<code>String name</code>' -> <code>getName()</code> and <code>setName(String)</code>

## Raw binding

This mode acts at raw level by accessing the field directly. If the field signature is **private** or **protected**, then the accessibility will be forced. This works generally in all the scenarios except where a custom SecurityManager is defined that denies the change to the accessibility of the field.

To force this behaviour, use the [JPA 2](http://java.sun.com/developer/technicalArticles/J2EE/jpa) **[@AccessType](http://download.oracle.com/javaee/6/api/javax/persistence/AccessType.html)** annotation above the relevant property. For example:

```java
public class Customer{
  @AccessType(FIELD)
  private String name;

  private String surname;

  public String getSurname(){
    return name;
  }
  public void setSurname(String surname){
    this.surname = surname;
  }
}
```

## Read a POJO

You can read a POJO from the database in two ways:
- by calling the method <code>load(ORID)</code>
- by executing a query <code>query(q)</code>

When OrientDB loads the record, it creates a new POJO by calling the empty constructor and filling all the fields available in the source record. If a field is present only in the record and not in the POJO class, then it will be ignored. Even when the POJO is updated, any fields in the record that are not available in the POJO class will be untouched.

### Callbacks

You can define some methods in the POJO class that are called as callbacks before the record is read:
- [@OBeforeDeserialization](https://github.com/orientechnologies/orientdb/blob/2.2.x/core/src/main/java/com/orientechnologies/orient/core/annotation/OBeforeDeserialization.java) called just BEFORE unmarshalling the object from the source record
- [@OAfterDeserialization](https://github.com/orientechnologies/orientdb/blob/2.2.x/core/src/main/java/com/orientechnologies/orient/core/annotation/OAfterDeserialization.java) called just AFTER unmarshalling the object from the source record

Example:
```java
public class Account{
  private String name;
  transient private String status;

  @OAfterDeserialization
  public void init(){
    status = "Loaded";
  }
}
```

Callbacks are useful to initialize transient fields.

## Save a POJO

You can save a POJO to the database by calling the method <code>save(pojo)</code>. If the POJO is already known to the ODatabaseObjectTx instance, then it updates the underlying record by copying all the POJO attributes to the records (omitting those with *transient* modifier).

### Callbacks

You can define in the POJO class some methods called as callback before the record is written:
- [@OBeforeSerialization](https://github.com/orientechnologies/orientdb/blob/2.2.x/core/src/main/java/com/orientechnologies/orient/core/annotation/OBeforeSerialization.java) called just BEFORE marshalling the object to the record
- [@OAfterSerialization](https://github.com/orientechnologies/orientdb/blob/2.2.x/core/src/main/java/com/orientechnologies/orient/core/annotation/OAfterSerialization.java) called just AFTER marshalling the object to the record

Example:
```java
public class Account{
  private String name;
  transient private Socket s;

  @OAfterSerialization
  public void free(){
    s.close();
  }
}
```

Callbacks are useful to free transient resources.

== Fetching strategies =v

Starting from release 0.9.20, OrientDB supports [Fetching-Strategies](Fetching-Strategies.md) by using the **Fetch Plans**. Fetch Plans are used to customize how OrientDB must load linked records. The ODatabaseObjectTx uses the Fetch Plan also to determine how to bind the linked records to the POJO by building an object tree.

## Custom types

To let OrientDB use not supported types use the custom types. Register them before to register domain classes. Example to manage a BigInteger (that it's not natively supported):

```java
OObjectSerializerContext serializerContext = new OObjectSerializerContext();
serializerContext.bind(new OObjectSerializer<BigInteger, Integer>() {

  public Integer serializeFieldValue(Class<?> itype,  BigInteger iFieldValue) {
    return iFieldValue.intValue();
  }

  public  BigInteger unserializeFieldValue(Class<?> itype,  Integer iFieldValue) {
    return new  BigInteger(iFieldValue);
  }

});
OObjectSerializerHelper.bindSerializerContext(null, serializerContext);

// NOW YOU CAN REGISTER YOUR DOMAIN CLASSES
database.getEntityManager().registerEntityClass(Customer.class);
```

OrientDB will use that custom serializer to marshall and unmarshall special types.
