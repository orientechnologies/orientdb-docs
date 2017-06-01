---
search:
   keywords: ['API', 'C#', 'NET']
---

# OrientDB-NET

OrientDB provides driver support through a network binary protocol.  This allows you to manage servers through various API's and drivers.  You can access the database through a C#/.NET application using the OrientDB-NET.binary driver.

## New Alpha SDK

The OrientDB .NET SDK is currently being rewrittewn as a modular SDK. If you would like to check it out and help drive the direction of the new version, navigate to [OrientDB.Net.Core](https://github.com/orientechnologies/OrientDB.Net.Core).

## Installation

The OrientDB-NET driver is not included by default in your OrientDB installation.  In order to use it, you must install it separately on your system.

>For information on how to install OrientDB itself, see [Installing OrientDB](Tutorial-Installation.md).

### Installing from NuGet

NuGet is a package manager available for C#/.NET development environments.  It is accessible through Visual Studio and through the `nuget` command-line interface on Windows, macOS and on Linux through Mono.

The package name is [`OrientDB-Net.binary.Innov8tive`](https://www.nuget.org/packages/OrientDB-Net.binary.Innov8tive)

- Using the package management console in Visual Studio, run the following command:

  <pre>
  PM> <code class="lang-powershell userinput">Install-Package OrientDB-Net.binary.Innov8tive</code>
  </pre>

- Using the NuGet command-line application, run the following command from your project directory:

  <pre>
  $ <code class="lang-sh userinput">nuget install OrientDB-Net-Innov8tive</code>
  </pre>

#### SendFailure Errors

While most C#/.NET applications run on Microsoft Windows, it is now also possible to develop them to work with Linux and FreeBSD.

When using NuGet for the first time on these operating systems, you may encounter errors whenever it attempts to connect to the configured software repositories.  For instance,

<pre>
$ <code class="lang-sh userinput">nuget install OrientDB-Net.binary.Innov8tive</code>
WARNING: SendFailure (Error writing headers)
WARNING: An error occured while loading packages from 
'https://www.nuget.org/api/v2': Error SendFailure
(Error writing headers)
Unable to find package 'OrientDB-NET.binary'
</pre>

These errors occur in new installations of Mono or in similar cases where NuGet cannot locate the certificates it requires to securely download packages from Microsoft and the NuGet repositories.

You can download these certificates using the Mono Certificate Manager, through the following commands:

<pre>
# <code class="lang-sh userinput">certmgr -ssl -m https://go.microsoft.com</code>
# <code class="lang-sh userinput">certmgr -ssl -m https://nugetgallery.blob.core.windows.net</code>
# <code class="lang-sh userinput">certmgr -ssl -m https://nuget.org</code>
</pre>

You can now install packages through NuGet.


## Using OrientDB-NET

Once you have installed OrientDB and the OrientDB-NET.binary driver, you can begin to develop your C#/.NET application.  In order to utilize OrientDB-NET functions and classes, set the relevant namespace with the `using` directive. 

```cs
using Orient.Client;
```

- [**Server**](NET-Server.md) Documents the `OServer` interface, used when operating on the OrientDB Server to manage server-level configuration as well as creating, removing and listing databases on the server. 
- [**Database**](NET-Database.md) Documents the `ODatabase` interface, used when operating on particular OrientDB databases to manage clusters, operate on records and issue scripts, queries and commands.
- [**Queries**](NET-Query.md) Provides a guide to building queries.
- [**Transaction**](NET-Transactions.md) Documents the `OTransaction` interface, used when operating on OrientDB databases through transactions.




