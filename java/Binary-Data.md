---
search:
   keywords: ['Java API', 'binary data']
---

# Binary Data

OrientDB natively handles binary data, namely BLOB.


# Techniques

## Store on file system and save the path in the document

This is the simpler way to handle binary data: store them to the file system and just keep the path to retrieve them.

Example:
```java
ODocument doc = database.newInstance("MyClass");
doc.field("binary", "/usr/local/orientdb/binary/test.pdf");
database.save(doc);
```

Pros:
- Easy to write
- 100% delegated to the File System

Cons:
- Binary data can't be automatically distributed using the OrientDB cluster

## Store it as a Document field

ODocument class is able to manage binary data in form of `byte[]` (byte array). Example:
```java
ODocument doc = database.newInstance("MyClass");
doc.field("binary", "Binary data".getBytes());
database.save(doc);
```


This is the easiest way to keep the binary data inside the database, but it's not really efficient on large BLOB because the binary content is serialized in Base64. This means a waste of space (33% more) and a run-time cost in marshalling/unmarshalling.

Also be aware that once the binary data reaches a certain size (10 MB in some recent testing), the database's performance can decrease significantly. If this occurs, the solution is to use the `ORecordBytes` solution described below.

Pros:
- Easy to write

Cons:
- Waste of space +33%
- Run-time cost of marshalling/unmarshalling
- Significant performance decrease once the binary reaches a certain large size

## Store it with ORecordBytes

The `ORecordBytes` class is a record implementation able to store binary content without conversions (see above). This is the faster way to handle binary data with OrientDB but needs a separate record to handle it. This technique also offers the highest performance when storing and retrieving large binary data records.

Example:
```java
OBlob record = database.newBlob("Binary data".getBytes());
database.save(record);
```

Since this is a separate record, the best way to reference it is to link it to a Document record. Example:
```java
OBlob record = database.newBlob("Binary data".getBytes());
ODocument doc = new ODocument();
doc.field("id", 12345);
doc.field("binary", record);
database.save(doc);
```

In this way you can access to the binary data by traversing the `binary` field of the parent's document record.
```java
OBlob record = doc.field("binary");
byte[] content = record.toStream();
```

`ORecordBytes` class can work with Java Streams:
```java
OBlob record = database.newBlob();
record.fromInputStream(in);
record.toOutputStream(out);
```

Pros:
- Fast and compact solution

Cons:
- Slightly complex management

| ![NOTE](../images/warning.png) | While running in distributed mode ORecordBytes is not supported yet. See https://github.com/orientechnologies/orientdb/issues/3762 for more information. |
|----|:----|

## Large content: split in multiple ORecordBytes

OrientDB can store up to 2Gb as record content. But there are other limitations on network buffers and file sizes you should tune to reach the 2GB barrier.

However managing big chunks of binary data means having big `byte[]` structures in RAM and this could cause a Out Of Memory of the JVM. Many users reported that splitting the binary data in chunks is the best solution.

Continuing from the last example we could handle not a single reference against one `ORecordBytes` record but multiple references. A One-To-Many relationship. For this purpose the `LINKLIST` type fits perfectly because maintains the order.

To avoid OrientDB caches in memory large records use the massive insert intent and keep in the collection the [RID](../datamodeling/Concepts.md#record-id), not the entire records.

Example to store in OrientDB the file content:
```java
database.declareIntent( new OIntentMassiveInsert() );

List<ORID> chunks = new ArrayList<ORID>();
InputStream in = new BufferedInputStream( new FileInputStream( file ) );
while ( in.available() > 0 ) {
  final ORecordBytes chunk = new ORecordBytes();

  // READ REMAINING DATA, BUT NOT MORE THAN 8K
  chunk.fromInputStream( in, 8192 );

  // SAVE THE CHUNK TO GET THE REFERENCE (IDENTITY) AND FREE FROM THE MEMORY
  database.save( chunk );

  // SAVE ITS REFERENCE INTO THE COLLECTION
  chunks.add( chunk.getIdentity() );
}

// SAVE THE COLLECTION OF REFERENCES IN A NEW DOCUMENT
ODocument record = new ODocument();
record.field( "data", chunks );
database.save( record );

database.declareIntent( null );
```

Example to read back the file content:
```java
record.setLazyLoad(false);
for (OIdentifiable id : (List<OIdentifiable>) record.field("data")) {
    ORecordBytes chunk = (ORecordBytes) id.getRecord();
    chunk.toOutputStream(out);
    chunk.unload();
}
```

Pros:
- Fastest and compact solution

Cons:
- More complex management

| ![NOTE](../images/warning.png) | While running in distributed mode ORecordBytes is not supported yet. See https://github.com/orientechnologies/orientdb/issues/3762 for more information. |
|----|:----|


# Conclusion

What to use?
- Have you short binary data? Store them as document's field
- Do you want the maximum of performance and better use of the space? Store it with `ORecordBytes`
- Have you large binary objects? Store it with `ORecordBytes` but split the content in multiple records
