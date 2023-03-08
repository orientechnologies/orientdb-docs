
# ODtabaseDocument - declareIntent()

Declares an intent for the database.  This defines common use-cases in order to optimize execution.

## Declaring Intents

OrientDB supports three intents: `OIntentMassiveInsert`, `OIntentMassiveRead`, `OIntentNoCache`.  They are all sub-classes of the [`OIntent`](../OIntent.md) class.  Using this method, you can activate an intent for the database.

### Syntax

```
boolean ODatabaseDocument().declareIntent(OIntent intent)
```

| Argument | Type | Description|
|---|---|---|
| **`intent`** | [`OIntent`](../OIntent.md) | Defines the intent you want to enable. |

#### Return Type

This method returns a [`boolean`]({{ book.javase }}/api/java/lang/Boolean.html) instance, indicating whether the intent was successfully enabled.

