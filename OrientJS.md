# OrientJS Driver

OrientDB supports all JVM languages for server-side scripting.  Using the OrientJS module, you can develop database applications for OrientDB using the Node.js language.  It is fast, lightweight and uses the binary protocol.

- [**Getting Started with OrientJS**](OrientJS-Getting-Started.md) Provides an introduction to OrientJS, it's features and how to install it and initialize a server connections in your applications.

## Support 

OrientJS aims to support version 2.0.0 and later.  It has been tested on both versions 2.0.x and 2.1 of OrientDB.  While it may work with earlier versions, it does not currently support them directly.

<!-- Need new boilerplate for Contributions -->

>**NOTE**: OrientJS does not currently support the tree-based [Bonsai Structure](RidBag.md) feature in OrientDB, as it relies on additional network requests.  
>
>This means that by default, the result of `JSON.stringify(record)` on a record with 119 edges would behave very differently from a record with more than 120 edges.  This can lead to unexpected results that may not appear at any point in development, but which could occur when your application runs in production.
>
>For more information, see [Issue 2315](https://github.com/orientechnologies/orientdb/issues/2315).  Until this issue is addressed, it is **strongly recommended** that you set the `RID_EMBEDDED_TO_SBTREEBONSAI_THRESHOLD` to a very large value, for instance 2147483647.
