## How to build

OrientDB-jdbc uses maven, so just execute:

```mvn clean install```


## Build a jar-with-dependencies

To obtain a jar with dependency included under target directory, execute:

```mvn clean assembly:assembly -DskipTests=true```

To use it copy orientdb-jdbc-*-SNAPSHOT-all.jar to your classpath. This is the easiest way to use OrientDB JDBC driver in tools like [DBVisualizer](http://www.dbvis.com/).
