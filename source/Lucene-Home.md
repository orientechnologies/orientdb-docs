Welcome to the orientdb-lucene wiki!

orientdb-lucene is compatible with OrientDB >= 1.7 (also 1.7-SNAPSHOT latest)

### How to install orientdb-lucene

**Server Mode**

Go to the [releases](https://github.com/orientechnologies/orientdb-lucene/releases) page, pick up a release
and put the jar in your OrientDB installation  under the `plugins` directory. Restart the server and start using Lucene.
If the plugin is correctly installed, you will se a in the server log:
`INFO Lucene index plugin installed and active. Lucene version: LUCENE_47 [OLuceneIndexPlugin]`


OR

Clone this project and run
`mvn assembly:assembly` and copy the jar (orientdb-lucene-version-dist.jar) from target folder into the 'lib' directory of your OrientDB installation

**Embedded Mode**

Add the Sonatype Nexus Snapshots into your pom

```
<repositories>
        <repository>
            <id>sonatype-nexus-snapshots</id>
            <name>Sonatype Nexus Snapshots</name>
            <url>https://oss.sonatype.org/content/repositories/snapshots</url>
            <releases>
                <enabled>false</enabled>
            </releases>
            <snapshots>
                <enabled>true</enabled>
            </snapshots>
        </repository>
</repositories>
```

Then add the orientdb-lucene dependency

```
<dependency>
     <groupId>com.orientechnologies</groupId>
     <artifactId>orientdb-lucene</artifactId>
      <version>1.7</version>
</dependency>
```

### How to use orientdb-lucene


Orientdb-lucene for now supports to types of index

1. [Full Text index](Full-Text-Index)
2. [Spatial Index](Spatial-Index)
