---
search:
   keywords: ['plugins', 'API']
---

# Plugins

If you're looking for drivers or JDBC connector go to  [Programming-Language-Bindings](Programming-Language-Bindings.md).

------

<a href="http://www.springsource.org"><img width="100" align="left" src="http://www.springsource.org/files/imagefield_default_images/placeholder_video_spring_projects.png" /></a>
<br>
&nbsp;
<br>

- [OrientDB Spring Data](https://github.com/orientechnologies/spring-data-orientdb) is the official <a href="http://projects.spring.io/spring-data/">Spring Data Plugin</a> for both Graph and Document APIs
- [spring-orientdb](https://github.com/megadix/orientdb-spring) is an attempt to provide a PlatformTransactionManager for OrientDB usable with the Spring Framework, in particular with @Transactional annotation. Apache 2 license
<br> 
- [Spring Session OrientDB](https://github.com/maseev/spring-session-orientdb) is a Spring Session extension for OrientDB.

------

<a href="http://www.playframework.org"><img width="100" align="left" src="https://www.playframework.com/assets/images/logos/play_full_color.png" /></a>
<br>
&nbsp;
<br>

- [Play Framework 2.1 PLAY-WITH-ORIENTDB plugin](https://github.com/ratcashdev/play-with-orientdb)
- [Play Framework 2.1 ORIGAMI plugin](https://github.com/sgougi/play21-origami-plugin)
- [Play Framework 1.x ORIENTDB plugin](http://www.playframework.org/modules/orientdb)
- [Frames-OrientDB Plugin Play Framework 2.x](https://github.com/sgougi/play21-frames-orientdb-plugin) Frames-OrientDB plugin is a Java O/G mapper for the OrientDB with the Play! framework 2. It is used with the TinkerPop Frames for O/G mapping.

------

<a href="https://github.com/faizod/orientdb-liquibase-plugin"><img src="https://raw.githubusercontent.com/liquibase/liquibase.github.com/master/custom_images/liquibase_logo.gif" width="300"></a>

------

<a href="https://github.com/PhantomYdn/wicket-orientdb"><img src="http://wicket.apache.org/img/logo-apachewicket-white.svg" width="300"></a><br>
 
With proper mark-up/logic separation, a POJO data model, and a refreshing lack of XML, Apache Wicket makes developing web-apps simple and enjoyable again. Swap the boilerplate, complex debugging and brittle code for powerful, reusable components written with plain Java and HTML.

------

Guice (pronounced 'juice') is a lightweight dependency injection framework for Java 6 and above, brought to you by Google.
[OrientDB Guice plugin](https://github.com/xvik/guice-persist-orient) allows to integrate OrientDB inside Guice. Features:
- Integration through guice-persist (UnitOfWork, PersistService, @Transactional, dynamic finders supported)
- Support for document, object and graph databases
- Database types support according to classpath (object and graph db support activated by adding jars to classpath)
- Auto mapping entities in package to db scheme or using classpath scanning to map annotated entities
- Auto db creation
- Hooks for schema migration and data initialization extensions
- All three database types may be used in single unit of work (but each type will use its own transaction)

------

<a href="http://vertx.io/"><img src="http://vertx.io/assets/logo-sm.png" width="200"></a>
<br>

Vert.x is a lightweight, high performance application platform for the JVM that's designed for modern mobile, web, and enterprise applications.
[Vert.x Persistor Module](https://github.com/aschrijver/mod-tinkerpop-persistor) for Tinkerpop-compatible Graph Databases like OrientDB.

------

<a href="https://gephi.org"><img width="100" align="left" src="http://gephi.github.io/images/logo.png" /></a><br>
 
[Gephi Visual tool](Gephi.md) usage with OrientDB and the [Blueprints importer](https://github.com/datablend/gephi-blueprints-plugin/wiki)

------
[OrientDB session store](https://github.com/ffissore/connect-orientdb) for Connect
------

<a href="http://forge.puppetlabs.com"/>
<br>
[Puppet module](https://github.com/example42/puppet-orientdb)

------

# [Chef](https://supermarket.chef.io/cookbooks/orientdb)

------

<a href="http://tomcat.apache.org"><img width="100" align="left" src="http://tomcat.apache.org/images/tomcat.gif" /></a>
<br>
[Apache Tomcat realm](http://wiki.apache.org/tomcat/OrientDBRealm) plugin by [Jonathan Tellier](mailto:jonathan.tellier@gmail.com)

------

<a href="http://shibboleth.net"><img width="100" align="left" src="http://shibboleth.net/images/shibboleth_logo.png" /></a><br>

[Shibboleth connector](https://wiki.shibboleth.net/confluence/display/SHIB2/OrientDB+Connector) by Jonathan Tellier. The [Shibboleth](http://shibboleth.net) System is a standards based, open source software package for web single sign-on across or within organizational boundaries. It allows sites to make informed authorization decisions for individual access of protected online resources in a privacy-preserving manner

------

<a href="http://media.xircles.codehaus.org"><img width="100" align="left" src="http://griffon-framework.org/img/griffon-icon-32x32.png" /></a><br>

[Griffon plugin](https://github.com/griffon/griffon-orientdb-plugin), Apache 2 license

------

**JCA connectors**
- [OPS4J Orient](http://team.ops4j.org/wiki/display/ORIENT/JCA+Resource+Adapter) provides a JCA resource adapter for integrating OrientDB with Java EE 6 servers
- [OrientDB JCA connector](https://github.com/kirpi4ik/orientdb-jca) to access to OrientDB database via JCA API + XA Transactions

------

[Pacer plugin](https://github.com/pdlug/pacer-orient) by Paul Dlug. [Pacer](https://github.com/pangloss/pacer) is a [JRuby](http://jruby.org/)  graph traversal framework built on the Tinkerpop stack. This plugin enables full OrientDB graph support in Pacer.

------

<a href="http://www.axonframework.org"><img width="100" align="left" src="http://www.axonframework.org/wp-content/uploads/AxonFramework_logoTxt.png" /></a><br>

[EventStore for Axonframework](http://www.axonframework.org/), which uses fully transactional (full ACID support) NoSQL database OrientDB. [Axon Framework](http://www.axonframework.org/) helps build scalable, extensible and maintainable applications by supporting developers apply the Command Query Responsibility Segregation (CQRS) architectural pattern

------

<a href="https://github.com/mproch/slick-orientdb#readme"><img width="100" align="left" src="http://slick.typesafe.com/resources/images/slick-logo.png"></a><br>

Accessing OrientDB using Slick

------

<a href="https://github.com/eiswind/jackrabbit-orient"><img width="100" align="left" src="http://jackrabbit.apache.org/jcr/images/logos/jlogo.gif" /></a><br>

Jackrabbit module to use OrientDB as backend.

------

<a href="https://github.com/sakuraiyuta/fuel-orientdb"><img width="100" align="left" src="http://fuelphp.com/addons/shared_addons/themes/fuel/img/logo.png" /></a><br>

&nbsp;&nbsp;Plugin for <a href="http://fuelphp.com">FuelPHP framework</a>.

------

<a href="https://github.com/raymanrt/orientqb">orientqb</a><br>

orientqb is a builder for OSQL query language written in Java. orientqb has been thought to help developers in writing complex queries dynamically and aims to be simple but powerful.

------
