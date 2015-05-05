# Rexster

[Rexster](https://github.com/tinkerpop/rexster/wiki/) provides a RESTful shell to any Blueprints-complaint graph database. This HTTP web service provides: a set of standard low-level GET, POST, and DELETE methods, a flexible extension model which allows plug-in like development for external services (such as ad-hoc graph queries through Gremlin), and a browser-based interface called The Dog House.

A graph database hosted in the OrientDB can be configured in Rexster and then accessed using the standard RESTful interface powered by the Rexster web server.

## Installation

You can get the latest stable release of Rexster from its [Download Page](https://github.com/tinkerpop/rexster/downloads).  The latest stable release when this page was last updated was *2.5.0*.

Or you can build a snapshot by executing the following [Git](http://git-scm.com/) and [Maven](http://maven.apache.org/) commands:
```java
git clone https://github.com/tinkerpop/rexster.git
cd rexster
mvn clean install
```

Rexster is distributed as a zip file (also the building process creates a zip file) hence the installation consist of unzipping the archive in a directory of your choice. In the following sections, this directory is referred to as _$REXSTER_HOME_.

After unzipping the archive, you should copy *orient-client.jar* and *orient-enterprise.jar* in _$REXSTER_HOME/ext_.  Make sure you use the same version of OrientDB as those used by Rexster.  For example Rexster 2.5.0 uses OrientDB 1.7.6.

You can find more details about Rexster installation at the [Getting Started page](https://github.com/tinkerpop/rexster/wiki/Getting-Started).


## Configuration

Refer to Rexster's [Configuration page](https://github.com/tinkerpop/rexster/wiki/Rexster-Configuration) and [OrientDB specific configuration page](https://github.com/tinkerpop/rexster/wiki/Specific-Graph-Configurations#orientdb) for the latest details.

### Synopsis

The Rexster configuration file *rexster.xml* is used to configure parameters such as: TCP ports used by Rexster server modules to listen for incoming connections; character set supported by the Rexster REST requests and responses; connection parameters of graph instances.

In order to configure Rexster to connect to your OrientDB graph, locate the *rexster.xml* in the Rexster directory and add the following snippet of code:
```xml
<rexster>
  ...
  <graphs>
    ...
    <graph>
      <graph-enabled>true</graph-enabled>
      <graph-name>my-orient-graph</graph-name>
      <graph-type>orientgraph</graph-type>
      <graph-file>url-to-your-db</graph-file>
      <properties>
        <username>user</username>
        <password>pwd</password>
      </properties>
    </graph>
  ...
  </graphs>
</rexster>
```
In the configuration file, there could be a sample `graph` element for an OrientDB instance (`<graph-name>orientdbsample<graph-name>`): you might edit it according to your needs.

The `<graph-name>` element must be unique within the list of configured graphs and reports the name used to identify your graph.
The `<graph-enabled>` element states whether the graph should be loaded and managed by Rexster. Setting its contents to `false` will prevent that graph from loading to Rexster; setting explicitly to `true` the graph will be loaded.
The `<graph-type>` element reports the type of graph by using an identifier (`orientgraph` for an OrientDB Graph instance) or the full name of the class that implements the [GraphConfiguration interface](https://github.com/tinkerpop/rexster/blob/master/rexster-core/src/main/java/com/tinkerpop/rexster/config/GraphConfiguration.java)
([com.tinkerpop.rexster.OrientGraphConfiguration](https://github.com/orientechnologies/orientdb/blob/master/graphdb/src/main/java/com/tinkerpop/rexster/OrientGraphConfiguration.java) for an OrientDB Graph).

The `<graph-file>` element reports the URL to the OrientDB database Rexster is expected to connect to:
- `plocal:*path-to-db*`, if the graph can be accessed over the file system (e.g. `plocal:/tmp/graph/db`)
- `remote:*url-to-db*`, if the graph can be accessed over the network and/or if you want to enable multiple accesses to the graph (e.g. `remote:localhost/mydb`)
- `memory:*db-name*`, if the graph resides in memory only. Updates to this kind of graph are never persistent and when the OrientDB server ends the graph is lost

The `<username>` and `<password>` elements reports the credentials to access the graph (e.g. `admin` `admin`).


## Run

**Note: <font color="RED">only Rexster 0.5-SNAPSHOT and further releases work with OrientDB GraphEd</font>**<br/>
In this section we present a step-by-step guide to Rexster-ify an OrientDB graph.<br/>
We assume that:
- you created a Blueprints enabled graph called *orientGraph* using the class `com.tinkerpop.blueprints.pgm.impls.orientdb.OrientGraph`
- you inserted in the Rexster configuration file a `<graph>` element with the `<graph-name>` element set to `my-orient-graph` and the `graph-file` element set to `remote:orienthost/orientGraph` (if you do not remember how to do this, go back to the [Configuration](Rexster.md#configuration) section).
1. Be sure that the OrientDB server is running and you have properly configured the `<graph-file>` location and the access credentials of your graph.
1. Execute the startup script (_$REXSTER_HOME/bin/rexster.bat_ or _$REXSTER_HOME/bin/rexster.sh_)
1. The shell console appears and you should see the following log message (line 10 states that the OrientDB graph instance has been loaded):
```java
[INFO] WebServer - .:Welcome to Rexster:.
[INFO] GraphConfigurationContainer - Graph emptygraph - tinkergraph[vertices:0 edges:0] loaded
[INFO] RexsterApplicationGraph - Graph [tinkergraph] - configured with allowable namespace [tp:gremlin]
[INFO] GraphConfigurationContainer - Graph tinkergraph - tinkergraph[vertices:6 edges:6] loaded
[INFO] RexsterApplicationGraph - Graph [tinkergraph-readonly] - configured with allowable namespace [tp:gremlin]
[INFO] GraphConfigurationContainer - Graph tinkergraph-readonly - (readonly)tinkergraph[vertices:6 edges:6] loaded
[INFO] RexsterApplicationGraph - Graph [gratefulgraph] - configured with allowable namespace [tp:gremlin]
[INFO] GraphConfigurationContainer - Graph gratefulgraph - tinkergraph[vertices:809 edges:8049] loaded
[INFO] GraphConfigurationContainer - Graph sailgraph - sailgraph[memorystore] loaded
[INFO] GraphConfigurationContainer - Graph my-orient-graph - orientgraph[remote:orienthost/orientGraph] loaded
[INFO] GraphConfigurationContainer - Graph neo4jsample -  not enabled and not loaded.
[INFO] GraphConfigurationContainer - Graph dexsample -  not enabled and not loaded.
[INFO] MapResultObjectCache - Cache constructed with a maximum size of 1000
[INFO] WebServer - Web Server configured with com..sun..jersey..config..property..packages: com.tinkerpop.rexster
[INFO] WebServer - No servlet initialization parameters passed for configuration: admin-server-configuration
[INFO] WebServer - Rexster Server running on: [http://localhost:8182]
[INFO] WebServer - Dog House Server running on: [http://localhost:8183]
[INFO] ShutdownManager$ShutdownSocketListener - Bound shutdown socket to /127.0.0.1:8184. Starting listener thread for shutdown requests.
```
- Now you can use [Rexster REST API](https://github.com/tinkerpop/rexster/wiki/Basic-REST-API) and [The Dog House web application](https://github.com/tinkerpop/rexster/wiki/The-Dog-House) to retrieve and modify the data stored in the OrientDB graph.
