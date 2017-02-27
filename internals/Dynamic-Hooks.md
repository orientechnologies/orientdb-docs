---
search:
   keywords: ['internals', 'hook', 'dynamic', 'dynamic hook', 'triggers']
---

# Dynamic Hooks
Dynamic [Hooks](Hook.md) are more flexible than [Java Hooks](../java/Java-Hooks.md), because they can be changed at run-time and can run per document if needed, but are slower than [Java Hooks](../java/Java-Hooks.md). 

Dynamic Hooks can call:

- [Functions](../Functions.md), written in SQL, Javascript or any language supported by OrientDB and JVM
- Java static methods


## Available Events

The following are the available events:

- `onBeforeCreate`, called **before** creating a new document
- `onAfterCreate`, called **after** creating a new document
- `onBeforeRead`, called **before** reading a document
- `onAfterRead`, called **after** reading a document
- `onBeforeUpdate`, called **before** updating a document
- `onAfterUpdate`, called **after** updating a document
- `onBeforeDelete`, called **before** deleting a document
- `onAfterDelete`, called **after** deleting a document


## Class level hooks
Class level hooks are defined for all the documents that relate to a class. 

To create a Class level hook, let your class to extend `OTriggered` base class. Then define a custom property for the event you are interested on.

Below is an example to setup a hook that acts at class level against `Invoice` documents.

First let's create the class `Invoice` and the custom property on an event, e.g. `onAfterCreate`:

```sql
CREATE CLASS Invoice EXTENDS OTriggered
ALTER CLASS Invoice CUSTOM onAfterCreate=invoiceCreated
```

Let's now create the function that will be executed when the `onAfterCreate` event occurs. For this example we will create a Javascript function (`invoiceCreated`) that prints in the server console the invoice number created:

```sql
CREATE FUNCTION invoiceCreated "print('\\nInvoice created: ' + doc.field('number'));" LANGUAGE Javascript
```

Now try the hook by creating a new `Invoice` document:

```sql
INSERT INTO Invoice CONTENT { number: 100, notes: 'This is a test' }
```

The following text will appear in the server console:

```
Invoice created: 100
```


## Document level hook
You could need to define a special action only against one or more documents. To do this, let your class to extend `OTriggered` class. Then define a property for the event you are interested on, on all documents where you want the hook to be active.

For example, if you want to prevent deletion of all the documents with property `account = 'Premium'` in the already existing class `Profile`, first alter the class to set `OTriggered` as SUPERCLASS:

```sql
ALTER CLASS Profile SUPERCLASS OTriggered
```

Then use an UPDATE command to set a property with name equals to one of the available [Events](Dynamic-Hooks.md#available-events) and value equals to the function you want to be executed when the event occurs:

```sql
UPDATE Profile SET onBeforeDelete = 'preventDeletion' WHERE account = 'Premium'
```

Now let's create the `preventDeletion()` function, e.g. in Javascript:

```sql
CREATE FUNCTION preventDeletion "throw new java.lang.RuntimeException('Cannot delete Premium profile ' + doc)" LANGUAGE Javascript
```

To test the hook try to delete a `Premium` account, e.g.:

```sql
DELETE FROM #12:1
```

The following Exception will be returned:

```
java.lang.RuntimeException: Cannot delete Premium profile profile#12:1{onBeforeDelete:preventDeletion,account:Premium,name:Jill} v-1 (<Unknown source>#2) in <Unknown source> at line number 2
```
