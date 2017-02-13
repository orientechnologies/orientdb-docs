---
search:
   keywords: ['API', 'Application Programming Interface', 'Programming Language Bindings']
---

# API

OrientDB supports 3 kinds of drivers:
- **Native binary remote**, that talks directly against the TCP/IP socket using the [binary protocol](https://github.com/nuvolabase/orientdb/wiki/Network-Binary-Protocol)
- **HTTP REST/JSON**, that talks directly against the TCP/IP socket using the [HTTP protocol](https://github.com/nuvolabase/orientdb/wiki/OrientDB-REST)
- **Java wrapped**, as a layer that links in some way the native Java driver. This is pretty easy for languages that run into the JVM like Scala, Groovy and JRuby

Look also at the available integration with [Plugins and Frameworks](Plugins.md).

This is the list of the known drivers to use OrientDB through different languages:

<table>
<tr>
    <th>Language</th>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
</tr>
<tr>
    <td rowspan="3">
      <center><a href="https://en.wikipedia.org/wiki/Java_%28programming_language%29"><img src="http://orientdb.com/wp-content/uploads/2016/09/java.jpeg" alt="JAVA" height="50px"/></a></center>
    </td>
    <td><a href="Java-API.html">Java&nbsp;(native)&nbsp;API</a></td>
    <td>Native</td>
    <td>Native implementation.</td>
</tr>
<tr>
    <td><a href="JDBC-Home.html">JDBC driver</a></td>
    <td>Native</td>
    <td>For legacy and reporting/Business Intelligence applications and <a href="https://github.com/kirpi4ik/orientdb-jca">JCA&nbsp;integration</a> for J2EE containers</td>
</tr>
<tr>
    <td><a href="https://github.com/orientechnologies/spring-data-orientdb">OrientDB Spring Data</a></td>
    <td>Native</td>
    <td>Official <a href="http://projects.spring.io/spring-data/">Spring Data Plugin</a> for both Graph and Document APIs</td>
</tr>

<tr>
    <td rowspan="3">
        <center><a href="http://nodejs.org"><img src="http://nodejs.org/images/logos/nodejs.png" alt="NodeJs" height="50px"/></a></center>
    </td>
    <td><a href="https://github.com/orientechnologies/orientjs">OrientJS</a></td>
    <td>Native</td>
    <td>Binary protocol, new branch that has been updated with the latest functionality. Tested on 1.7.0, 2.0.x and 2.1-rc*.</td>
</tr><tr>
    <td><a href="https://github.com/Havelaer/node-orientdb-http">node-orientdb-http</a></td>
    <td>HTTP</td>
    <td>RESTful HTTP protocol. Tested on 1.6.1</td>
</tr>
<tr>
    <td><a href="https://github.com/entrendipity/gremlin-node">Gremlin-Node</a></td>
    <td></td>
    <td>To execute Gremlin queries against a remote OrientDB server</td>
</tr>

<tr>
    <td rowspan="3">
        <center><a href="http://www.php.net/"><img src="http://static.php.net/www.php.net/images/php.gif" alt="PHP" height="50px"/></a></center>
    </td>
    <td><a href="https://github.com/orientechnologies/PhpOrient">PhpOrient</a></td>
    <td>Binary</td>
    <td><b>Official Driver</b></td>
</tr>
<tr>
    <td><a href="https://github.com/AntonTerekhov/OrientDB-PHP">OrientDB-PHP</a></td>
    <td>Binary</td>
    <td>This was the first PHP driver for OrientDB, but doesn't support all OrientDB features and it's slow to support new versions of driver protocol.</td>
</tr>
<tr>
    <td><a href="https://github.com/doctrine/orientdb-odm">Doctrine ODM</a></td>
    <td>Uses <a href="https://github.com/AntonTerekhov/OrientDB-PHP">OrientDB-PHP</a></td>
    <td>High level framework to use OrientDB from PHP</td>
</tr>

<tr>
    <td>
        <center><a href="http://www.microsoft.com"><img src="http://i.microsoft.com/net/images/chrome/net_logo.jpg" alt=".Net" height="50px"/></a></center>
    </td>
    <td><a href="https://github.com/orientechnologies/OrientDB-NET.binary">.NET driver for OrientDB</a></td>
    <td>Binary</td>
    <td><b>Official Driver</b></td>
</tr>

<tr>
    <td rowspan="3">
        <center><a href="http://www.python.org"><img src="http://www.python.org/images/python-logo.gif" alt="Python" height="35px"/></a></center>
    </td>
    <td><a href="https://github.com/orientechnologies/pyorient">PyOrient</a></td>
    <td>Binary</td>
    <td>Community driver for Python, compatible with OrientDB 1.7 and further.</td>
</tr>
<tr>
    <td><a href="http://bulbflow.com">Bulbflow project</a></td>
    <td>HTTP</td>
    <td>Uses <a href="https://github.com/tinkerpop/rexster/wiki">Rexter</a> Graph HTTP Server to access to OrientDB database <br/> <a href="https://github.com/tinkerpop/rexster/wiki/Rexster-Configuration">Configure Rexster for OrientDB</a></td>
</tr>
<tr>
    <td><a href="https://github.com/emehrkay/Compass">Compass</a></td>
    <td>HTTP</td>
    <td></td>
</tr>

<tr>
    <td rowspan="1">
        <center><a href="https://golang.org/"><img src="http://orientdb.com/wp-content/uploads/2016/09/golang.png" alt="Go-Lang" height="50px"/></a></center>
    </td>
    <td><a href="https://github.com/istreamdata/orientgo">OrientGO</a></td>
    <td>Binary</td>
    <td>OrientGo is a Go client for the OrientDB database.</td>
</tr>

<tr>
    <td rowspan="2">
        <center><a href="https://en.wikipedia.org/wiki/C_%28programming_language%29"><img src="https://upload.wikimedia.org/wikipedia/commons/9/95/The_C_Programming_Language%2C_First_Edition_Cover_%282%29.svg" alt="C" height="50px"/></a></center>
    </td>
    <td><a href="http://github.com/tglman/orientdb-c">OrientDB-C</a></td>
    <td>Binary</td>
    <td>Binary protocol compatibles with C++ and other languages that supports C calls</td>
</tr>
<tr>
    <td><a href="https://github.com/dam2k/liborient">LibOrient</a></td>
    <td>Binary</td>
    <td>As another Binary protocol driver</td>
</tr>

<tr>
    <td rowspan="2">
        <center><a href="http://en.wikipedia.org/wiki/JavaScript"><img src="http://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Unofficial_JavaScript_logo_2.svg/150px-Unofficial_JavaScript_logo_2.svg.png" alt="JavaScript" height="50px"/></a></center>
    </td>
    <td><a href="https://github.com/orientechnologies/orientdb/wiki/Javascript-Driver">Javascript&nbsp;Driver</a></td>
    <td>HTTP</td>
    <td>This driver is the simpler way to use OrientDB from JS</td>
</tr>
<tr>
    <td><a href="https://github.com/orientechnologies/orientdb-js">Javascript Graph Driver</a></td>
    <td>HTTP</td>
    <td>This driver mimics the [Blueprints](https://github.com/orientechnologies/orientdb/wiki/Graph-Database-Tinkerpop) interface. Use this driver if you're working against graphs.</td>
</tr>

<tr>
    <td rowspan="4">
        <center><a href="http://www.ruby-lang.org"><img src="https://www.ruby-lang.org/images/header-ruby-logo.png" alt="Ruby" height="35px"/></a></center></td>
    </td>
    <td><a href="https://github.com/topofocus/active-orient">Active-Orient</a></td>
    <td>HTTP</td>
    <td>Use OrientDB to persistently store dynamic Ruby-Objects and use database queries to manage even very large datasets. The gem is  rails 5 compatible.</td>
</tr>
<tr>
    <td><a href="https://github.com/aemadrid/orientdb-jruby">OrientDB-JRuby</a></td>
    <td>Native</td>
    <td>Through Java driver</td>
</tr>
<tr>
    <td><a href="https://github.com/ryanfields/orient_db_client">OrientDB Client</a></td>
    <td>Binary</td>
    <td></td>
</tr>
<tr>
    <td><a href="https://github.com/veny/orientdb4r">OrientDB4R</a></td>
    <td>HTTP</td>
    <td></td>
</tr>

<tr>
    <td>
        <center><a href="http://www.groovy-lang.org/"><img src="https://upload.wikimedia.org/wikipedia/commons/3/36/Groovy-logo.svg" alt="Groovy" height="30px"/></a></center>
    </td>
    <td><a href="https://github.com/eugene-kamenev/orientdb-groovy">OrientDB Groovy</a></td>
    <td>Java wrapper</td>
    <td>This project contains Groovy AST Transformations trying to mimic grails-entity style. All useful information you can find in Spock tests dir. Document API and Graph API with gremlin are supported. Built with OrientDB 2.1.0 and Apache Groovy 2.4.4.</td>
</tr>

<tr>
    <td rowspan="3">
        <center><a href="https://en.wikipedia.org/wiki/Scala_%28programming_language%29"><img src="https://upload.wikimedia.org/wikipedia/en/8/85/Scala_logo.png" alt="Scala" height="30px"/></a></center>
    </td>
    <td>Any&nbsp;Java&nbsp;driver</td>
    <td>Native</td>
    <td>Scala runs on top of JVM and it's fully compatible with Java applications like OrientDB</td>
</tr>
<tr>
    <td><a href="http://www.orientechnologies.com/docs/last/orientdb.wiki/Scala-Language.html">Scala Page</a></td>
    <td>Native</td>
    <td>Offers suggestions and examples to use it without pains</td>
</tr>
<tr>
    <td><a href="https://github.com/eptx/OrientDBScala">Scala&nbsp;utilities&nbsp;and&nbsp;tests</a></td>
    <td>Native</td>
    <td>To help Scala developers using OrientDB</td>
</tr>


<tr>
    <td rowspan="1">
        <center><a href="https://www.r-project.org/"><img src="https://www.r-project.org/Rlogo.png" alt="R" height="50px"/></a></center>
    </td>
    <td><a href="https://github.com/retrography/OrientR">R driver</a></td>
    <td>HTTP</td>
    <td>R Bridge to execute queries against OrientDB Server</td>
</tr>

<tr>
    <td rowspan="1">
        <center><a href="http://elixir-lang.org/"><img src="http://elixir-lang.org/images/logo/logo.png" alt="Elixir" height="50px"/></a></center>
    </td>
    <td><a href="https://github.com/MyMedsAndMe/marco_polo">MarcoPolo Elixir driver</a></td>
    <td>Binary</td>
    <td>This driver allows Elixir application to interact with OrientDB. Elixir language leverages the Erlang VM, known for running low-latency, distributed and fault-tolerant systems, while also being successfully used in web development and the embedded software domain.</td>
</tr>

<tr>
    <td rowspan="2">
        <center><a href="http://clojure.org"><img src="http://orientdb.com/wp-content/uploads/2016/09/clojure.png" alt="Clojure" height="50px"/></a></center>
    </td>
    <td><a href="https://github.com/eduardoejp/clj-orient">Clojure binding</a></td>
    <td>Native</td>
    <td>Through Java driver</td>
</tr>
<tr>
    <td><a href="https://github.com/eduardoejp/clj-blueprints">Clojure binding of Blueprints API</a></td>
    <td></td>
    <td></td>
</tr>

<tr>
    <td rowspan="1">
        <center><a href="http://wuman.github.com/orientdb-android"><img src="https://github.com/wuman/orientdb-android/raw/master/doc/images/orientdb-android-logo.png" alt="Android" height="35px"/></a></center>
    </td>
    <td><a href="http://wuman.github.com/orientdb-android">OrientDB Android</a></td>
    <td>Porting</td>
    <td>OrientDB-Android is a port/fork of OrientDB for the Android platform by <a href="http://blog.wu-man.com/">David Wu</a> </td>
</tr>

<tr>
    <td rowspan="1">
        <center><a href="https://github.com/a8wright/plorient"><img src="http://www.webgranth.com/wp-content/uploads/2013/02/perl.jpg" alt="Android" height="50px"/></a></center>
    </td>
    <td><a href="https://github.com/a8wright/plorient">OrientDB Perl driver</a></td>
    <td>Binary</td>
    <td>PlOrient is a Perl binary interface for OrientDB</td>
</tr>

</table>


## Supported standards

This is the list of the library to use OrientDB by using such standard:

<a href="http://www.tinkerpop.com"><img src="http://www.tinkerpop.com/images/tinkerpop-splash.png" /></a>
### TinkerPop Blueprints
[TinkerPop Blueprints](https://github.com/tinkerpop/blueprints/wiki), the standard for Graph Databases. OrientDB is 100% compliant with the latest version.

All the trademarks are property of their legal owners.

