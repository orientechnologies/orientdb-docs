---
search:
   keywords: ['API', 'C#', 'NET']
---

# OrientDB-NET

OrientDB provides support for a network binary protocol, allowing you to manage servers through various API's and drivers.  In the event that you would like to develop an application in the C#/.NET framework and runtime with OrientDB, you can so through the OrientDB-NET.binary driver.

## Installation

In order to use OrientDB-NET, you need to install it on your system.  There are two methods available to you in doing this: you can install the latest build from NuGet or you can download the latest source code from GitHub and build it on your local system.

### Installing from NuGet

NuGet is a package manager available for C#/.NET environments.  It is accessible through both Visual Studio and a command-line interface on Windows, Mac OS X and on Linux through Mono.

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

In order to use OrientDB-NET in your C#.NET application, you need to use the `using` directive to import the relevant namespace.  For instance,

```cs
using Orient.Client;
```
