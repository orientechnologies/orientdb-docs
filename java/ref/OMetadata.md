---
search:
   keywords: ['java', 'ometadata']
---

# OMetadata

Interface used to store database metadata, such as the function library, schema and security.

## Using OMetadata

OrientDB stores metadata on the database.  You can retrieve it from [`ODatabaseSession`](ODatabaseSession.md) or [`ODatabaseDocument`](ODatabaseDocument) using the [`getMetadata()`](ODatabaseDocument/getMetadata.md) method.  In order to use it in your code, you also need to import the class where relevant.

```java
import com.orientechnologies.orient.core.metadata.OMetadata;
```

### Methods

| Method | Return Type | Description |
|---|---|---|
| [**`getFunctionLibrary()`**](OMetadata/getFunctionLibrary.md) | [`OFunctionLibrary`](OFunctionLibrary.md) | Retrieves the database function library |
| [**`getSchema()`**](OMetadata/getSchema.md) | [`OSchema`](OSchema.md) | Retrieves the database schema |
