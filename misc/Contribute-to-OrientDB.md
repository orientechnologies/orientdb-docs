---
search:
   keywords: ['contribute', 'contribution', 'contribute to OrientDB']
---

# How to Contribute to OrientDB

In order to contribute issues and pull requests, please sign OrientDB's [Contributor License Agreement](https://www.clahub.com/agreements/orientechnologies/orientdb). The purpose of this agreement is to protect users of this codebase by ensuring that all code is free to use under the stipulations of the [Apache2 license](http://www.apache.org/licenses/LICENSE-2.0.html).

## Pushing into main repository
OrientDB uses different branches to support the development and release process. 
The `develop` branch contains code under development for which there's not a stable release yet. 
When a stable version is released, a branch for the hotfix is created. 
Each stable release is merged on master branch and tagged there.
At the time of writing these notes, the state of branches is:

* develop: work in progress for next 2.2.x release (2.2.0-SNAPSHOT)
* 2.1.x: hot fix for next 2.1.x stable release (2.1.10-SNAPSHOT)
* 2.0.x: hot fix for next 2.0.x stable release (2.0.17-SNAPSHOT)
* last tag on master is 2.1.9  

If you'd like to contribute to OrientDB with a patch follow the following steps:
* fork the repository interested in your change. The main one is https://github.com/orientechnologies/orientdb, while some other components reside in other projects under [Orient Technologies](https://github.com/orientechnologies/) umbrella.
* clone the forked repository
* select the branch, e.g the develop branch: 
 * `git checkout develop`
* apply your changes with your favourite editor or IDE
* test that Test Suite hasn't been broken by running:
 * `mvn clean test`
* if all the tests pass, then do a **Pull Request** (PR) against the branch (e.g.: **"develop"**) on GitHub repository and write a comment about the change. Please don't send PR to "master" because we use that branch only for releasing

## Documentation

If you want to contribute to the OrientDB documentation, the right repository is: https://github.com/orientechnologies/orientdb-docs. Every 24-48 hours all the contributions are reviewed and published on the public [documentation](http://orientdb.com/docs/last/).

## Code formatting


### v 3.1 and following

Since v 3.1, OrientDB uses Google code formatter. 

In IntelliJ Idea, you can use this plugin https://plugins.jetbrains.com/plugin/8527-google-java-format

From Maven, you can run `mvn com.coveo:fmt-maven-plugin:format` for automatic code format. 

### v 3.0 and previous releases

For previus versions (until 3.0) you can use eclipse java formatter config file, that you can find here: [_base/ide/eclipse-formatter.xml](https://github.com/orientechnologies/orientdb/blob/master/_base/ide/eclipse-formatter.xml).

If you use IntelliJ IDEA you can install [this](http://plugins.jetbrains.com/plugin/?id=6546) plugin and use formatter profile mentioned above.


## Debugging

### Run OrientDB as standalone server
The settings to run OrientDB Server as stand-alone (where the OrientDB's home is `/repositories/orientdb/releases/orientdb-community-2.2-SNAPSHOT`) are:

Main Class: `com.orientechnologies.orient.server.OServerMain`
VM parameters: 
```
-server
-DORIENTDB_HOME=/repositories/orientdb/releases/orientdb-community-2.2-SNAPSHOT
-Dorientdb.www.path=src/site
-Djava.util.logging.config.file=${ORIENTDB_HOME}/config/orientdb-server-log.properties
-Dorientdb.config.file=${ORIENTDB_HOME}/config/orientdb-server-config.xml
-Drhino.opt.level=9
```
Use classpath of module: `orientdb-graphdb`


### Run OrientDB distributed
The settings to run OrientDB Server as distributed (where the OrientDB's home is `/repositories/orientdb/releases/orientdb-community-2.2-SNAPSHOT`) are:

Main Class: `com.orientechnologies.orient.server.OServerMain`
VM parameters: 
```
-server
-DORIENTDB_HOME=/repositories/orientdb/releases/orientdb-community-2.2-SNAPSHOT
-Dorientdb.www.path=src/site
-Djava.util.logging.config.file=${ORIENTDB_HOME}/config/orientdb-server-log.properties
-Dorientdb.config.file=${ORIENTDB_HOME}/config/orientdb-server-config.xml
-Drhino.opt.level=9
-Ddistributed=true
```
Use classpath of module: `orientdb-distributed`

In order to debug OrientDB in distributed mode, changed the scope to "runtime" in file distributed/pom.xml:

```xml
<groupId>com.orientechnologies</groupId>
<artifactId>orientdb-graphdb</artifactId>
<version>${project.version}</version>
<scope>runtime</scope>
```

In this way IDE like IntelliJ can start the server correctly that requires graphdb dependency.

