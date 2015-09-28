# Logging

OrientDB uses the Java Logging framework bundled with the Java Virtual Machine. OrientDB's default log format (managed by `OLogFormatter` class) is:
```
<date> <level> <message> [<requester>]
```

Where:
- `<date>` is the log date in the following format: `yyyy-MM-dd HH:mm:ss:SSS`
- `<level>` is the logging level (see below for all the available levels) as 5 chars output
- `<message>` is the text of log, it can be any size
- `[<class>]` is the Java class that logged (optional)

Supported levels are those contained in the JRE class [java.util.logging.Level](http://java.sun.com/j2se/1.5.0/docs/api/java/util/logging/Level.html):
- SEVERE (highest value)
- WARNING
- INFO
- CONFIG
- FINE
- FINER
- FINEST (lowest value)

By default 2 loggers are installed:
- **console**, as the output of the shell/command prompt that starts the application/server. Can be changed by setting the variable <code>log.console.level</code>
- **file**, as the output to the log files. Can be changed by setting the <code>log.file.level</code>

## Configuration file

The logging strategies and policies can be configured using a file following the Java syntax: [Java Logging configuration](http://www.javapractices.com/topic/TopicAction.do?Id=143).

Example taken from **orientdb-server-log.properties**:
```
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

To tell to the JVM where the properties file is placed you need to set the *"java.util.logging.config.file"* system property to it. Example:

```
$ java -Djava.util.logging.config.file=mylog.properties ...
```

## Set the logging level

To change the logging level without modify the logging configuration just set the *"log.console.level"* and *"log.file.level"* system variables to the requested levels.

### At startup
#### In the server configuration

Open the file **orientdb-server-config.xml** and add or update these lines at the end of the file inside the <code>&lt;properties&gt;</code> section:
```xml
<entry value="fine" name="log.console.level" />
<entry value="fine" name="log.file.level" />
```

#### In server.sh (or .bat) script

Set the system property *"log.console.level"* and *"log.file.level"* to the levels you want using the -D parameter of java.

Example:
```
$ java -Dlog.console.level=FINE ...
```

### At run-time

#### By using Java code
The system variable can be setted at startup using the <code>System.setProperty()</code> API. Example:
```java
public void main(String[] args){
  System.setProperty("log.console.level", "FINE");
  ...
}
```

#### On remote server
Execute a HTTP POST against the URL: `/server/log.<type>/<level>`. Where:
- `<type>` can be "console" or "file"
- `<level>` is one of the supported levels (see above)

##### Examples
The examples below uses [cURL](https://en.wikipedia.org/wiki/CURL) to execute a HTTP POST command against OrientDB Server. Server's "root" user and password were used, replace with your own password.

Enable the finest tracing level to console:

    curl -u root:root -X POST http://localhost:2480/server/log.console/FINEST

Enable the finest tracing level to file:

    curl -u root:root -X POST http://localhost:2480/server/log.file/FINEST

## Install Log formatter

OrientDB Server uses own LogFormatter. To use the same by your application call:
```java
OLogManager.installCustomFormatter();
```

LogFormatter is installed automatically by Server. To disable it define the setting `orientdb.installCustomFormatter` to `false`. Example:

    java ... -Dorientdb.installCustomFormatter=false=false ...
