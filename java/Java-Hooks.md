---
search:
   keywords: ['inetrnals', 'hook', 'dynamic hook', 'Java']
---

# (Native) Java Hooks
Java Hooks are the fastest [hooks](../internals/Hook.md). Write a Java Hook if you need the best performance on execution. Look at [Hooks](../internals/Hook.md) for more information.

### The ORecordHook interface

A hook is an implementation of the interface [ORecordHook]({{ book.source_repository }}core/src/main/java/com/orientechnologies/orient/core/hook/ORecordHook.java):

```java
public interface ORecordHook {
  public enum TYPE {
    ANY,
    BEFORE_CREATE, BEFORE_READ, BEFORE_UPDATE, BEFORE_DELETE,
    AFTER_CREATE, AFTER_READ, AFTER_UPDATE, AFTER_DELETE
  };

  public void onTrigger(TYPE iType, ORecord<?> iRecord);
}
```

### The ORecordHookAbstract abstract class

OrientDB comes with an abstract implementation of the [ORecordHook]({{ book.source_repository }}core/src/main/java/com/orientechnologies/orient/core/hook/ORecordHook.java) interface called [ORecordHookAbstract.java]({{ book.source_repository }}core/src/main/java/com/orientechnologies/orient/core/hook/ORecordHookAbstract.java). It switches the callback event, calling separate methods for each one:

```java
public abstract class ORecordHookAbstract implements ORecordHook {
  public void onRecordBeforeCreate(ORecord<?> iRecord){}
  public void onRecordAfterCreate(ORecord<?> iRecord){}
  public void onRecordBeforeRead(ORecord<?> iRecord){}
  public void onRecordAfterRead(ORecord<?> iRecord){}
  public void onRecordBeforeUpdate(ORecord<?> iRecord){}
  public void onRecordAfterUpdate(ORecord<?> iRecord){}
  public void onRecordBeforeDelete(ORecord<?> iRecord){}
  public void onRecordAfterDelete(ORecord<?> iRecord){}
  ...
}
```

### The ODocumentHookAbstract abstract class
When you want to catch an event from a Document only, the best way to create a hook is to extend the `ODocumentHookAbstract` abstract class. You can specify what classes you're interested in. In this way the callbacks will be called only on documents of the specified classes. Classes are polymorphic so filtering works against specified classes and all sub-classes.

You can specify only the class you're interested or the classes you want to exclude. Example to include only the `Client` and `Provider` classes:

```java
public class MyHook extends ODocumentHookAbstract {
  public MyHook() {
    setIncludeClasses("Client", "Provider");
  }
}
```

Example to get called for all the changes on documents of any class but `Log`:

```java
public class MyHook extends ODocumentHookAbstract {
  public MyHook() {
    setExcludeClasses("Log");
  }
}
```

### Access to the modified fields
In Hook methods you can access dirty fields and the original values. Example:

```java
for( String field : document.getDirtyFields() ) {
  Object originalValue = document.getOriginalValue( field );
  ...
}
```


### Self registration

Hooks can be installed on certain database instances, but in most cases you'll need to register it for each instance. To do this programmatically you can intercept the `onOpen()` and `onCreate()` callbacks from OrientDB to install hooks. All you need is to implement the `ODatabaseLifecycleListener` interface. Example:

```java
public class MyHook extends ODocumentHookAbstract implements ODatabaseLifecycleListener {
  public MyHook() {
    // REGISTER MYSELF AS LISTENER TO THE DATABASE LIFECYCLE
    Orient.instance().addDbLifecycleListener(this);
  }
  ...
  @Override
  public void onOpen(final ODatabase iDatabase) {
    // REGISTER THE HOOK
    ((ODatabaseComplex<?>)iDatabase).registerHook(this);
  }

  @Override
  public void onCreate(final ODatabase iDatabase) {
    // REGISTER THE HOOK
    ((ODatabaseComplex<?>)iDatabase).registerHook(this);
  }

  @Override
  public void onClose(final ODatabase iDatabase) {
    // REGISTER THE HOOK
    ((ODatabaseComplex<?>)iDatabase).unregisterHook(this);
  }
  ...
  public RESULT onRecordBeforeCreate(final ODocument iDocument) {
    // DO SOMETHING BEFORE THE DOCUMENT IS CREATED
    ...
  }
  ...
}
```

