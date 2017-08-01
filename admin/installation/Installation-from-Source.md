---
search:
   keywords: ['source', 'source installation']
---

# Installation from Source

In addition to downloading the binary packages, you also have the option of compiling OrientDB from the Community Edition source code, available on GitHub.  This process requires that you install [Git](http://www.git-scm.com/) and [Apache Maven](https://maven.apache.org/) on your system.

To compile OrientDB from source code, clone the Community Edition repository, then run Maven (`mvn`) in the newly created directory:

```sh
$ git clone https://github.com/orientechnologies/orientdb
$ git checkout develop
$ cd orientdb
$ mvn clean install
```

It is possible to skip tests:
```sh
$ mvn clean install -DskipTests
```

The develop branch contains code for the next version of OrientDB. Stable versions are tagged on master branch.
For each maintained version OrientDB has its own `hotfix` branch.
As the time of writing this notes, the state of branches is:

* develop: work in progress for next 3.0.x release (3.0.x-SNAPSHOT)
* 2.2.x: hot fix for next 2.2.x stable release (2.2.x-SNAPSHOT)
* 2.1.x: hot fix for next 2.1.x stable release (2.1.x-SNAPSHOT)
* 2.0.x: hot fix for next 2.0.x stable release (2.0.x-SNAPSHOT)
* last tag on master is 2.2.0

The build process installs all jars in the local maven repository and creates archives under the `distribution` module inside the `target` directory. At the time of writing, building from branch 2.1.x gave: 
```sh
$ls -l distribution/target/
total 199920
    1088 26 Jan 09:57 archive-tmp
     102 26 Jan 09:57 databases
     102 26 Jan 09:57 orientdb-community-2.2.1-SNAPSHOT.dir
48814386 26 Jan 09:57 orientdb-community-2.2.1-SNAPSHOT.tar.gz
53542231 26 Jan 09:58 orientdb-community-2.2.1-SNAPSHOT.zip
$
```
The directory `orientdb-community-2.2.1-SNAPSHOT.dir` contains the OrientDB distribution uncompressed.
Take a look to [Contribute to OrientDB](/misc/Contribute-to-OrientDB.md) if you want to be involved.


## Update Permissions

For Linux, Mac OS X and UNIX-based operating system, you need to change the permissions on  some of the files after compiling from source.

```sh
$ chmod 755 bin/*.sh
$ chmod -R 777 config
```

These commands update the execute permissions on files in the `config/` directory and shell scripts in `bin/`, ensuring that you can run the scripts or programs that you've compiled.
  
