---
search:
   keywords: ['java', 'ODatabaseDocument', 'new blob', 'newblob']
---

# ODatabaseDocument - newBlob()

This method creates a new binary blob instance containing the given bytes.

## Creating Blobs

In cases where you want to create binary blobs on the database rather than the standard records, edges or vertices, you can do using this method and an `OBlob` instance.

### Syntax

There are two versions available to this method.  One defines the bytes you want in the blob, the other creates an empty `OBlob` instance.

```
// METHOD 1
public OBlob ODatabaseDocument.newBlob(bytes[] blobBytes)

// METHOD 2
public OBlob ODatabaseDocument.newBlob()
```

| Argument | Type | Description |
|---|---|---|
| **`blobBytes`** | [`bytes[]`]({{ book.javase }}/api/java/lang/Byte.html) | Defines the bytes to put in the blob |