### Hook example

In this example the events `before-create` and `after-delete` are called during the `save()` of the `Profile` object where:
- `before-create` is used to check custom validation rules
- `after-delete` is used to maintain the references valid

```java
public class HookTest extends ORecordHookAbstract {

  /**
   * Custom validation rules
   */
  @Override
  public void onRecordBeforeCreate(ORecord<?> iRecord){
    if( iRecord instanceof ODocument ){
      ODocument doc = (ODocument) iRecord;
      Integer age = doc .field( "age" );
      if( age != null && age > 130 )
        throw new OValidationException("Invalid age");
    }
  }

  /**
   * On deletion removes the reference back.
   */
  @Override
  public void onRecordAfterDelete(ORecord<?> iRecord){
    if( iRecord instanceof ODocument ){
      ODocument doc = (ODocument) iRecord;

      Set<OIdentifiable> friends = doc.field( "friends" );
      if( friends != null ){
        for( OIdentifiable friend : friends ){
          Set<OIdentifiable> otherFriends = ((ODocument)friend.getRecord()).field("friends");
          if( friends != null )
            friends.remove( iRecord );
        }
      }
    }
  }
}
```


For more information take a look to the [HookTest.java]({{ book.source_repository }}tests/src/test/java/com/orientechnologies/orient/test/database/auto/HookTest.java) source code.

### Install server-side hooks

To let a hook be executed in the Server space you have to register it in the server `orientdb-server-config.xml` configuration file.

#### Write your hook

Example of a hook to execute custom validation rules:
```java
public class CustomValidationRules implements ORecordHook{
  /**
   * Apply custom validation rules
   */
  public boolean onTrigger(final TYPE iType, final ORecord<?> iRecord) {
    if( iRecord instanceof ODocument ){
      ODocument doc = (ODocument) iRecord;

      switch( iType ){
        case BEFORE_CREATE:
        case BEFORE_UPDATE: {
          if( doc.getClassName().equals("Customer") ){
            Integer age = doc .field( "age" );
            if( age != null && age > 130 )
              throw new OValidationException("Invalid age");
          }
          break;
        }

        case BEFORE_DELETE: {
          if( doc.getClassName().equals("Customer") ){
            final ODatabaseRecord db = ODatabaseRecordThreadLocal.INSTANCE.get();
            if( !db.getUser().getName().equals( "admin" ) )
              throw new OSecurityException("Only admin can delete customers");
          }
          break;
        }
    }
  }
}
```

#### Deploy the hook

Once implemented create a `.jar` file containing your class and put it under the `$ORIENTDB_HOME/lib` directory.

#### Register it in the server configuration

Change the `orientdb-server-config.xml` file adding your hook inside the `<hooks>` tag. The position can be one of following values `FIRST`, `EARLY`, `REGULAR`, `LATE`, `LAST`:
```xml
<orient-server>
   
  <hooks>
    <hook class="org.orientdb.test.MyHook" position="REGULAR"/>
  <hooks>
```

#### Configurable hooks

If your hook must be configurable with external parameters write the parameters in the `orientdb-server-config.xml` file:
```xml
<hook class="org.orientdb.test.MyHook" position="REGULAR">
    <parameters>
        <parameter name="userCanDelete" value="admin" />
    </parameters>
</hook>
```

And in your Java class implement the config() method to read the parameter:
```java
private String userCanDelete;
...
public void config(OServer oServer, OServerParameterConfiguration[] iParams) {
  for (OServerParameterConfiguration param : iParams) {
    if (param.name.equalsIgnoreCase("userCanDelete")) {
      userCanDelete = param.value;
    }
  }
}
...
```
