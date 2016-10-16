# Attaching and Detaching

Beginning in version 1.1.0, Object API provides `attach()` and `detach()` methods to manually manage object-to-document data transfers.

## Attach

With the attach method all data contained in the object will be copied in the associated document, overwriting all existing informations.

```java
Animal animal = database.newInstance(Animal.class);
animal.name = "Gaudi" ;
animal.location = "Madrid";
database.attach(animal);
database.save(animal);
```

in this way all changes done within the object without using setters will be copied to the document.

There's also an `attachAndSave()` methods that after attaching data saves the object.

```java
Animal animal = database.newInstance(Animal.class);
animal.name = "Gaudi" ;
animal.location = "Madrid";
database.attachAndSave(animal);
```

This will do the same as the example before.

## Detach

With the detach method all data contained in the document will be copied in the associated object, overwriting all existing informations. The `detach()` method returns a proxied object, if there's a need to get a non proxied detached instance the `detach(Object,boolean)` can be used.

```java
Animal animal = database.load(rid);
database.detach(animal);
```

this will copy all the loaded document information in the object, without needing to call all getters. This methods returns a proxied instance

```java
Animal animal = database.load(rid);
animal = database.detach(animal,true);
```

this example does the same as before but in this case the detach will return a non proxied instance.

Since version 1.2 there's also the `detachAll(Object, boolean)` method that detaches recursively the entire object tree. This may throw a `StackOverflowError` with big trees. To avoid it increase the stack size with `-Xss` java option. The boolean parameter works the same as with the `detach()` method.

```java
Animal animal = database.load(rid);
animal = database.detachAll(animal,true);
```

### Lazy Detachment

When calling `detachAll(object, true)` on a large object tree, the call may become slow, especially when working with remote connections.  This occurs because it recurses through every link in the tree and loads all dependencies.

Beginning in version 2.2, you can set the Object API to only load parts of the object tree, by addinging `@OneToOne(fetch=FetchType.LAZY)` annotation.  For instance,

```java
public class LazyParent {

    @Id
    private String id;

    @OneToOne(fetch = FetchType.LAZY)
    private LazyChild child;
...
public class LazyChild {

    @Id
    private ORID id;

    private String name;

    public ORID getId() {
        return id;
    }

    public void setId(ORID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
```

In the above example, when calling `detachAll(lazyParent,true)`, the child variable (if a link is available) will contain a normal `LazyChild` object, but only with the `id` loaded. So the name property will be null, as will any other property that is added to the class. The `id` object can be used to load the `LazyChild` object in a later stage.


