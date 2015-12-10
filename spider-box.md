<!-- proofread 2015-12-10 SAM -->

# spider-box

[spider-box](https://github.com/spider/spider-box) is not really a "plug-in", but more a quick way to set up an environment to play with OrientDB in a local VM. It requires a virtualization system like [Virtualbox](https://www.virtualbox.org/), [VMWare Fusion](https://www.vmware.com/de/products/fusion) or [Parallels](http://www.parallels.com/) and the provisioning software [Vagrant](https://www.vagrantup.com/). 

Once installed, you can very quickly start playing with the newest version of OrientDB Studio or the console. Or even start developing software with OrientDB as the database. 

spider-box is configured mainly to build a PHP development environment. But, since it is built on [Puphpet](https://puphpet.com/), you can easily change the configuration, so Python or even node.js is also installed. Ruby is installed automatically. 

If you have questions about changing configuration or using spider-box, please do ask in an issue in the spider-box repo. 

Have fun playing with OrientDB and spider-box!

Note: Neo4j and Gremlin Server are also installed, when you `vagrant up` spider-box.

 