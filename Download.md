The OrientDB development team is very active so if you've started learning OrientDB right now we suggest to clone the source repository and use the "develop" branch (latest SNAPSHOT). Follow these [instructions](https://github.com/orientechnologies/orientdb/wiki/Download#compile-it-by-your-own). Is a snapshot stable enough? All the SNAPSHOTs pass the thousands of test cases, so the answer is YES. However don't worry, we usually create a new stable release from the SNAPSHOT about every 3 months. If however you're afraid of using a SNAPSHOT yet, it's ok: use a [stable one](http://www.orientdb.com/download/) and follow the **[Installation instructions](Installation.md)**.


|Release |Status|Suggested for|Maven Repository|GIT branch|
|--------|-----|-------|------|----------|----|----|
|2.0-SNAPSHOT|[Development](https://github.com/orientechnologies/orientdb/issues?milestone=3&page=1&state=open)|Development| [Snapshot](https://oss.sonatype.org/content/repositories/snapshots/com/orientechnologies/orientdb-community/2.0-SNAPSHOT/) - [pom.xml](https://github.com/orientechnologies/orientdb/wiki/Download#last-snapshot-compiles-and-pass-all-the-test-cases)|[develop](https://github.com/orientechnologies/orientdb/tree/develop)
|1.7.6|[Production](https://github.com/orientechnologies/orientdb/issues?milestone=23&state=closed)|Production|  [pom.xml](https://github.com/orientechnologies/orientdb/wiki/Download#last-stable)|[master](https://github.com/orientechnologies/orientdb)


For older release or more information go to the official [download page](http://orientdb.com/download/).

------------
## What distribution should I use ? ##

OrientDB comes with 2 distributions:
- OrientDB Community Edition, the default Open Source version released with Apache 2 license
- [OrientDB Enterprise Edition](http://www.orientechnologies.com/orientdb-enterprise), based on the Community Edition, adds Enterprise Level features. It's available with [support](http://www.orientechnologies.com/support) by Orient Technologies company and has a commercial version.

# Version numbers #

Starting from release 1.0 OrientDB uses the [Semantic Versioning](http://semver.org/) approach.

Consider a version format of **X.Y.Z** (Major.Minor.Patch). Bug fixes not affecting the API increment the patch version, backwards compatible API additions/changes increment the minor version, and backwards incompatible API changes increment the major version.

This system is called "Semantic Versioning." Under this scheme, version numbers and the way they change convey meaning about the underlying code and what has been modified from one version to the next.

# Distributions #

Download **latest official release** at  [this page](http://orientdb.com/download/).

## Download binaries from Maven repository ##

Get single binaries as jars form the Sonatype's Official [Maven Repository](https://oss.sonatype.org/content/repositories/releases/com/orientechnologies/).

## Latest Snapshot ##

This is the suggested download if want to have and use the last version with all the new features and bugs fixed. Snapshot builds always compile and pass all the test cases. These packages don't contain the "GratefulDeadConcerts" database. To create it just run the test suite with "ant test".

Download the [last snapshot](https://oss.sonatype.org/content/repositories/snapshots/com/orientechnologies/orientdb/).

## From continuous integration ##

This is the place where you can always find the last version automatically compiled from Git at every change:  http://helios.orientechnologies.com

## Via MAVEN repository ##

If you want to use OrientDB through Java the best and easy way is through Apache Maven. If you want to use the client/server version you need the [Full distribution](#Full_distribution).

Add this snippet in your pom.xml file:

## Add "bundle" artifact type to the list of Maven types

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.felix</groupId>
      <artifactId>maven-bundle-plugin</artifactId>
      <version>2.3.6</version>
      <extensions>true</extensions>
    </plugin>
  </plugins>
</build>
```

### Last stable

```xml
<dependency>
  <groupId>com.orientechnologies</groupId>
  <artifactId>orient-commons</artifactId>
  <version>1.7.6</version>
  <type>bundle</type>
</dependency>
<dependency>
  <groupId>com.orientechnologies</groupId>
  <artifactId>orientdb-core</artifactId>
  <version>1.7.6</version>
  <type>bundle</type>
</dependency>
<!-- INCLUDE THIS IF YOU'RE CONNECTING TO THE SERVER THROUGH THE REMOTE ENGINE -->
<dependency>
  <groupId>com.orientechnologies</groupId>
  <artifactId>orientdb-client</artifactId>
  <version>1.7.6</version>
  <type>bundle</type>
</dependency>
<!-- END REMOTE ENGINE DEPENDENCY -->
```
## Last snapshot (compiles and pass all the test cases) ##

Snapshots are hosted on official Maven Sonatype.org repository.
```xml
<dependency>
  <groupId>com.orientechnologies</groupId>
  <artifactId>orient-commons</artifactId>
  <version>2.0-SNAPSHOT</version>
  <type>bundle</type>
</dependency>
<dependency>
  <groupId>com.orientechnologies</groupId>
  <artifactId>orientdb-core</artifactId>
  <version>2.0-SNAPSHOT</version>
  <type>bundle</type>
</dependency>

<!-- INCLUDE THIS IF YOU'RE CONNECTING TO THE SERVER THROUGH THE REMOTE ENGINE -->
<dependency>
  <groupId>com.orientechnologies</groupId>
  <artifactId>orientdb-client</artifactId>
  <version>2.0-SNAPSHOT</version>
  <type>bundle</type>
</dependency>
<!-- END REMOTE ENGINE DEPENDENCY -->

<!-- INCLUDE THIS IF YOU'RE USING THE TINKERPOP'S BLUEPRINTS API -->
<dependency>
  <groupId>com.tinkerpop.blueprints</groupId>
  <artifactId>blueprints-orient-graph</artifactId>
  <version>2.5.0</version>
  <type>bundle</type>
</dependency>
<!-- END BLUEPRINTS DEPENDENCY -->

<repository>
  <id>sonatype-nexus-releases</id>
  <name>Sonatype Nexus Snapshots</name>
  <url>https://oss.sonatype.org/content/repositories/snapshots</url>
</repository>
```
## Compile it by your own ##
The OrientDB development team is very active, so if your in the middle of the development of your application we suggest to use last SNAPSHOT from the git source repository. All you need is:
- [JDK (Java Development Kit) 6+](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
- [git](http://git-scm.com/) SCM tool
- [Apache Ant v1.8.2+](http://ant.apache.org/manual/install.html)

Then follow these simple steps:
```
> git clone --branch develop https://github.com/orientechnologies/orientdb.git
> cd orientdb
> ant clean install
```

At the end of the build you will have a brand new distribution under the path: ../releases/orientdb-community-2.0-SNAPSHOT. Use it as a normal OrientDB distribution directory.

Every time you want to update your distribution with last changes do:

```
> git pull origin develop
> ant clean install
```
At the end of the build your distribution (../releases/orientdb-community-2.0-SNAPSHOT) will be updated with last OrientDB libraries.

Every time you compile a new version, assure to have the permissions to execute the .sh files under the "bin" directory:

```
> cd ../releases/orientdb-community-2.0-SNAPSHOT/bin
> chmod u+x *.sh
```


# Badges

Below the badges you can use in your web site, application and presentation to say to the world "Hey, I'm using OrientDB!". The best would be linking that button to the web site: <http://www.orientdb.com>

Once used you can tell us your story to be published between the [Production deployments page](Production-Deployments.md).

<table>
  <tr><td>Description</td><td>Image normal size</td><td>Image small size</td></tr>
  <tr><td>Classic button</td><td>![image](http://www.orientdb.com/images/powered_by_orientdb_white.png)</td><td>![image](http://www.orientdb.com/images/powered_by_orientdb_white_small.png)</td></tr>
  <tr><td>Reflex button</td><td>![image](http://www.orientdb.com/images/powered_by_orientdb_reflex.png)</td><td>![image](http://www.orientdb.com/images/powered_by_orientdb_reflex_small.png)</td></tr>
  <tr><td>Blue button</td><td>![image](http://www.orientdb.com/images/powered_by_orientdb_blue.png)</td><td>![image](http://www.orientdb.com/images/powered_by_orientdb_blue_small.png)</td></tr>
  <tr><td>Green button</td><td>![image](http://www.orientdb.com/images/powered_by_orientdb_green.png)</td><td>![image](http://www.orientdb.com/images/powered_by_orientdb_green_small.png)</td></tr>
</table>