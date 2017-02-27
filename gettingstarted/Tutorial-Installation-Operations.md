---
search:
   keywords: ["tutorial", "installation"]
---

# Installation

OrientDB is available in two editions:
- **[Community Edition](http://www.orientechnologies.com/orientdb/)** This edition is released as an open source project under the [Apache 2 license](http://www.apache.org/licenses/LICENSE-2.0.html). This license allows unrestricted free usage for both open source and commercial projects.
- **[[Enterprise Edition](http://www.orientechnologies.com/orientdb-enterprise/)](http://www.orientechnologies.com/enterprise.htm)** OrientDB Enterprise edition is commercial software built on top of the Community Edition. Enterprise is developed by the same team that developed the OrientDB engine. It serves as an extension of the Community Edition by providing Enterprise features such as:
    - Query Profiler
    - Distributed Clustering configuration
    - Metrics Recording
    - Live Monitoring with configurable Alerts

An Enterprise Edition license is included without charge if you purchase [Support](http://www.orientechnologies.com/support/).

### Prerequisites

Both editions run on every operating system that has an implementation of the Java Virtual Machine (JVM), for example:

 - All Linux distributions, including ARM (Raspberry Pi, etc.)
 - Mac OS X
 - Microsoft Windows from 95/NT or later
 - Solaris
 - HP-UX
 - IBM AIX

This means the only requirement for using OrientDB is to have [Java version 1.6 or higher](http://www.java.com/en/download) installed.

### Download Binaries

The easiest and fastest way to start using OrientDB is to download binaries from the [Official OrientDB Download Page](http://www.orientechnologies.com/download/).

### Compile Your Own Community Edition

Alternatively, you can clone the Community Edition project from [GitHub](https://github.com/orientechnologies/orientdb) and compile it. This allows you access to the latest functionality without waiting for a distribution binary. To build the Community Edition, you must first install [the Apache Ant tool](http://ant.apache.org/bindownload.cgi) and follow these steps:

    > git clone git@github.com:orientechnologies/orientdb.git
    > cd orientdb
    > ant clean install

After the compilation, all the binaries are placed under the `../releases` directory.

#### Change Permissions
The Mac OS X, Linux, and UNIX based operating systems typically require you to change the permissions to execute scripts. The following command will apply the necessary permissions for these scripts in the `bin` directory of the OrientDB distribution:

    > chmod 755 bin/*.sh
    > chmod -R 777 config

#### Use inside of OSGi container
OrientDB uses a ConcurrentLinkedHashMap implementation provided by https://github.com/ben-manes/concurrentlinkedhashmap to create the LRU based cache. This library actively uses the sun.misc package which is usually not exposed as a system package. To overcome this limitation you should add property `org.osgi.framework.system.packages.extra` with value `sun.misc` to your list of framework properties. It may be as simple as passing an argument to the VM starting the platform: 

    > java -Dorg.osgi.framework.system.packages.extra=sun.misc

### Other Resources

To learn more about how to install OrientDB on specific environments, please refer to the guides below:
- [Install as service on Unix, Linux and MacOSX](Unix-Service.md)
- [Install as service on Windows](Windows-Service.md)
- [Install with Docker](Docker-Home.md)
- [Install on Linux Ubuntu](http://famvdploeg.com/blog/2013/01/setting-up-an-orientdb-server-on-ubuntu/)
- [Install on JBoss AS](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+JBoss+AS)
- [Install on GlassFish](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+GlassFish)
- [Install on Ubuntu 12.04 VPS (DigitalOcean)](https://www.digitalocean.com/community/articles/how-to-install-and-use-orientdb-on-an-ubuntu-12-04-vps)
- [Install on Vagrant](https://bitbucket.org/nuspy/vagrant-orientdb-with-tinkerpop/overview)
