
# ODatabaseDocument - save()

This method saves the given object to the database.

## Saving Data

Using this method you can save objects in synchronous to the database.  If the given object is not dirty, (that is, changed from the state stored on the database), then OrientDB ignores the operation.  When saving records, you can optionally define the cluster in which you want to save it.  If the cluster doesn't exist, the method throws an error.

### Syntax

```
<RET extends T> RET ODatabaseDocument().save(T obj)
<RET extends T> RET ODatabaseDocument().save(T obj, String cluster)
```

| Argument | Type | Description |
| **`obj`**  | `T` | Defines the object you want to save |
| **`cluster`** | [`String`]({{ book.javase }}/api/java/lang/String.html) | Defines the name of the cluster in which to add a record |


#### Return Value

This method returns the saved object.



