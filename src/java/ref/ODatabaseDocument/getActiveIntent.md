---
search:
   keywords: ['java', 'odatabasedocument', 'ointent', 'getactiveintent']
---

# ODatabaseDocument - getActiveIntent()

Returns the active Intent for the current session.

## Retrieving Intents

OrientDB uses Intents to shift its internal configuration, optimizing the database for particular tasks, like huge reads or write operations.  Intents are all subclasses of the [`OIntent`](../OIntent.md) class.  Using this method you can retrieve the current Intent, then check it against the operation you plan to perform or change it to another Intent, using the [`declareIntent`](declareIntent.md) method.

### Syntax

```
OIntent ODatabaseDocument().getActiveIntent()
```

#### Return Value

This method returns an [`OIntent`](../OIntent.md) instance, representing the current active Intent for the database.
