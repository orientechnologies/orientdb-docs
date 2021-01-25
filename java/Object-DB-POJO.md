# Working with POJO

With the Object API, Plain Old Java Objects, or POJO's, are automatically bound to the database as documents.  For information on the particulars of object-to-record bindings, see [POJO Bindings](Object-2-Record-Java-Binding.md).


>Bear in mind that the behavior of POJO operations can vary depending on whether you've begun a transaction.  For more information, see [Transactions](../internals/Transactions.md).


## Working with Records

The best practice in creating Java objects is to use the `newInstance()` method on the `ODatabaseObject` object.  For instance,

```java
public class Person {
   private String name;
   private String surname;

   public Person() {}

   public Person(String name){
      this.name = name;
   }

   public Person(String name, String surname){
      this.name = name;
      this.surname = surname;
   }

   //getters and settss
}
OrientDBObject orientDB = new OrientDBObject("remote:localhost",OrientDBConfig.defaultConfig());

ODatabaseObject db = orientDB.open("petshop","admin", "admin_passwd");

db.getEntityManager().registerEntityClass(Person.class);

// CREATES NEW PERSON FROM EMPTY CONSTRUCTOR
Person person = db.newInstance(Person.class);
person.setName("Antoni");
person.setSurname("Gaudi");
db.save(person);

// CREATES A NEW PERSON FROM A PARAMETERIZED CONSTRUCTOR
Person person = db.newInstance(Person.class, "Antoni");
person.setSurname("Gaudi");
db.save(person);

// OR
Person person = db.newInstance(Person.class, "Antoni", "Gaudi");
db.save(person);
```

Note that any Java object can be saved by calling the `db.save()` method.  If it doesn't exist in the database, OrientDB serializes and saves it.  In this case, the user must assign the results of the `db.save()` method in the argument in order to get the proxied instance.  Otherwise, the database always treats the object as a new one.  For instance,

```java
// REGISTER THE CLASS ONLY ONCE AFTER THE DB IS OPEN/CREATED
db.getENtityManager().registerEntityClass(Animal.class);

Animal animal = new Animal();
animal.setName("Gaudi");
animal.setLocation("Madrid");
animal = db.save(animal);
```


### Browsing and Counting Records

With the Object API, you can browse or count records in the database from your application, either all records in a cluster or in a particular class.  For instance,

- **Browsing Records by Class**:

  ```java
  for (Object o: database.browseClass(Animal.class)){
     System.out.println(animal.getName());
  }
  ```
- **Counting Records by Class**:

  ```java
  long cars = database.countClass("Car");
  ```

- **Browsing Records by Cluster**:

  ```java
  for (Object o: database.browseCluster("CityCars")){
     System.out.println(((Car) o).getModel());
  }
  ```

- **Counting Records by Cluster**:

  ```java
  long cityCars = database.countCluster("CityCar");
  ```

### Updating Objects

You can update any proxied object by using the Java language and then calling the `db.save()` method to synchronize the changes with OrientDB.  This behavior varies depending on the transaction, if any.  

**Syntax**

```java
animal.setLocation("Nairobi");
db.save(animal);
```

OrientDB only updates fields that have actually been changed.

**Example**

For example, in the pet shop application you might use something like this to raise the cost of animals by 5%:

```java
for (Animal animal: database.browseClass(Animal.class)) {
   animal.setPrice(animal.getPrice() * 105 / 100);
   database.save(animal);
}
```

When you call the `db.save()` method with non-proxied objects, the database creates a new document, even if said object were already saved.

### Deleting Objects

To delete an object, call the `db.delete()` method on a proxied object.  If you call it on a non-proxied object the database doesn't do anything.  

**Syntax**

```java
db.delete(animal);
```

**Example**

```java
for (Animal animal: database.browseClass(Animal.class)){
   database.delete(animal);
}
```

Here, the application loops through every instance of the class `Animal` and deletes the record.


#### Cascade Deletions

The Object API uses JPA annotations to manage cascade deletions.  It can be done explicitly, (that is, `orphanRemoval = true`), or with `CascadeType`.  The first mode works only with `@OneToOne` and `@OneToMany` annotations.  `CascadeType` works with `@ManyToManay` annotation.

For instance,

```java
public class JavaCascadeDeleteTestClass {
  ...

  @OneToOne(orphanRemoval = true)
  private JavaSimpleTestClass  simpleClass;

  @ManyToMany(cascade = { CascadeType.REMOVE })
  private Map<String, Child>   children    = new HashMap<String, Child>();

  @OneToMany(orphanRemoval = true)
  private List<Child>          list = new ArrayList<Child>();

  @OneToMany(orphanRemoval = true)
  private Set<Child> set = new HashSet<Child>();
  ...

  // GETTERS AND SETTERS
}
```

This means that you can make these deletions by calling,

- 
  ```java
  database.delete(testClass);
  ```

- 
  ```java
  for (JavaCascadeDeleteTestClass testClass: 
        database.browseClass(JavaCascadeDeleteTestClass.class)) {
  database.delete(testClass);
  }
  ```
Here, you also delete `JavaSimpleTextClass` instances contained in the `simpleClass` field and all other documents contained in `children`, `list`, and `test`.

## Executing Queries

While OrientDB is a NoSQL database, it also supports a subset of SQL with extensions, allowing it to work with objects and graphs.  For more information, see [SQL](../sql/README.md).  For instance,

```java
List<Animal> result = db.query(
   new OSQLSynchQuery<Animal>(
      "SELECT FROM Animal WHERE id = 10 AND name LIKE 'G%'"));
```

>OrientDB is a Graph database.  This means that it is very efficient at traversing records.  You can use this feature to optimize your queries.  A common technique for this is [Pivoting](../sql/Pivoting-With-Query.md).

To execute SQL commands, use the `command()` method with an `OCommandSQL` object.  For instance,

```java
int recordsUpdated = db.command(
   new OCommandSQL("UPDATE Animal SET sold = false"))
   .execute();
```

## Getting ODocument from a POJO

The `ODatabaseObject` implementation has APIs to get a document from its referencing object:

```java
ODocument doc = db.getRecordByUserObject( animal );
```

In case of non-proxied objects the document will be a new generated one with all object field serialized in it.

## Getting POJO from Records

The Object database can also create objects from records:

```java
Object pojo = db.getUserObjectsByRecord(record);
```
