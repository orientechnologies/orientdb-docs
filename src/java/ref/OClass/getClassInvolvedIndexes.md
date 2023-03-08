
# OClass - getClassInvolvedIndexes()

This method retrieves indexes that contain the given field names as their first keys.

## Retrieving Class Involved Indexes


### Syntax

```
// METHOD 1
Set<OIndex<?>> OClass().getClassInvolvedIndexes(Collection<String> colFields)

// METHOD 2
Set<OIndex<?>> OClass().getClassInvolvedIndexes(String... strFields)
```

| Argument | Type | Description |
|---|---|---|
| **`colFields`** | [`Collection`]({{ book.javase }}/api/java/util/Collection.html)[`<String>`]({{ book.javase }}/api/java/lang/String.html) | Defines the fields to check |
| **`strFields`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the fileds to check |

#### Return Value

This method returns a [`Set`]({{ book.javase }}/api/java/util/Set.html) instance that contains instances of `OIndex<?>` for each index that includes the given fields as first keys.

