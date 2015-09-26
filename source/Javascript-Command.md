# Javascript

Starting from version 1.0, OrientDB supports server side scripting. All the [JVM languages](http://en.wikipedia.org/wiki/List_of_JVM_languages) are supported. By default [JavaScript](http://en.wikipedia.org/wiki/JavaScript) is installed.

Scripts can be executed client and server side. For the client side the user must have the privilege of READ against <code>database.command</code> resource. For the server side the server must [enable the scripting interpreter](#Enable_Server_side_scripting) that are disabled by default for security reason.

## See also
- [SQL-batch](SQL-batch.md)

## Usage
### Via Java API

Execute a command like SQL but using the class <code>OCommandScript</code> passing the language to use. JavaScript is installed by default. Example:
```java
db.command( new OCommandScript("Javascript", "print('hello world')") ).execute();
```
## Via console

JavaScript code can be executed at client-side, the console, or server-side:
- Use <code>js</code> to execute the script at the **client-side** running it in the console
- use <code>jss</code> to execute the script at the **server-side**. This feature is disabled by default. To enable it look at [Enable Server side scripting](#Enable_Server_side_scripting).

Since the semicolon <code>;</code> character is used in both console and JavaScript language to separate statements, how can we execute multiple commands in the console and JavaScript?

OrientDB console uses a reserved keyword <code>end</code> to switch from the JavaScript mode to the console mode.

Example:
```
orientdb> connect remote:localhost/demo admin admin; js for( i = 0; i < 10; i++ ){ db.query('select from MapPoint') };end; exit
```

This line connects to the remote server and executes 10 queries on the console. The <code>end</code> command switches the mode back to the OrientDB console and then executes the console <code>exit</code> command.

Below an example to display the result of a query server and client side.
<ol>
  <li>connects to the remote server as <code>admin</code></li>
  <li>Execute a query and assign the result to the variable <code>r</code>, then display it server side and return it to be displayed client side too</li>
  <li>Exit the console</li>
</ol>

### Interactive mode

```
$ ./console.sh
OrientDB console v.1.5 www.orientechnologies.com
Type 'help' to display all the commands supported.

orientdb> connect remote:localhost/demo admin admin
Connecting to database [remote:localhost/demo] with user 'admin'...OK

orientdb> jss var r = db.query('select from ouser');print(r);r

---+---------+--------------------+--------------------+--------------------+--------------------
  #| RID     |name                |password            |status              |roles
---+---------+--------------------+--------------------+--------------------+--------------------
  0|     #4:0|admin               |{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918|ACTIVE              |[1]
  1|     #4:1|reader              |{SHA-256}3D0941964AA3EBDCB00CCEF58B1BB399F9F898465E9886D5AEC7F31090A0FB30|ACTIVE              |[1]
  2|     #4:2|writer              |{SHA-256}B93006774CBDD4B299389A03AC3D88C3A76B460D538795BC12718011A909FBA5|ACTIVE              |[1]
---+---------+--------------------+--------------------+--------------------+--------------------
Script executed in 0,073000 sec(s). Returned 3 records

orientdb> exit
```

### Batch mode

The same example above is execute in batch mode:
```java
$ ./console.sh "connect remote:localhost/demo admin admin;jss var r = db.query('select from ouser');print(r);r;exit"
OrientDB console v.1.0-SNAPSHOT (build 11761) www.orientechnologies.com
Type 'help' to display all the commands supported.
Connecting to database [remote:localhost/demo] with user 'admin'...OK

---+---------+--------------------+--------------------+--------------------+--------------------
  #| RID     |name                |password            |status              |roles
---+---------+--------------------+--------------------+--------------------+--------------------
  0|     #4:0|admin               |{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918|ACTIVE              |[1]
  1|     #4:1|reader              |{SHA-256}3D0941964AA3EBDCB00CCEF58B1BB399F9F898465E9886D5AEC7F31090A0FB30|ACTIVE              |[1]
  2|     #4:2|writer              |{SHA-256}B93006774CBDD4B299389A03AC3D88C3A76B460D538795BC12718011A909FBA5|ACTIVE              |[1]
---+---------+--------------------+--------------------+--------------------+--------------------
Script executed in 0,099000 sec(s). Returned 3 records
```

## Examples of usage

### Insert 1000 records

```xml
orientdb> js for( i = 0; i < 1000; i++ ){ db.query( 'insert into jstest (label) values ("test'+i+'")' ); }
```

### Create documents using wrapped Java API

```
orientdb> js new com.orientechnologies.orient.core.record.impl.ODocument('Profile').field('name', 'Luca').save()

Client side script executed in 0,426000 sec(s). Value returned is: Profile#11:52{name:Luca} v3
```

## Enable Server side scripting

For security reason server-side scripting is disabled by default on server. To enable it change the enable field to <code>true</code> in **orientdb-server-config.xml** file:
```xml
<!-- SERVER SIDE SCRIPT INTERPRETER. WARNING! THIS CAN BE A SECURITY HOLE: ENABLE IT ONLY IF CLIENTS ARE TRUSTED, TO TURN ON SET THE 'ENABLED' PARAMETER TO 'true' -->
  <handler class="com.orientechnologies.orient.server.handler.OServerSideScriptInterpreter">
    <parameters>
      <parameter name="enabled" value="true" />
    </parameters>
  </handler>
```

*NOTE: this will allow to clients to execute any code inside the server. Enable it only if clients are trusted.*
