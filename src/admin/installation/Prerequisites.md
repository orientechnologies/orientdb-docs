# Prerequisites

Both [editions](../../misc/Editions.md) of OrientDB run on any operating system that implements the Java Virtual machine (JVM) from v 8 to v 11, specifically the JDK. Examples of these include:

- Linux, all distributions, including ARM (Raspberry Pi, etc.)
- Mac OS X
- Microsoft Windows

OrientDB requires [Java](http://www.java.com/en/download), version 8 to 11, of the JDK.

>**Note**: In OSGi containers, OrientDB uses a `ConcurrentLinkedHashMap` implementation provided by [concurrentlinkedhashmap](https://github.com/ben-manes/concurrentlinkedhashmap) to create the LRU based cache. This library actively uses the sun.misc package which is usually not exposed as a system package. To overcome this limitation you should add property `org.osgi.framework.system.packages.extra` with value `sun.misc` to your list of framework properties.
>
>It may be as simple as passing an argument to the VM starting the platform: 
>
>```sh
>$ java -Dorg.osgi.framework.system.packages.extra=sun.misc
>```
