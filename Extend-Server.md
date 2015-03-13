# OrientDB Plugins

The OrientDB Server is a customizable platform to build powerful server component and applications.

Since the OrientDB server contains an integrated Web Server what about creating server side applications without the need to have a J2EE and Servlet container? By extending the server you can benefit of the best performance because you don't have many layers but the database and the application reside on the same JVM without the cost of the network and serialization of requests.

Furthermore you can package your application together with the OrientDB server to distribute just a ZIP file containing the entire Application, Web server and Database.

To customize the OrientDB server you have two powerful tools:
- [Handlers](#Handlers)
- [Custom commands](#Custom_commands)

To debug the server while you develop new feature follow [Debug the server](DB-Server.md#debug_the_server).

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

Once created register it to the server configuration in **orientdb-server-config.xml** file:

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

A Server command is a class that implements the [OServerCommand](http://code.google.com/p/orient/source/browse/trunk/server/src/main/java/com/orientechnologies/orient/server/network/protocol/http/command/OServerCommand.java) interface or extends one of the following abstract classes:
- [OServerCommandAuthenticatedDbAbstract](http://code.google.com/p/orient/source/browse/trunk/server/src/main/java/com/orientechnologies/orient/server/network/protocol/http/command/OServerCommandAuthenticatedDbAbstract.java) if the command requires an authentication at the database
- [OServerCommandAuthenticatedServerAbstract](http://code.google.com/p/orient/source/browse/trunk/server/src/main/java/com/orientechnologies/orient/server/network/protocol/http/command/OServerCommandAuthenticatedServerAbstract.java) if the command requires an authentication at the server

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

