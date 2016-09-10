# The Team

If you want to contribute to the project, follow the [Contributor rules](https://github.com/orientechnologies/orientdb/wiki/Contribute-to-OrientDB).

# Committers

Committers have reached the <a href="http://orientechnologies.com/certification.htm"><b>Joda Level</b> OrientDB certification</a>. They coordinates updates, patches, new tasks and answer actively to the [Google Group](http://groups.google.com/group/orient-database). They talk in a private Mailing List to take decision all together. All the committers refer to the Committer's guide.

## Luca Garulli
<img src="http://www.orientechnologies.com/wp-content/uploads/2014/06/LucaGarulli-small.jpg" width="150" align="right" style="padding: 0 0 20px 20px;" />
**Description** Luca is the original author of OrientDB product and the main committer. In order to handle indexes in efficient way Luca has created the new MVRB-Tree algorithm (it was called RB+Tree but another different algorithm already exists with this name) as mix of Red-Black Tree and B+Tree. MVRB stands for Multi Value Red Black because stores multiple values in each tree node instead of just one as RB-Tree does. MVRB-Tree consumes less than half memory of the RB-Tree implementation mantaining the original speed while it balances the tree on insertion/update. Furthermore the MVRB-Tree allows fast retrieving and storing of nodes in persistent way. He is member of the Sun Microsystems [JDO 1.0 Expert Group (JSR#12)](http://www.jcp.org/en/jsr/detail?id=12) and JDO 2.0 Expert Group (JSR#243) for the writing of JDO standard.<br/>
**Company** [OrientDB Ltd](http://orientdb.com)<br/>
**Links** [Twitter](http://twitter.com/lgarulli) - [Google+](https://plus.google.com/u/0/111607061083712272202/posts) - [VisualizeMe](http://vizualize.me/luca.garulli) - [LinkedIn](http://www.linkedin.com/in/garulli) - [Blog](http://zion-city.blogspot.it) - [Ohloh](http://www.ohloh.net/accounts/lvca)<br/>
**Since** 2009

## Artem Orobets
<img src="http://www.orientdb.org/team/ArtemOrobets.png" width="150" align="right" style="padding: 0 0 10px 10px;" />
**Description** Committer since 2012 and contributor since 2011. He started diving into indexes, composite indexes and many other was introduced.<br/> He have deep knowledge about the MVRB-Tree algorithm, the optimization of the indexes on queries, Transactions and Binary storage.<br/>
**Links** [Twitter](https://twitter.com/#!/Dr_EniSh) [LinkedIn](http://ua.linkedin.com/in/artemorobets)<br/>
**Since** 2012

## Andrey Lomakin
<img src="http://www.orientdb.org/team/AndreyLomakin.png" width="150" align="right" style="padding: 0 0 10px 10px;" />
**Description** Committer since 2012 and contributor since 2011. He started diving into indexes, composite indexes and many other was introduced.<br/>
He is:

1. Author of disk based storage system in OrientDB (plocal) which provides such features as durability and thread safety. Durability is achieved using write-ahead logging approach.
2. Author of "direct memory" disk cache (it is replacement of MMAP which is used underneath of all plocal components) which is based on 2Q and WOW cache algorithms.
3. Author of index system. Both hash and sbtree indexes.
4. Co-author (together with Artem Orobets) modern implementation of graph relationships.
<br/>
**Company** [OrientDB Ltd](http://orientdb.com)<br/>
**Links** [Twitter](https://twitter.com/#!/Andrey_Lomakin) [LinkedIn](http://ua.linkedin.com/in/andreylomakin)<br/>
**Since** 2012

## Luigi Dell'Aquila
<img src="http://orientdb.com/wp-content/uploads/2015/07/LuigiDellAquila.png" width="150" align="right" style="padding: 0 0 20px 20px;" />
**Description** 10 years experience as an ICT consultant, passionate software developer and Open Source enthusiast. Luigi managed OrientDB Academy since 2013, and since 2014 he manages Orient Technologies consulting services. He is also one of the main OrientDB core committers, mainly focused on OrientSQL, query execution and optimization.<br/>
**Company** [OrientDB Ltd](http://orientdb.com)<br/>
**Links** [Twitter](http://twitter.com/ldellaquila) - [LinkedIn](https://it.linkedin.com/in/luigidellaquila) <br/>
**Since** 2013


## Luca Molino</h1>
<img src="http://www.orientdb.org/team/LucaMolino.jpg" width="150" align="right" style="padding: 0 0 10px 10px;" />
**Description** Contributor since 2010 and committer since 2012 Luca is author of various Http commands and the network protocol multipart management; author of the v1.0 ObjectDatabase implementation; author of the centralized Fetching strategy; author of the FIND REFERENCES SQL command; author of the ttl bash orient console; worked on SQL commands, Storage creation\deleting and more.<br/>
**Company** [Asset Data](http://www.assetdata.it)<br/>
**Links** [Twitter](http://twitter.com/MaDaPHaKa) [GitHub](http://github.com/MaDaPHaKa)<br/>
**Since** 2012

<br/>
<br/>
# Contributors

Contributors are all the people that contribute in any way to the OrientDB development as code, tests, documentation or other. They talk in a private Mailing List with all the other committers and contributors and are updated on changes in internal stuff like binary protocol. One time patch doesn't make you a contributor, but if you're developing a driver or you sent more patches then you are a candidate to figure in this list.

Contributors (in alphabetic order):

## Anton Terekhov
<img src="http://www.orientdb.org/team/AntonTerekhov.jpg" width="150" align="right" style="padding: 0 0 10px 10px;" />
**Description** Web developer since 2001, PHP developer since 2002. Developer and maintainer of OrientDB-PHP driver for binary protocol (https://github.com/AntonTerekhov/OrientDB-PHP), bug hunter, binary protocol tester :-) .  Speaker on two Russian IT-conferences. Founder, CEO and Lead Developer of own company. Now specialized at high load, distributed web systems.<br/>
**Company** [NetMonsters](http://netmonsters.ru)<br/>
**Links** [Facebook](http://www.facebook.com/anton.terekhov)<br/>
**Since** 2011

## Artyom Loginov
**Description** Artem took part in MMAP file improvement<br/>
**Since** 2011

## Dino Ciuffetti
**Description** Dino is responsable of the Cloud infrastructure of <a href="http://www.nuvolabase.com">NuvolaBase</a>, providing OrientDB databases as service. He develop in PHP but his main skill is System Administrator and hacking on Linux platforms.<br/>
**Since** 2012

## Federico Fissore
<img src="http://www.gravatar.com/avatar/c8708e63ab90fd1628c403b3f286898d.png" width="150" align="right" style="padding: 0 0 10px 10px;" />
**Description** Federico references to himself in the third person and develops the node.js driver, which powers its baby creature, http://presentz.org<br/>
**Links** [GitHub](https://github.com/ffissore) [Twitter](https://twitter.com/fridrik) [LinkedIn](https://www.linkedin.com/in/fissore) [Google+](https://plus.google.com/114091868176609494289)<br/>
**Since**

## Gabriel Petrovay
<img src="http://www.gravatar.com/avatar/e7ba5e4295a1e23b7e91caf6c13eb79d.png" width="150" align="right" style="padding: 0 0 10px 10px;" />
**Description** Gabriel has been started the node.js OrientDB driver that implements the binary protocol. This helped discovering some problems in the binary protocol. Also helped a little with the corresponding documentation pages.<br/>
**Links** [Twitter](http://twitter.com/gabipetrovay) [LinkedIn](http://ch.linkedin.com/in/gabrielpetrovay)<br/>
**Since** 2012

## Johann Sorel
**Description** Java Developer specialized in Geographic Information Systems (GIS). Core developer on Geotoolkit project (http://www.geotoolkit.org) and related projects : GeoAPI, Mapfaces, Constellation, MDWeb, Puzzle-GIS. Member at the Open Geospatial Consortium (OGC) for elaboration of geographic specifications. Contributions on OrientDB are related to modularisation and performances.<br/>
**Company** [Geomatys](http://www.geomatys.com)<br/>
**Links** [Web Site](http://jsorel.developpez.com) [Ohloh](http://www.ohloh.net/accounts/Eclesia)<br/>
**Since** 2013, contributors since 2012

## Rus V. Brushkoff
<img src="http://www.gravatar.com/avatar/07b63445ef623d719d2ae41196b6fd22.png" width="150" align="right" style="padding: 0 0 10px 10px;" />
**Description** Contributed C++ binding (https://github.com/Sfinx/orientpp)<br/>
**Company** [SfinxSoft](http://sfinxsoft.com/)<br/>
**Links** [LinkedIn](http://ua.linkedin.com/in/sfinx)<br/>
**Since** 2012

## Tomas Bosak
**Description** Tomas is developing and maintaining [C# binary protocol driver for OrientDB](https://github.com/yojimbo87/OrientDB-NET.binary).<br/>
**Company** [ONXPO](http://www.onxpo.com/)<br/>
**Links** [Home Page](http://yojimbo87.github.com/) [GitHub](https://github.com/yojimbo87) [Twitter](https://twitter.com/yojimbo87) [LinkedIn](http://www.linkedin.com/in/tomasbosak)<br/>
**Since** 2012
