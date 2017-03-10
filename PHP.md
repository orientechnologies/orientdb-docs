---
search:
   keywords: ['PHP', 'API']
---

# PhpOrient

OrientDB supports a number of application programming interfaces, natively through the JVM and externally through the [Binary Protocol](Network-Binary-Protocol.md).  In the event that you need or would prefer to develop your application for OrientDB using PHP, you can do so through the official driver: [PhpOrient](https://github.com/orientechnologies/PhpOrient).

It requires OrientDB version 1.7.4 or later.  It also requires that your application use PHP version 5.4 or later, with the Socket extension enabled.


## Getting PhpOrient 

In order to use PhpOrient with your application, you first need to install it on your system.  There are two methods available to you in installing PhpOrient: registering PhpOrient as a dependency of your application or manually retrieving the source code and installing it separately on your system.  Both methods require PHP Composer.

### Dependency Registration

When working with an existing project or in cases where you already have PHP Composer installed, you can register PhpOrient as a dependency of your project.  To do so, run the following command from your project directory:

<pre>
$ <code class="lang-sh userinput">php composer.phar require "ostico/phporient:dev-master" \
      --update-no-dev</code>
</pre>

Running this command registers PhpOrient as a requirement of your project.  It also links the requirement to the GitHub repository for PhpOrient, so you can also install updates as they become available.


### Manual Installation

In cases where you would like to manually install PhpOrient, you can retrieve the source code from GitHub, then install it locally with dependencies through PHP Composer.

1. Using `git`, retrieve the source code from GitHub:

   <pre>
   $ <code class="lang-sh userinput">git clone https://github.com/Ostico/PhpOrient.git</code>
   </pre>

1. Retrieve and install PHP Composer:

   <pre>
   $ <code class="lang-sh userinput">cd PhpOrient</code>
   $ <code class="lang-sh userinput">php -r "readfile('https://getcomposer.org/installer');" | php</code>
   </pre>

1. Install dependencies:

   <pre>
   php composer.phar --no-dev install
   </pre>

PhpOrient is now installed and ready for use on your system.


### 32-bit Architecture

While PhpOrient supports both 32-bit and 64-bit architectures, there are some issues that you should keep in mind when deploying applications on 32-bit systems.  In order to support Java long integers and to prove better driver performance on these systems, you must install one of the following libraries:

- [BCMath Arbitrary Precision Mathematics](http://php.net/manual/en/book/bc.php)
- [GNU Multiple Precision](http://php.net/manual/en/book/gmp.php)

When your 32-bit application receives a Java long integer from OrientDB, values greater than 2^32 are lost as they exceed the maximum possible number that the system can store in thirty-two bits.  To get around this limitation, PhpOrient uses with either the BCMath or GMP libraries to always handle numbers as strings.


## Using PhpOrient

During installation, PHP Composer generates an autoload file that you can use in retrieving PhpOrient classes and functions to use with your application.  To implement these features, add the following lines to any file where you would like to have these features available:

```php
require "vendor/autoload.php;
use PhpOrient\PhpOrient;
```
