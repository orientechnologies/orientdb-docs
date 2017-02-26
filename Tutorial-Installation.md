---
search:
   keywords: ["tutorial", "install", "installation", "docker", "binary installation", "source installation"]
---

<!-- proofread 2015-12-10 SAM -->
# Installation

OrientDB is available in two editions:

- **[Community Edition](http://orientdb.com/orientdb/)** is released as an open source project under the [Apache 2 license](http://www.apache.org/licenses/LICENSE-2.0.html). This license allows unrestricted free usage for both open source and commercial projects.

- **[Enterprise Edition](http://orientdb.com/orientdb-enterprise/)**  is commercial software built on top of the Community Edition. Enterprise is developed by the same team that developed the OrientDB engine. It serves as an extension of the Community Edition, providing Enterprise features, such as:

    - Non-Stop Backup and Restore
    - Scheduled FULL and Incremental Backups
    - Query Profiler
    - Distributed Clustering configuration
    - Metrics Recording
    - Live Monitoring with configurable Alerts


The Community Edition is available as a binary package for download or as source code on GitHub.  The Enterprise Edition license is included with [Support](http://orientdb.com/support/) purchases.

## Use Docker

If you have Docker installed in your computer, this is the easiest way to run OrientDB. From the command line type:

    $ docker run -d --name orientdb -p 2424:2424 -p 2480:2480
       -e ORIENTDB_ROOT_PASSWORD=root orientdb:latest

Where instead of "root", type the root's password you want to use.

## Use Ansible

If you manage your servers through Ansible, you can use the following role : https://galaxy.ansible.com/migibert/orientdb which is highly customizable and allows you to deploy OrientDB as a standalone instance or multiple clusterized instances.

For using it, you can follow these steps :

**Install the role**
```
ansible-galaxy install migibert.orientdb
```

**Create an Ansible inventory** 

Assuming you have one two servers with respective IPs fixed at 192.168.10.5 and 192.168.10.6, using ubuntu user.
```
[orientdb-servers]
192.168.20.5 ansible_ssh_user=ubuntu
192.168.20.6 ansible_ssh_user=ubuntu
```

**Create an Ansible playbook**

In this example, we provision a two node cluster using multicast discovery mode. Please note that this playbook assumes java is already installed on the machine so you should have one step before that install Java 8 on the servers
```
- hosts: orientdb-servers
  become: yes
  vars:
    orientdb_version: 2.0.5
    orientdb_enable_distributed: true
    orientdb_distributed:
      hazelcast_network_port: 2434
      hazelcast_group: orientdb
      hazelcast_password: orientdb
      multicast_enabled: True
      multicast_group: 235.1.1.1
      multicast_port: 2434
      tcp_enabled: False
      tcp_members: []
    orientdb_users:
      - name: root
        password: root
         tasks:
  - apt:
      name: openjdk-8-jdk
      state: present
  roles:
  - role: orientdb-role
```

**Run the playbook**
`ansible-playbook -i inventory playbook.yml`


## Prerequisites

Both editions of OrientDB run on any operating system that implements the Java Virtual machine (JVM).  Examples of these include:

- Linux, all distributions, including ARM (Raspberry Pi, etc.)
- Mac OS X
- Microsoft Windows, from 95/NT and later
- Solaris
- HP-UX
- IBM AIX

OrientDB requires [Java](http://www.java.com/en/download), version 1.7 or higher.


>**Note**: In OSGi containers, OrientDB uses a `ConcurrentLinkedHashMap` implementation provided by [concurrentlinkedhashmap](https://github.com/ben-manes/concurrentlinkedhashmap) to create the LRU based cache. This library actively uses the sun.misc package which is usually not exposed as a system package. To overcome this limitation you should add property `org.osgi.framework.system.packages.extra` with value `sun.misc` to your list of framework properties.
>
>It may be as simple as passing an argument to the VM starting the platform: 
>
>```sh
>$ java -Dorg.osgi.framework.system.packages.extra=sun.misc
>```


## Binary Installation

OrientDB provides a pre-compiled binary package to install the database on your system.  Depending on your operating system, this is a tarred or zipped package that contains all the relevant files you need to run OrientDB. For desktop installations, go to [OrientDB Downloads](http://orientdb.com/download/) and select the package that best suits your system.

On server installations, you can use the `wget` utility:

<pre><code class="lang-sh">$ wget {{ book.download_multiOS }} -O orientdb-community-{{book.lastGA}}.zip</code></pre>	

Whether you use your web browser or `wget`, unzip or extract the downloaded file into a directory convenient for your use, (for example, `/opt/orientdb/` on Linux).  This creates a directory called orientdb-community-{{book.lastGA}} with relevant files and scripts, which you will need to run OrientDB on your system.

## Source Code Installation

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
Take a look to [Contribute to OrientDB](Contribute-to-OrientDB.md) if you want to be involved.


### Update Permissions

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
$ git checkout 2.2.x
$ mvn clean install
```

builds the `2.2.x` branch, instead of `master`.

## Building a single executable jar with OrientDB

OrientDB for internal components like engines, operators, factories uses Java SPI [Service Provider Interface](https://docs.oracle.com/javase/tutorial/ext/basics/spi.html). That means that the jars of OrientDB are shipped with files in `META-INF/services` that contains the implementation of components. Bear in mind that when building a single executable jar, you have to concatenate the content of files with the same name in different orientdb-*.jar . If you are using [Maven Shade Plugin](https://maven.apache.org/plugins/maven-shade-plugin/) you can use [Service Resource Transformer](https://maven.apache.org/plugins/maven-shade-plugin/examples/resource-transformers.html#ServicesResourceTransformer) to do that.

## Other Resources

To learn more about how to install OrientDB on specific environments, please refer to the guides below:

- [Install with Docker](Docker-Home.md)
- [Install with Ansible](https://github.com/migibert/orientdb-role)
- [Install on Linux Ubuntu](http://famvdploeg.com/blog/2013/01/setting-up-an-orientdb-server-on-ubuntu/)
- [Install on JBoss AS](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+JBoss+AS)
- [Install on GlassFish](http://team.ops4j.org/wiki/display/ORIENT/Installation+on+GlassFish)
- [Install on Ubuntu 12.04 VPS (DigitalOcean)](https://www.digitalocean.com/community/articles/how-to-install-and-use-orientdb-on-an-ubuntu-12-04-vps)
- [Install on Vagrant](https://bitbucket.org/nuspy/vagrant-orientdb-with-tinkerpop/overview)
