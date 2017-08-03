


# OPEN

```
message OpenRequest {
    string databaseName,
    string userName,
    string userPassword,
}
```

```
message OpenResponse {
   int32 sessionId,
   bytes sessionToken,
}
```

# CONNECT

```
message ConnectRequest {
   string username,
   string password,
}
```
```
message ConnectResponse {
   int32 sessionId,
   bytes sessionToken,
}
```

# CLOSE
```
message CloseRequest {
   //No additional fileds, the header information are enough
}
```

# QUERY

```
message QueryRequest {
    string language,
    string queryStatement,
    boolean idempotent,
    int32 recordPerPage,
    bytes parameters,
    boolean namedParameters,
}
```

```
message QueryResponse {
   string queryId,
   boolean changedDataInTx,
   boolean hasExecutionPlan,
   Result executionPlan,
   int32 numberOfElements,
   Result result[],
   boolean hasNexPage,
   int32  numberOfQueryStas,
   QueryStat queryStat,
}
```

```
message QueryStat {
    string key,
    i64 value,
}
```

```
message Result {
    byte resulttype,
    Record record,
}
```


### Record Encoding

```
message Record {
    byte type,
    Document|Vertex|Edge|Blob content,
}
```

```
message Document {
    var_string class,
    varint numberOfFileds,
    Field fields[],
}
```

```
message Field {
    var_string name,
    byte valuetype,
    Value value,
}
```

```
Value for valuetype {
    NULL(-1) => null,v
    BOOLEAN(0) => boolean,
    INTEGER(1) => varint,v
    SHORT(2) => varint,v
    LONG(3) => varint,v
    FLOAT(4) => float,
    DOUBLE(5) => double,
    DATETIME(6) => datetime,v
    STRING(7) => var_string,
    BINARY(8) => var_bytes,
    EMBEDDED(9) => Document,v
    EMBEDDEDSET(10) => EmbeddedCollection,v
    EMBEDDEDLIST(11) => EmbeddedCollection,v
    EMBEDDEDMAP(12) => EmbeddedMap,v
    LINK(13) => Link,v
    LINKSET(14) => LinkCollection,v
    LINKLIST(15) => LinkCollection,v
    LINKMAP(16) => LinkMap,v
    BYTE(17) => byte,v
    TRANSIENT(18) => /*reserved ignore */,
    DATE(19) => date,v
    CUSTOM(20) => Custom,
    DECIMAL(21) => decimal,
    LIKNBAG(22) => LinkBag, v
    ANY(23) => /*reserved ignore */, 
}
```
```
message float {
   
}
```

```
message EmbeddedCollection {
    varint nOfElements,
    CollectionElement element[],
}
```

```
message CollectionElement {
    byte valuetype
    Value value,
}
```

```
message EmbeddedMap {
   varint nOfElements,
   MapElement,
}
```
```
message MapElement {
    var_string key,
    byte valuetype
    Value value, 
}
```

```
message LinkCollection {
   varint nOfElements,
   Link links[],
}
```

```
message Link {
   varint clusterId,
   varint clusterPos,
}
```

```
message LinkMap {
   varint nOfElements,
   LinkMapElement elements[],
}
```

```
message LinkMapElement {
   var_string key,
   Link value,
}
```

```
message Date {
   varint date,
}
```

``` 
message DateTime {
   varint date, 
}
```
```
message LinkBag {
    UUID uuid,
    byte type,
    LinkBagEmbedded|LinkBagTree data,
}

```

```
message LinkBagEmbedded {
    varint numberOfElements,
    Link elements[],
}
```

```
message LinkBagTree {
     varint fileId,
     varint pageIndex,
     varint pageOffset,
     varint bagSize,
     varint nOfChanges,
     LinkBagTreeChange changes[],
}
```

```
message LinkBagTreeChange {
    Link link,
    byte changeType,
    varint changeValue,
}

```
