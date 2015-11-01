# Dynamic Hooks
Dynamic [Hooks](Hook.md) are more flexible than [Java Hooks](Java-Hooks.md), because they can be changed at run-time and can run per document if needed, but are slower than [Java Hooks](Java-Hooks.md). Look at [Hooks](Hook.md) for more information.

To execute hooks against your documents, let your classes to extend `OTriggered` base class. Then define a custom property for the event you're interested on. The available events are:

- `onBeforeCreate`, called **before** creating a new document
- `onAfterCreate`, called **after** creating a new document
- `onBeforeRead`, called **before** reading a document
- `onAfterRead`, called **after** reading a document
- `onBeforeUpdate`, called **before** updating a document
- `onAfterUpdate`, called **after** updating a document
- `onBeforeDelete`, called **before** deleting a document
- `onAfterDelete`, called **after** deleting a document

Dynamic Hooks can call:

- [Functions](Functions.md), written in SQL, Javascript or any language supported by OrientDB and JVM
- Java static methods


## Class level hooks
Class level hooks are defined for all the documents that relate to a class. Below is an example to setup a hook that acts at class level against Invoice documents.

```sql
CREATE CLASS Invoice EXTENDS OTriggered
ALTER CLASS Invoice CUSTOM onAfterCreate=invoiceCreated
```

Now let's create the function `invoiceCreated` in Javascript that prints in the server console the invoice number created.

```sql
CREATE FUNCTION invoiceCreated "print('\\nInvoice created: ' + doc.field('number'));" LANGUAGE Javascript
```

Now try the hook by creating a new `Invoice` document.

```sql
INSERT INTO Invoice CONTENT { number: 100, notes: 'This is a test' }
```

And this will appear in the server console:

```
Invoice created: 100
```

## Document level hook
You could need to define a special action only against one or more documents. To do this, let your class to extend `OTriggered` class.

Example to execute a trigger, as Javascript function, against an existent Profile class, for all the documents with property `account = 'Premium'`. The trigger will be called to prevent deletion of documents:

```sql
ALTER CLASS Profile SUPERCLASS OTriggered
UPDATE Profile SET onBeforeDelete = 'preventDeletion' WHERE account = 'Premium'
```

And now let's create the `preventDeletion()` Javascript function.

```sql
CREATE FUNCTION preventDeletion "throw new java.lang.RuntimeException('Cannot delete Premium profile ' + doc)" LANGUAGE Javascript
```

And now test the hook by trying to delete a `Premium` account.

```sql
DELETE FROM #12:1

java.lang.RuntimeException: Cannot delete Premium profile profile#12:1{onBeforeDelete:preventDeletion,account:Premium,name:Jill} v-1 (<Unknown source>#2) in <Unknown source> at line number 2
```
