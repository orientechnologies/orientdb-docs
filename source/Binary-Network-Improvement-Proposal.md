Why we need to improve the binary network protocol:

Better connection and session management
* Need the ability to find all the session of a specific client, needed for push notification (Distributed and live query)
* Need of an improved data an error managing for not drop the connection in case of error while reading
* Need for a better handshaking to understand the client status and version supported.  

Better Separation between network and disk data
* Schema e storage structure on the network should be independent to the disk structure to allow backend evolution without break the network layer
* Network record serialization format should be different to the disk format, the network format don't need record level version, and need partial data serialization for fetch plan and partial updates, keep them separate allow also to do a fast query-able format on the disk and a lighter network format.

Better Exception Management
* Need an error format that can be interpreted by not java clients.
* Need an improved logging method following the logging level, printing in error server failure, and in debug user handled exceptions.

Support for server side transaction

* Need of support of server side transaction attached to a specif session, with relative kill/timeout management and eventual recover cross node.