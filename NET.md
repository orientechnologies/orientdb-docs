# OrientDB-NET

OrientDB provides support for a network binary protocol, allowing you to manage servers through various API's and drviers.  In the event that you would like to develop an application in the C#.NET framework and runtime with OrientDB, you can so through the OrientDB-NET.binary driver.

## Installation

In order to use OrientDB-NET, you need to install it on your system.  THere are two methods available to you in doing this: you can install the latest build from NuGet or you can download the latest source code from GitHub and build it on your local system.

### Installing from NuGet

You can install OrientDB-NET through NuGet using either the command-line interface or the package management console in Visual Studio.

- From the package management

```powershell
PM> Install-Package OrientDB-NET.binary
```

### Building from Source

In the event that you would like to contribute to the [OrientDB-NET](https://github.com/orientechnologies/OrientDB-NET.binary) project or for whatever reason you would prefer to work with a development release of OrientDB-NET, you can clone the repository from GitHub and install on your system.

<pre>
$ <code class="lang-sh userinput">git clone https://github.com/orientechnologies/OrientDB-NET.binary</code>
</pre>

#### Running Unit Tests


## Using OrientDB-NET

In order to use OrientDB-NET in your C#.NET application, you need to use the `using` directive to import the relevant namespaces.  For instance,

```cs
using Orient.Client;
using OrientDB_NET.binary.Innov8tive.API;
```
