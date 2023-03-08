
# ODatabaseDocument - getMetadata()

Retrieves the database metadata.

## Retrieving Metadata

OrientDB stores general information, like the function library, schema and security information on an [`OMetadata`](../OMetadata.md) instance of the database.  Using this method, you can retrieve the metadata to read it or operate on it.

### Syntax

```
OMetadata ODatabaseDocument().getMetadata()
```

#### Return Value

This method returns the [`OMetadata`](../OMetadata.md) instance that corresponds to the current database.
