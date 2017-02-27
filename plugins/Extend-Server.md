---
search:
   keywords: ['internals', 'server', 'plugin', 'extension']
---

# OrientDB Plugins

The OrientDB Server is a customizable platform to build powerful server component and applications.

Since the OrientDB server contains an integrated Web Server what about creating server side applications without the need to have a J2EE and Servlet container? By extending the server you can benefit of the best performance because you don't have many layers but the database and the application reside on the same JVM without the cost of the network and serialization of requests.

Furthermore you can package your application together with the OrientDB server to distribute just a ZIP file containing the entire Application, Web server and Database.

To customize the OrientDB server you have two powerful tools:
- [Handlers](#handlers-server-plugins)
- [Custom commands](#custom-commands)

To debug the server while you develop new feature follow [Debug the server](#debug-the-server).

# Handlers (Server Plugins)

**Handlers** are plug-ins and starts when OrientDB starts.

To create a new handler create the class and register it in the OrientDB server configuration.

## Create the Handler class

A Handler must implements the OServerPlugin interface or extends the OServerPluginAbstract abstract class.

Below an example of a handler that print every 5 seconds a message if the "log" parameters has been configured to be "true":
```java
package orientdb.test;

public class PrinterHandler extends OServerPluginAbstract {
  private boolean	log = false;

  @Override
  public void config(OServer oServer, OServerParameterConfiguration[] iParams) {
    for (OServerParameterConfiguration p : iParams) {
      if (p.name.equalsIgnoreCase("log"))
        log = true;
    }

    Orient.getTimer().schedule( new TimerTask() {
      @Override
      public void run() {
        if( log )
          System.out.println("It's the PrinterHandler!");
      }
    }, 5000, 5000);
  }

  @Override
  public String getName() {
    return "PrinterHandler";
  }
}
```

## Register the handler

Once created, register it to the server configuration in **orientdb-server-config.xml** file:

```xml
<orient-server>
  <handlers>
    <handler class="orientdb.test.PrinterHandler">
      <parameters>
        <parameter name="log" value="true"/>
      </parameters>
    </handler>
  </handlers>
  ...
```

Note that you can specify arbitrary parameters in form of name and value. Those parameters can be read by the **config()** method. In this example a parameter "log" is read. Look upon to the example of handler to know how to read parameters specified in configuration.

## Steps to register a function as a Plugin in OrientDB

In this case we'll create a plugin that only registers one function in OrientDB: __pow__ (returns the value of the first argument raised to the power of the second argument). We'll also support [Modular exponentiation](http://en.wikipedia.org/wiki/Modular_exponentiation).

The syntax will be `pow(<base>, <power> [, <mod>])`.

* you should have a directory structure like this
```bash
    .
    ├─ src
    |   └─ main
    |       ├─ assembly
    |       |   └─ assembly.xml 
    |       ├─ java
    |       |   └─ com
    |       |       └─ app
    |       |           └─ OPowPlugin.java
    |       └─ resources
    |           └─ plugin.json 
    |
    └─ pom.xml 
```


##### OPowPlugin.java
```java
package com.app;

import com.orientechnologies.common.log.OLogManager;
import com.orientechnologies.orient.core.command.OCommandContext;
import com.orientechnologies.orient.core.db.record.OIdentifiable;
import com.orientechnologies.orient.core.sql.OSQLEngine;
import com.orientechnologies.orient.core.sql.functions.OSQLFunctionAbstract;
import com.orientechnologies.orient.server.OServer;
import com.orientechnologies.orient.server.config.OServerParameterConfiguration;
import com.orientechnologies.orient.server.plugin.OServerPluginAbstract;
import java.util.ArrayList;
import java.util.List;

public class OPowPlugin extends OServerPluginAbstract {

    public OPowPlugin() {
    }

    @Override
    public String getName() {
        return "pow-plugin";
    }

    @Override
    public void startup() {
        super.startup();
        OSQLEngine.getInstance().registerFunction("pow", new OSQLFunctionAbstract("pow", 2, 3) {
            @Override
            public String getSyntax() {
                return "pow(<base>, <power> [, <mod>])";
            }

            @Override
            public Object execute(Object iThis, OIdentifiable iCurrentRecord, Object iCurrentResult, final Object[] iParams, OCommandContext iContext) {
                if (iParams[0] == null || iParams[1] == null) {
                    return null;
                }
                if (!(iParams[0] instanceof Number) || !(iParams[1] instanceof Number)) {
                    return null;
                }

                final long base = ((Number) iParams[0]).longValue();
                final long power = ((Number) iParams[1]).longValue();

                if (iParams.length == 3) { // modular exponentiation
                    if (iParams[2] == null) {
                        return null;
                    }
                    if (!(iParams[2] instanceof Number)) {
                        return null;
                    }

                    final long mod = ((Number) iParams[2]).longValue();
                    if (power < 0) {
                        OLogManager.instance().warn(this, "negative numbers as exponent are not supported");
                    }
                    return modPow(base, power, mod);
                }

                return power > 0 ? pow(base, power) : 1D / pow(base, -power);
            }
        });
        OLogManager.instance().info(this, "pow function registered");
    }

    private double pow(long base, long power) {
        double r = 1;
        List<Boolean> bits = bits(power);
        for (int i = bits.size() - 1; i >= 0; i--) {
            r *= r;
            if (bits.get(i)) {
                r *= base;
            }
        }

        return r;
    }

    private double modPow(long base, long power, long mod) {
        double r = 1;
        List<Boolean> bits = bits(power);
        for (int i = bits.size() - 1; i >= 0; i--) {
            r = (r * r) % mod;
            if (bits.get(i)) {
                r = (r * base) % mod;
            }
        }

        return r;
    }

    private List<Boolean> bits(long n) {
        List<Boolean> bits = new ArrayList();
        while (n > 0) {
            bits.add(n % 2 == 1);
            n /= 2;
        }

        return bits;
    }

    @Override
    public void config(OServer oServer, OServerParameterConfiguration[] iParams) {

    }

    @Override
    public void shutdown() {
        super.shutdown();
    }
}
```

#####  pom.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.app</groupId>
    <artifactId>pow-plugin</artifactId>
    <version>2.0.7</version>
    <packaging>jar</packaging>

    <name>pow-plugin</name>

    <properties>
        <orientdb.version>2.0.7</orientdb.version>
    </properties>

    <build>
        <plugins>
            <plugin>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>2.4</version>
                <configuration>
                    <descriptors>
                        <descriptor>src/main/assembly/assembly.xml</descriptor>
                    </descriptors>
                </configuration>
                <executions>
                    <execution>
                        <id>make-assembly</id>
                        <!-- this is used for inheritance merges -->
                        <phase>package</phase>
                        <!-- bind to the packaging phase -->
                        <goals>
                            <goal>single</goal>
                        </goals>
                        <configuration></configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.1</version>
                <configuration>
                </configuration>
            </plugin>
        </plugins>
    </build>
    
    <dependencies>
        <dependency>
            <groupId>com.orientechnologies</groupId>
            <artifactId>orientdb-core</artifactId>
            <version>${orientdb.version}</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>com.orientechnologies</groupId>
            <artifactId>orientdb-server</artifactId>
            <version>${orientdb.version}</version>
            <scope>compile</scope>
        </dependency>
    </dependencies>
</project>
```

##### assembly.xml
```xml
<assembly>
    <id>dist</id>
    <formats>
        <format>jar</format>
    </formats>
    <includeBaseDirectory>false</includeBaseDirectory>
    <dependencySets>
        <dependencySet>
            <outputDirectory/>
            <unpack>true</unpack>
            <includes>
                <include>${groupId}:${artifactId}</include>
            </includes>
        </dependencySet>
    </dependencySets>
</assembly>
```

##### plugin.json
```json
{
	"name" : "pow-plugin",
	"version" : "2.0.7",
	"javaClass": "com.app.OPowPlugin",
	"parameters" : {},
	"description" : "The Pow Plugin",
	"copyrights" : "No copyrights"
}
```


* Build the project and then:

```bash
cp target/pow-plugin-2.0.7-dist.jar $ORIENTDB_HOME/plugins/
```

You should see the following in OrientDB server log:
```bash
INFO  Installing dynamic plugin 'pow-plugin-2.0.7-dist.jar'... [OServerPluginManager]
INFO  pow function registered [OPowPlugin]
```

And now you can:
```bash
orientdb {db=Pow}> select pow(2,10)     

----+------+------
#   |@CLASS|pow   
----+------+------
0   |null  |1024.0
----+------+------

orientdb {db=Pow}> select pow(2,10,5)

----+------+----
#   |@CLASS|pow 
----+------+----
0   |null  |4.0 
----+------+----

```

This small project is available [here](https://www.dropbox.com/s/3o448vbyh5dwx38/pow-plugin.tar.gz?dl=0).

## Creating a distributed change manager

As more complete example let's create a distributed record manager by installing hooks to all the server's databases and push these changes to the remote client caches.

```java
public class DistributedRecordHook extends OServerHandlerAbstract implements ORecordHook {
  private boolean log = false;

  @Override
  public void config(OServer oServer, OServerParameterConfiguration[] iParams) {
    for (OServerParameterConfiguration p : iParams) {
      if (p.name.equalsIgnoreCase("log"))
        log = true;
    }
  }

  @Override
  public void onAfterClientRequest(final OClientConnection iConnection, final byte iRequestType) {
    if (iRequestType == OChannelBinaryProtocol.REQUEST_DB_OPEN)
      iConnection.database.registerHook(this);
    else if (iRequestType == OChannelBinaryProtocol.REQUEST_DB_CLOSE)
      iConnection.database.unregisterHook(this);
  }

  @Override
  public boolean onTrigger(TYPE iType, ORecord<?> iRecord) {
    try {
      if (log)
        System.out.println("Broadcasting record: " + iRecord + "...");

      OClientConnectionManager.instance().broadcastRecord2Clients((ORecordInternal<?>) iRecord, null);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return false;
  }

  @Override
  public String getName() {
    return "DistributedRecordHook";
  }
}
```

# Custom commands

Custom commands are useful when you want to add behavior or business logic at the server side.

A Server command is a class that implements the [OServerCommand](https://github.com/orientechnologies/orientdb/blob/2.2.x/server/src/main/java/com/orientechnologies/orient/server/network/protocol/http/command/OServerCommand.java) interface or extends one of the following abstract classes:
- [OServerCommandAuthenticatedDbAbstract](https://github.com/orientechnologies/orientdb/blob/2.2.x/server/src/main/java/com/orientechnologies/orient/server/network/protocol/http/command/OServerCommandAuthenticatedDbAbstract.java) if the command requires an authentication at the database
- [OServerCommandAuthenticatedServerAbstract](https://github.com/orientechnologies/orientdb/blob/2.2.x/server/src/main/java/com/orientechnologies/orient/server/network/protocol/http/command/OServerCommandAuthenticatedServerAbstract.java) if the command requires an authentication at the server

## The Hello World Web

To learn how to create a custom command, let's begin with a command that just returns "Hello world!".

OrientDB follows the convention that the command name is:

**<code>OServerCommand&lt;method&gt;&lt;name&gt;</code>**
Where:
- **method** is the HTTP method and can be: GET, POST, PUT, DELETE
- **name** is the command name

In our case the class name will be "OServerCommandGetHello". We want that the use must be authenticated against the database to execute it as any user.

Furthermore we'd like to receive via configuration if we must display the text in Italic or not, so for this purpose we'll declare a parameter named "italic" of type boolean (true or false).
```java
package org.example;

public class OServerCommandGetHello extends OServerCommandAuthenticatedDbAbstract {
  // DECLARE THE PARAMETERS
  private boolean italic = false;

  public OServerCommandGetHello(final OServerCommandConfiguration iConfiguration) {
    // PARSE PARAMETERS ON STARTUP
    for (OServerEntryConfiguration par : iConfiguration.parameters) {
      if (par.name.equals("italic")) {
        italic = Boolean.parseBoolean(par.value);
      }
    }
  }

  @Override
  public boolean execute(final OHttpRequest iRequest, OHttpResponse iResponse) throws Exception {
    // CHECK THE SYNTAX. 3 IS THE NUMBER OF MANDATORY PARAMETERS
    String[] urlParts = checkSyntax(iRequest.url, 3, "Syntax error: hello/<database>/<name>");

    // TELLS TO THE SERVER WHAT I'M DOING (IT'S FOR THE PROFILER)
    iRequest.data.commandInfo = "Salutation";
    iRequest.data.commandDetail = "This is just a test";

    // GET THE PARAMETERS
    String name = urlParts[2];

    // CREATE THE RESULT
    String result = "Hello " + name;
    if (italic) {
      result = "<i>" + result + "</i>";
    }

    // SEND BACK THE RESPONSE AS TEXT
    iResponse.send(OHttpUtils.STATUS_OK_CODE, "OK", null, OHttpUtils.CONTENT_TEXT_PLAIN, result);

    // RETURN ALWAYS FALSE, UNLESS YOU WANT TO EXECUTE COMMANDS IN CHAIN
    return false;
  }

  @Override
  public String[] getNames() {
    return new String[]{"GET|hello/* POST|hello/*"};
  }
}
```

Once created the command you need to register them through the **orientdb-server-config.xml** file. Put a new tag <code>&lt;command&gt;</code> under the tag <code>commands</code> of <code>&lt;listener&gt;</code> with attribute <code>protocol="http"</code>:
```java
  ...
  <listener protocol="http" port-range="2480-2490" ip-address="0.0.0.0">
    <commands>
      <command implementation="org.example.OServerCommandGetHello" pattern="GET|hello/*">
        <parameters>
          <entry name="italic" value="true"/>
        </parameters>
      </command>
    </commands>
  </listener>
```

Where:
- **implementation** is the full class name of the command
- **pattern** is how the command is called in the format: <code>&lt;HTTP-method&gt;|&lt;name&gt;</code>. In this case it's executed on HTTP GET with the URL: <code>/&lt;name&gt;</code>
- **parameters** specify parameters to pass to the command on startup
- **entry** is the parameter pair name/value

To test it open a browser at this address:
```java
http://localhost/hello/demo/Luca
```

You will see:
```java
Hello Luca
```

## Complete example

Below a more complex example taken by official distribution. It is the command that executes queries via HTTP. Note how to get a database instance to execute operation against the database:
```java
public class OServerCommandGetQuery extends OServerCommandAuthenticatedDbAbstract {
  private static final String[] NAMES = { "GET|query/*" };

  @Override
  public boolean execute(OHttpRequest iRequest, OHttpResponse iResponse) throws Exception {
    String[] urlParts = checkSyntax(
        iRequest.url,
        4,
        "Syntax error: query/<database>/sql/<query-text>[/<limit>][/<fetchPlan>].<br/>Limit is optional and is setted to 20 by default. Set expressely to 0 to have no limits.");

    int limit = urlParts.length > 4 ? Integer.parseInt(urlParts[4]) : 20;
    String fetchPlan = urlParts.length > 5 ? urlParts[5] : null;
    String text = urlParts[3];

    iRequest.data.commandInfo = "Query";
    iRequest.data.commandDetail = text;

    ODatabaseDocumentTx db = null;

    List<OIdentifiable> response;

    try {
      db = getProfiledDatabaseInstance(iRequest);
      response = (List<OIdentifiable>) db.command(new OSQLSynchQuery<OIdentifiable>(text, limit).setFetchPlan(fetchPlan)).execute();

    } finally {
      if (db != null) {
        db.close();
      }
    }

    iResponse.writeRecords(response, fetchPlan);
    return false;
  }

  @Override
  public String[] getNames() {
    return NAMES;
  }
}
```

# Include JARS in the classpath

If your extensions need additional libraries put the additional jar files under the **<code>/lib</code>** folder of the server installation.

# Debug the server

To debug your plugin you can start your server in debug mode. 

|Parameter|Value|
|----|----|
|Main class|`com.orientechnologies.orient.server.OServerMain`|
|JVM parameters|`-server -DORIENTDB_HOME=/opt/orientdb -Dorientdb.www.path=src/site -Djava.util.logging.config.file=${ORIENTDB_HOME}/config/orientdb-server-log.properties -Dorientdb.config.file=${ORIENTDB_HOME}/config/orientdb-server-config.xml`|

