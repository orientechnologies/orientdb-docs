---
search:
   keywords: ['OrientJS', 'Node.js', 'node']
---

# OrientJS Driver

OrientDB supports all JVM languages for server-side scripting.  Using the OrientJS module, you can develop database applications for OrientDB using the Node.js language.  It is fast, lightweight and uses the binary protocol, with features including:
- Intuitive API, based on the [Bluebird](https://github.com/petkaantonov/bluebird) promise library.
- Fast Binary Protocol Parser
- Distributed Support
- Multi-Database Access, through the same socket.
- Connection Pooling
- Migration Support

This page provides basic information on setting up OrientJS on your system.  For more information on using OrientJS in developing applications, see
- [Server API](OrientJS-Server.md)
- [Database API](OrientJS-Database.md)
- [Class API](OrientJS-Class.md)
- [Index API](OrientJS-Index.md)
- [Function API](OrientJS-Functions.md)
- [Queries](OrientJS-Query.md)
- [Transactions](OrientJS-Transactions.md)
- [Events](OrientJS-Events.md)


## Installation

In order to use OrientJS, you need to install it on your system.  There are two methods available to you in doing this: you can install it from the Node.js repositories or you can download the latest source code and build it on your local system.

Both methods require the Node.js package manager, NPM, and can install OrientJS as either a local or global package.


### Installing from the Node.js Repositories

When you call NPM and provide it with the specific package name, it connects to the Node.js repositories and downloads the source package for OrientJS.  It then installs the package on your system, either at a global level or in the `node_modules` folder of the current working directory.

- To install OrientJS locally in `node_modules`, run the following command:

  <pre>
  $ <code class="lang-sh userinput">npm install orientjs</code>
  </pre>

- To install OrientJS globally, run the following command as root or an administrator:

  <pre>
  # <code class="lang-sh userinput">npm install orientjs -g</code>
  </pre>

Once NPM finishes the install, you can begin to develop database applications using OrientJS.



### Building from the Source Code

When building from source code, you need to download the driver directly from [GitHub](https://github.com/orientechnologies/orientjs), then run NPM against the branch you want to use or test.

1. Using Git, clone the package repository, then enter the new directory:

   <pre>
   $ <code class="lang-sh userinput">git clone https://github.com/orientechnologies/orientjs.git</code>
   $ <code class="lang-sh userinput">cd orientjs</code>
   </pre>

1. When you clone the repository, Git automatically provides you with the current state of the `master` branch.  If you would like to work with another branch, like `develop` or test features on past releases, you need to check out the branch you want.  For instance,

   <pre>
   $ <code class="lang-sh userinput">git checkout develop</code>
   </pre>

1. Once you've selected the branch you want to build, call NPM to handle the installation.

   - To install OrientJS locally, run the following command:

     <pre>
     $ <code class="lang-sh userinput">npm install</code>
     </pre>

   - To install OrientJS globally, instead run this command as root or an administrator:

     <pre>
     # <code class="lang-sh userinput">npm install -g</code>
     </pre>

1. Run the tests to make sure it works:

   <pre>
   $ <code class="lang-sh userinput">npm test</code>
   </pre>

By calling NPM without an argument, it builds the package in the current working directory, here your local copy of the OrientJS GitHub repository.



## Support

OrientJS aims to support version 2.0.0 and later.  It has been tested on both versions 2.0.x and 2.1 of OrientDB.  While it may work with earlier versions, it does not currently support them directly.


### Bonsai Structure

Currently, OrientJS does not support the tree-based [Bonsai Structure](RidBag.md) feature in OrientDB, as it relies on additional network requests.

What this means is that, by default, the result  of `JSON.stringify(record)` on a record with 119 edges would behave very differently from a record with more than 120 edges.  It can lead to unexpected results that may not appear at any point during development, but which will occur when your application runs in production

For more information, see [Issue 2315](https://github.com/orientechnologies/orientdb/issues/2315).  Until this issue is addressed it is **strongly recommended** that you set the `RID_EMBEDDED_TO_SBTREEBONSAI_THRESHOLD` to a very large figure, such as 2147483647.


### Maximum Call Stack Size Exceeded

There is a maximum call stack size issue currently being worked on.  This occurs in queries over large record-sets (as in, in the range of 150,000 records), results in a `RangeError` exception.

For more information, see [Issue 116](https://github.com/orientechnologies/orientjs/issues/116).

