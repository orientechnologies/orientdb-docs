# Graph Database Comparison

This is a comparison page between GraphDB projects. To know more about the comparison of DocumentDBs look at this [comparison](DocumentDB-Comparison.md).

We want to keep it always updated with the new products and more features in the matrix. If any information about any product is not updated or wrong, please change it if you've the permissions or send an email to any contributors with the link of the source of the right information.

# Feature matrix

| Feature | OrientDB | Neo4j   | DEX     | InfiniteGraph |
|---------|----------|---------|---------|---------------|
| Release | 1.0-SNAPSHOT | 1.7M03 | 4.5.1 | 2.1 |
| Product Web Site | http://www.orientdb.org | http://www.neo4j.org | http://www.sparsity-technologies.com | http://objectivity.com/INFINITEGRAPH |
|  License | [Open Source Apache 2](http://www.apache.org/licenses/LICENSE-2.0.html) | [Open Source GPL](http://www.gnu.org/licenses/gpl-3.0.html), [Open Source AGPL](http://www.gnu.org/licenses/agpl-3.0.html) and Commercial | Commercial | [Commercial](http://objectivity.com/support) |
|  Query languages | [Extended SQL](SQL.md), [Gremlin](https://github.com/tinkerpop/gremlin/wiki) | [Cypher](http://docs.neo4j.org/chunked/1.4/cypher-query-lang.html) [Gremlin](https://github.com/tinkerpop/gremlin/wiki) | Not available, only via API | [Gremlin](https://github.com/tinkerpop/gremlin/wiki), Java API |
|  Transaction support | ![](http://www.orientdb.org/images/ok.png)  [ACID](http://en.wikipedia.org/wiki/ACID) | ![](http://www.orientdb.org/images/ok.png)  [ACID](http://en.wikipedia.org/wiki/ACID) | ![](http://www.orientdb.org/images/no.png) | ![](http://www.orientdb.org/images/ok.png)  [ACID](http://en.wikipedia.org/wiki/ACID) |
|  Protocols | Embedded via Java API, remote as [Binary](Network-Binary-Protocol.md) and [REST](OrientDB-REST.md) | Embedded via Java API and remote via REST | ? | Embedded via Java API, Remote database access via TCP |
|  Replication | Multi-Master | Master-Slave | No | ![](http://www.orientdb.org/images/no.png) |
|  Custom types | ![](http://www.orientdb.org/images/ok.png) [Supports custom types and polymorphism](Graph-Schema.md) | ![](http://www.orientdb.org/images/no.png) | ![](http://www.orientdb.org/images/no.png) | ![](http://www.orientdb.org/images/ok.png) Supports custom types and polymorphism |
|  Self loops | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) |


# Blueprints support

The products below all support the [TinkerPop Blueprints API](https://github.com/tinkerpop/blueprints/wiki/) at different level of compliance. Below the supported ones. As you can see OrientDB is the most compliant implementation of [TinkerPop](http://www.tinkerpop.com) Blueprints!

| Feature | OrientDB | Neo4j | DEX | InfiniteGraph |
|---------|----------|---------|---------|---------------|
|   Release  |  1.0-SNAPSHOT  |  1.7M03 |  4.5.1  |  2.1  |
|  Product Web Site | http://www.orientdb.org | http://www.neo4j.org | http://www.sparsity-technologies.com | http://objectivity.com/INFINITEGRAPH |
|  Implementation details | [OrientDB impl](https://github.com/tinkerpop/blueprints/wiki/OrientDB-Implementation) | [Neo4j impl](https://github.com/tinkerpop/blueprints/wiki/Neo4j-Implementation) | [DEX impl](https://github.com/tinkerpop/blueprints/wiki/Dex-Implementation) | [InfiniteGraph impl](https://github.com/tinkerpop/blueprints/wiki/InfiniteGraph-Implementation) [Known limitations](http://wiki.infinitegraph.com/2.1/w/index.php?title=Understanding_InfiniteGraph_Blueprints_Capabilities_and_Limitations) |
|  allowsDuplicateEdges | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |
|  allowsSelfLoops | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |
|  isPersistent | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |
|  supportsVertexIteration | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |
|  supportsEdgeIteration | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |
|  supportsVertexIndex | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/no.png) | ? |
|  supportsEdgeIndex | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/no.png) | ? |
|  ignoresSuppliedIds | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |
|  supportsTransactions | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/no.png) | ? |
|  allowSerializableObjectProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/no.png) | ![](http://www.orientdb.org/images/no.png) | ? |
|  allowBooleanProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |
|  allowDoubleProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |
|  allowFloatProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |
|  allowIntegerProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |
|  allowPrimitiveArrayProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/no.png) | ? |
|  allowUniformListProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/no.png) | ? |
|  allowMixedListProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/no.png) | ![](http://www.orientdb.org/images/no.png) | ? |
|  allowLongProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/no.png) | ? |
|  allowMapProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/no.png) | ![](http://www.orientdb.org/images/no.png) | ? |
|  allowStringProperty | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ![](http://www.orientdb.org/images/ok.png) | ? |

# Micro benchmark

The table below reports the time to complete the [Blueprints Test Suite](https://github.com/tinkerpop/blueprints/wiki/Property-Graph-Model-Test-Suite). This is **not a benchmark between GraphDBs** and unfortunately doesn't exist a public benchmark shared by all the vendors :-(

So this table is just to give an idea about the performance of each implementation in every single module it supports. The support is based on the compliance level reported in the table [above](#Blueprints_support). For the test default settings were used. To run these tests on your own machine follow these [simple instructions](#Run_the_tests).

Lower means faster. In **bold** the fastest implementation for each module.

| Module|OrientDB | Neo4j | DEX | InfiniteGraph |
|---------|----------|---------|---------|---------------|
| Release | 1.4 | 1.9.M05 | 4.8.0 | 2.1 |
| Product Web Site | http://www.orientdb.org | http://www.neo4j.org | http://www.sparsity-technologies.com | http://objectivity.com/INFINITEGRAPH |
| VertexTestSuite | **1,524.06** | 1,595.27 | 4,488.28 | ? |
| EdgeTestSuite | **1,252.21** | 1,253.73 | 3,865.85 | ? |
| GraphTestSuite | **1,664.75** | 2,400.34 | 4,680.80 | ? |
| QueryTestSuite | 306.58 | **188.52** | 612.73 | ? |
| IndexableGraphTestSuite | 4,620.61 | 11,299.02 | **1070.75** | ? |
| IndexTestSuite | **2,072.23** | 5,239.92 | not supported | ? |
| TransactionalGraphTestSuite | **1,573.93** | 3,579.50 | not supported | ? |
| KeyIndexableGraphTestSuite | **571.42** | 845.84 | not supported | ? |
| GMLReaderTestSuite | 778.08 | **682.83** | not supported | ? |
| GraphMLReaderTestSuite | **814.38** | 864.70 | 2,316.79 | ? |
| GraphSONReaderTestSuite | **424.77** | 480.81 | 1223.24 | ? |

*All the tests are executed against the same HW/SW configuration: MacBook Pro (Retina) 2013 - 16 GB Ram - MacOSX 12.3.0 - SDD 7200rpm. Similar results executed on Linux CentOS.*

## Run the tests

To run the [Blueprints Test Suite](https://github.com/tinkerpop/blueprints/wiki/Property-Graph-Model-Test-Suite) you need java6+, Apache Maven and Git. Follow these simple steps:

1. <code>&gt; git clone git://github.com/tinkerpop/blueprints.git</code>
1. <code>&gt; mvn clean install</code>
