<!-- proofread 2015-12-10 SAM -->
# Installation

OrientDB is available in two editions:

- **[Community Edition](http://www.orientechnologies.com/orientdb/)** This edition is released as an open source project under the [Apache 2 license](http://www.apache.org/licenses/LICENSE-2.0.html). This license allows unrestricted free usage for both open source and commercial projects.

- **[[Enterprise Edition](http://www.orientechnologies.com/orientdb-enterprise/)](http://www.orientechnologies.com/enterprise.htm)** OrientDB Enterprise Edition is commercial software built on top of the Community Edition. Enterprise is developed by the same team that developed the OrientDB engine. It serves as an extension of the Community Edition, providing Enterprise features, such as:

    - Query Profiler
    - Distributed Clustering configuration
    - Metrics Recording
    - Live Monitoring with configurable Alerts


The Community Edition is available as a binary package for download or as source code on GitHub.  The Enterprise Edition license is included with [Support](http://www.orientechnologies.com/support/) purchases.

**Prerequisites**

Both editions of OrientDB run on any operating system that implements the Java Virtual machine (JVM).  Examples of these include:

- Linux, all distributions, including ARM (Raspberry Pi, etc.)
- Mac OS X
- Microsoft Windows, from 95/NT and later
- Solaris
- HP-UX
- IBM AIX

OrientDB requires [Java](http://www.java.com/en/download), version 1.7 or higher.


>**Note**: In OSGi containers, OrientDB uses a `ConcurrentLinkedHashMap` implementation provided by [concurrentlinkedhashmap](https://code.google.com/p/concurrentlinkedhashmap/) to create the LRU based cache. This library actively uses the sun.misc package which is usually not exposed as a system package. To overcome this limitation you should add property `org.osgi.framework.system.packages.extra` with value `sun.misc` to your list of framework properties.
>
>It may be as simple as passing an argument to the VM starting the platform: 
>
>```sh
>$ java -Dorg.osgi.framework.system.packages.extra=sun.misc
>```

## Installing OrientDB

There are two methods available to install OrientDB, with some variations on each depending on your operating system. The first method is to download a binary package from OrientDB. The other method is to compile the package from the source code.


### Binary Installation

OrientDB provides a pre-compiled binary package to install the database on your system.  Depending on your operating system, this is a tarred or zipped package that contains all the relevant files you need to run OrientDB. For desktop installations, go to [OrientDB Downloads](http://www.orientechnologies.com/download/) and select the package that best suits your system.

On server installations, you can use the `wget` utility:

```sh
$ wget https://orientdb.com/download.php?file=orientdb-community-2.1.2.tar.gz
```

Whether you use your web browser or `wget`, unzip or extract the downloaded file into a directory convenient for your use, (for example, `/opt/orientdb/` on Linux).  This creates a directory called `orientdb-community-2.1.2` with relevant files and scripts, which you will need to run OrientDB on your system.

### Source Code Installation

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

* develop: work in progress for next 2.2.x release (2.2.0-SNAPSHOT)
* 2.1.x: hot fix for next 2.1.x stable release (2.1.10-SNAPSHOT)
* 2.0.x: hot fix for next 2.0.x stable release (2.0.17-SNAPSHOT)
* last tag on master is 2.1.9  

The build process installs all jars in the local maven repository and creates archives under the `distribution` module inside the `target` directory. At the time of writing, building from branch 2.1.x gave: 
```sh
$ls -l distribution/target/
total 199920
    1088 26 Jan 09:57 archive-tmp
     102 26 Jan 09:57 databases
     102 26 Jan 09:57 orientdb-community-2.1.10-SNAPSHOT.dir
48814386 26 Jan 09:57 orientdb-community-2.1.10-SNAPSHOT.tar.gz
53542231 26 Jan 09:58 orientdb-community-2.1.10-SNAPSHOT.zip
$
```
The directory `orientdb-community-2.1.10-SNAPSHOT.dir` contains the OrientDB distribution uncompressed.
Take a look to [Contribute to OrientDB](Contribute-to-OrientDB.md) if you want to be involved.


#### Update Permissions

For Linux, Mac OS X and UNIX-based operating system, you need to change the permissions on  some of the files after compiling from source.

```sh
$ chmod 755 bin/*.sh
$ chmod -R 777 config
```

These commands update the execute permissions on files in the `config/` directory and shell scripts in `bin/`, ensuring that you can run the scripts or programs that you've compiled.

## Post-installation Tasks

For desktop users installing the binary, OrientDB is now installed and can be run through shell scripts found in the package `bin` directory of the installation.  For servers, there are some additional steps that you need to take in order to manage the database server for OrientDB as a service.  The procedure for this varies, depending on your operating system.

- [Install as Service on Unix, Linux and Mac OS X](Unix-Service.md)
- [Install as Service on Microsoft Windows](Windows-Service.md)

## Upgrading

When the time comes to upgrade to a newer version of OrientDB, the methods vary depending on how you chose to install it in the first place.  If you installed from binary downloads, repeat the download process above and update any symbolic links or shortcuts to point to the new directory.

For systems where OrientDB was built from source, pull down the latest source code and compile from source.

```sh
$ git pull origin master
$ mvn clean install
```

Bear in mind that when you build from source, you can switch branches to build different versions of OrientDB using Git.  For example,

```sh
$ git checkout 2.1.x
$ mvn clean install
```

builds the `2.1.x` branch, instead of `master`.


## Other Resources

To learn more about how to install OrientDB on specific environments, please refer to the guides below:

- [Install with Docker](Docker-Home.md)
- [Install on Linux Ubuntu](http://famvdploeg.com/blog/2013/01/setting-up-an-orientdb-server-on-ubuntu/)
- [Install on JBoss AS](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+JBoss+AS)
- [Install on GlassFish](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+GlassFish)
- [Install on Ubuntu 12.04 VPS (DigitalOcean)](https://www.digitalocean.com/community/articles/how-to-install-and-use-orientdb-on-an-ubuntu-12-04-vps)
- [Install on Vagrant](https://bitbucket.org/nuspy/vagrant-orientdb-with-tinkerpop/overview)
