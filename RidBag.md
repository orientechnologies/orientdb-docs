# RidBag

**RidBag** is a data structure that manages multiple RIDs. It is a collection without an order that could contain duplication. Actually the bag (or multi-set) is similar to set, but could hold several instances of the same object.

**RidBag** is designed to efficiently manage edges in graph database, however it could be used directly in document level.

## Why it doesn't implement java java.util.Collection
The first goal of RidBag is to be able efficiently manage billions of entries. In the same time it should be possible to use such collection in the remote. The main restriction of such case is amount of data that should be sent over the network.

Some of the methods of `java.util.Collection` is really hard to efficiently implement for such case, when most of them are not required for relationship management.

#How it works
RidBag has 2 modes:
+ **Embedded** - has list-like representation and serialize its content right in document
+ **Tree-based** - uses external tree-based data structure to manages its content. Has some overhead over embedded one, but much more efficient for many records.

By default newly created RidBags are embedded and they are automatically converted to tree-based after reaching a threshold.
The automatic conversion in opposite direction is disabled by default due to an issues in remote mode. However you can use it if you are using OrientDB embedded and don't use remote connections.

The conversion is **always** done on server and never on client. Firstly it allows to avoid a lot of issues related to simultaneous conversions. Secondly it allows to simplify the clients.

#Configuration

RidBag could be configured with OGlobalConfiguration.
+ `RID_BAG_EMBEDDED_TO_SBTREEBONSAI_THRESHOLD` (`ridBag.embeddedToSbtreeBonsaiThreshold`) - The threshold of LINKBAG conversion to sbtree-based implementation. _Default value: 40_.
+ `RID_BAG_SBTREEBONSAI_TO_EMBEDDED_THRESHOLD` (`ridBag.sbtreeBonsaiToEmbeddedToThreshold`) - The threshold of LINKBAG conversion to embedded implementation. _Disabled by default_.

Setting `RID_BAG_EMBEDDED_TO_SBTREEBONSAI_THRESHOLD` to `-1` forces using of sbtree-based RidBag. Look at [Concurrency on adding edges]( Concurrency.md#concurrency-on-adding-edges) to know more about impact on graphs of this setting.

|    |    |
|----|----|
| ![NOTE](images/warning.png) | _NOTE: While running in distributed mode SBTrees are not supported. If using a distributed database then you must set `ridBag.embeddedToSbtreeBonsaiThreshold=Integer.MAX\_VALUE` to avoid replication errors._ |

#Interaction with remote clients
> NOTE: This topic is rather for contributors or driver developers. OrientDB users don't have to care about bag internals.

As been said rid bag could be represented in two ways: _embedded_ and _tree-based_. The first implementation serializes its entries right into stream of its owner. The second one serializes only a special pointer to an external data structure.

In the same time the server could automatically convert the bag from embedded to tree-based during save/commit. So client should be aware of such conversion because it can hold an instance of rid bag.

To "listen" for such changes client should assign a temporary collection id to bag.

The flow of save/commit commands:
```
 Client                                                         Server
   |                                                              |
   V                                                              |
  /---------\      Record content [that contain bag with uuid]        |
 |           |------------------------------------------------------->|
 |   Send    |                                                        | Convert to tree
 |  command  |                                                        | and save to disk
 | to server |   Response with changes (A new collection pointer)     |
 |           |<-------------------------------------------------------/
  \---------/        the target of new identity assignment
   |                  identified by temporary id
   |
   V
 /-----------------------------\
 | Update a collection pointer |
 | to be able perform actions  |
 | with remote tree            |
 \-----------------------------/
```


#Serialization.
> NOTE: This topic is rather for contributors or driver developers. OrietnDB users don't have to care about bag serialization

Save and load operations are performed during save/load of owner of RidBag. Other operations are performed separately and have its own commands in binary protocol.

To get definitive syntax of each network command see [Network Binary Protocol](Network-Binary-Protocol.md)
##Serialization during save and load
The bag is serialized in a binary format. If it is serialized into document by CSV serializer it's encoded with base64.

The format is following:
```
(config:byte)[(temp_id:uuid:optional)](content.md)
```
The first byte is reserved for configuration. The bits of config byte define the further structure of binary stream:
1. 1st: 1 if bag is embedded. 0 if tree-based.
2. 2nd: 1 if uuid is assigned, 0 otherwise. Used to prevent storing of UUID to disk.

If bag is embedded content has following
```
(size:int)(link:rid)*
```

If bag is tree based it doesn't serialize the content it serialize just a **collection pointer** that points where the tree structure is saved:
```
(collectionPointer)(size:int)(changes)
```
See also [serialization of collection pointer](#serialization-of-collection-pointer) and [rid bag changes](#serialization-of-rid-bag-changes)

The cached size value is also saved to stream. It don't have to be recalculated in most cases.

The _changes_ part is used by client to send changes to server. In all other cases _size_ of cahnges is 0

##Size of rid bag
Calculation of size for embedded rid bag is straight forward. But what about tree-based bag.

The issue there that we probably have some changes on client that have not been send to the server. On the other hand we probably have billions of records in bag on server. So we can't just calculate size on server because we don't know how to apply changes readjust that size regarding to changes on client. And in the same time calculation of size on client is inefficient because we had to iterate over big amount of records over the network.

That's why following approach is used:
- Client ask server for RidBag size and provide client changes
- Server apply changes in memory to calculate size, but doesn't save them to bag.
- New entries (documents that have never been saved) are not sent to server for recalculation, and the size is adjusted on client. New entries doesn't have an identity yet, but rid bag works only with identities. So to prevent miscalculation it is easier to add the count of not saved entries to calculated bag size on client.

###REQUEST_RIDBAG_GET_SIZE network command
__Request:__
```
(treePointer:collectionPointer)(changes)
```
See also [serialization of collection pointer](#serialization-of-collection-pointer) and [rid bag changes](#serialization-of-rid-bag-changes)

__Response:__
```
(size:int)
```

##Iteration over tree-based RidBag
Iteration over tree-based RidBag could be implemented with **REQUEST_SBTREE_BONSAI_GET_ENTRIES_MAJOR** and **REQUEST_SBTREE_BONSAI_FIRST_KEY**.

Server doesn't know anything about client changes. So iterator implementation should apply changes to the result before returning result to the user.

The algorithm of fetching records from server is following:
1. Get the _first key_ from SB-tree.
2. Fetch portion of data with _getEtriesMajor_ operation.
3. Repeat __step 2__ while _getEtriesMajor_ returns any result.

##Serialization of rid bag changes
```
(changesSize:int)[(link:rid)(changeType:byte)(value:int)]*
```
changes could be 2 types:
- **Diff** - value defines how the number of entries is changed for specific link.
- **Absolute** - sets the number of entries of specified link. The number defined by value field.

##Serialization of collection pointer
```
(fileId:long)(pageIndex:long)(pageOffset:int)
```
