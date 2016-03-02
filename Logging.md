# Logging

OrientDB handles logs using the Java Logging Framework, which is bundled with the JVM.  The specific format it uses derives from the `OLogFormatter` class, which defaults to:

```
<date> <level> <message> [<requester>]
```

- **`<date>`** Shows the date of the log entry, using the date format `YYYY-MM-DD HH:MM:SS:SSS`.
- **`<level>`** Shows the log level.
- **`<message>`** Shows the log message.
- **`<class>`** Shows the Java class that made the entry, (optional).

The supported levels are those contained in the JRE class [`java.util.logging.Level`](http://java.sun.com/j2se/1.5.0/docs/api/java/util/logging/Level.html).  From highest to lowest:

- `SEVERE`
- `WARNING`
- `INFO`
- `CONFIG`
- `FINE`
- `FINER`
- `FINEST`

By default, OrientDB installs two loggers:
- **`console`**: Logs to the shell or command-prompt that starts the application or the server.  You can modify it by setting the `log.console.level` variable.
- **`file`**: Logs to the log file.  You can modify it by setting the `log.file.level` variable.


## Configuration File

You can configure logging strategies and policies by creating a configuration file that follows the 
Java [Logging Messages](http://www.javapractices.com/topic/TopicAction.do?Id=143) configuration syntax.  For example, consider the following from the `orientdb-server-log.properties` file:

```java
# Specify the handlers to create in the root logger
# (all loggers are children of the root logger)
# The following creates two handlers
handlers = java.util.logging.ConsoleHandler, java.util.logging.FileHandler

# Set the default logging level for the root logger
.level = ALL

# Set the default logging level for new ConsoleHandler instances
java.util.logging.ConsoleHandler.level = INFO
# Set the default formatter for new ConsoleHandler instances
java.util.logging.ConsoleHandler.formatter = com.orientechnologies.common.log.OLogFormatter

# Set the default logging level for new FileHandler instances
java.util.logging.FileHandler.level = INFO
# Naming style for the output file
java.util.logging.FileHandler.pattern=../log/orient-server.log
# Set the default formatter for new FileHandler instances
java.util.logging.FileHandler.formatter = com.orientechnologies.common.log.OLogFormatter
# Limiting size of output file in bytes:
java.util.logging.FileHandler.limit=10000000
# Number of output files to cycle through, by appending an
# integer to the base file name:
java.util.logging.FileHandler.count=10
```

When the log properties file is ready, you need to tell the JVM to use t, by setting `java.util.logging.config.file` system property.

<pre>
$ <code class="lang-sh userinput">java -Djava.util.logging.config.file=mylog.properties</code>
</pre>

## Setting the Log Level

To change the log level without modifying the logging configuration, set the `log.console.level` and `log.file.level` system variables.  These system variables are accessible both at startup and at runtime.

### Configuring Log Level at Startup

You can configure log level at startup through both the `orientdb-server-config.xml` configuration file and by modifying the JVM before you start the server:

#### Using the Configuration File

To configure log level from the configuration file, update the following elements in the `<properties>` section:
  
```xml
<properties>
   <entry value="info" name="log.console.level" />
   <entry value="fine" name="log.file.level" />
   ...
</properties>
```

#### Using the JVM

To configure log level from the JVM before starting the server, run the `java` command to configure the `log.console.level` and `log.file.level` variables:
  
<pre>
$ <code class="lang-sh userinput">java -Dlog.console.level=INFO -Dlog.file.level=FINE</code>
</pre>

### Configuring Log Level at Runtime

You can configure log level at runtime through both the Java API and by executing an HTTP `POST` against the remote server.

#### Using Java Code

Through the Java API, you can set the system variables for logging at startup through the `System.setProperty()` method.  For instance,

```java
public void main(String[] args){
  System.setProperty("log.console.level", "FINE");
  ...
}
```

#### Using HTTP POST

Through the HTTP requests, you can update the logging system variables by executing a `POST` against the URL: `/server/log.<type>/<level>`.

- **`<type>`** Defines the log type: `console` or `file`.
- **`<level>`** Defines the log level.

**Examples**

The examples below use [cURL](https://en.wikipedia.org/wiki/CURL) to execute the HTTP `POST` commands against the OrientDB server.  It uses the server `root` user and password.

- Enable the finest tracing level to the console:

  <pre>
  $ <code class="lang-sh userinput">curl -u root:root -X POST http://localhost:2480/server/log.console/FINEST</code>
  </pre>

- Enable the finest tracing level to file:

  <pre>
  $ <code class="lang-sh userinput">curl -u root:root -X POST http://localhost:2480/server/log.file/FINEST</code>
  </pre>



## Install Log Formatter

OrientDB Server uses its own log formatter.  In order to enable the same for your application, you need to include the following line:

```java
OLogManager.installCustomFormatter();
```

The Server automatically installs the log formatter.  To disable it, use `orientdb.installCustomFormatter`.

<pre>
$ <code class="lang-sh userinput">java -Dorientdb.installCustomFormatter=false</code>
</pre>
