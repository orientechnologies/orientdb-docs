# OrientDB-NET

OrientDB provides support for a network binary protocol, allowing you to manage servers through various API's and drviers.  In the event that you would like to develop an application in the C#/.NET framework and runtime with OrientDB, you can so through the OrientDB-NET.binary driver.

## Installation

In order to use OrientDB-NET, you need to install it on your system.  THere are two methods available to you in doing this: you can install the latest build from NuGet or you can download the latest source code from GitHub and build it on your local system.

### Installing from NuGet

There are two packages available for OrientDB-NET.

- [**OrientDB-NET.binary**](https://www.nuget.org/packages/OrientDB-NET.binary) which provides the client interface with OrientDB.
- [**OrientDB-Net.binary.Innov8tive**](https://www.nuget.org/packages/OrientDB-Net.binary.Innov8tive) which provides the API for operating on the database.

Depending on your setup and preferences, you can install these packages either through the package management console in Visual Studio, or through NuGet command-line interface.

- With the package management console, run the following commands:

  <pre>
  PM> <code class="lang-powershell userinput">Install-Package OrientDB-NET.binary</code>
  PM> <code class="lang-powershell userinput">Install-Package OrientDB-Net.binary.Innov8tive</code>
  </pre>

- With the NuGet CLI application, run the following commands:

  <pre>
  $ <code class="lang-sh userinput">nuget install OrientDB-NET.binary</code>
  $ <code class="lang-sh userinput">nuget install OrientDB-Net-Innov8tive</code>
  </pre>

#### SendFailure Errors

While most C#/.NET applications run on Windows Server machines, it is now also possible to use these applications on Linux operating systems through Mono.  When using `nuget` on Linux for the first time, you may encounter errors whenever it attempts to connect to the software repositories.  For instance,

<pre>
$ <code class="lang-sh userinput">nuget install OrientDB-Net.binary</code>
WARNING: SendFailure (Error writing headers)
WARNING: An error occured while loading packages from 
'https://www.nuget.org/api/v2': Error SendFailure
(Error writing headers)
Unable to find package 'OrientDB-NET.binary'
</pre>

These errors occur in new installations or in cases where NuGet cannot locate the certificates it requires to securely download packages from Microsoft and the NuGet repositories.  You can download these using the Mono Certificate Manager:

<pre>
# <code class="lang-sh userinput">certmgr -ssl -m https://go.microsoft.com</code>
# <code class="lang-sh userinput">certmgr -ssl -m https://nugetgallery.blob.core.windows.net</code>
# <code class="lang-sh userinput">certmgr -ssl -m https://nuget.org</code>
</pre>

You can now install packages through NuGet.



### Building from Source

In the event that you would like to contribute to the [OrientDB-NET](https://github.com/orientechnologies/OrientDB-NET.binary) project or for whatever reason you would prefer to work with a development release of OrientDB-NET, you can clone the repository from GitHub and install on your system.

<pre>
$ <code class="lang-sh userinput">git clone https://github.com/orientechnologies/OrientDB-NET.binary</code>
</pre>

[TBD]

#### Running Unit Tests

[TBD]

## Using OrientDB-NET

In order to use OrientDB-NET in your C#.NET application, you need to use the `using` directive to import the relevant namespaces.  For instance,

```cs
using Orient.Client;
using OrientDB_NET.binary.Innov8tive;
```
