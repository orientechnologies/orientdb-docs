
# Javascript

OrientDB supports server-side scripting. All the [JVM languages](http://en.wikipedia.org/wiki/List_of_JVM_languages) are supported. By default [JavaScript](http://en.wikipedia.org/wiki/JavaScript) is installed.

Scripts can be executed on the client and on the server-side.  On the client-side, the user must have READ privilege against the <code>database.command</code> resource.  On the server-side, [the scripting interpreter](#enable-server-side-scripting) must be enabled.  It is disabled by default for security reasons.

In order to return the result of a variable, put the variable name as last statement. Example:

```js
var r = db.query('select from ouser');
for( var i = 0; i < r.length; ++ r ){
  print(r);
}
r
```

Will return the resultset.

## See also
- [SQL-batch](../sql/SQL-batch.md)

## Usage
### Via Java API

Executes a command like SQL but uses the class <code>OCommandScript</code> passing in the language to use. JavaScript is installed by default. Example:
```java
db.command( new OCommandScript("Javascript", "print('hello world')") ).execute();
```
## Via console

JavaScript code can be executed on the client-side, the console, or server-side:
- Use [<code>js</code>](../console/Console-Command-Js.md) to execute the script on the **client-side** running it in the console
- use [<code>jss</code>](../console/Console-Command-Jss.md) to execute the script on the **server-side**. This feature is disabled by default. To enable it look at [Enable Server side scripting](#enable-server-side-scripting).
 
Note: if you want to call a server-side Javascript function that was previously created in studio remember to add `commit()` after your insert or update operations. For example if you want to execute this function:

<pre><code>var g = orient.getGraph();
g.command('sql', 'insert into Person(name) values ("Luca")');
g.commit();</code></pre>

you can than use this command in console:
`select functionName()`

Since the semi-colon <code>;</code> character is used in both console and JavaScript languages to separate statements, how can we execute multiple commands on the console and with JavaScript?

The OrientDB console uses a reserved keyword <code>end</code> to switch from JavaScript mode to console mode.

Example:
```
orientdb> connect remote:localhost/demo admin admin; js; for( i = 0; i < 10; i++ ){ db.query('select from MapPoint') };end; exit
```

This line connects to the remote server and executes 10 queries on the console. The <code>end</code> command switches the mode back to the OrientDB console and then executes the console <code>exit</code> command.

Below is an example to display the results of a query on the server and on the client.
<ol>
  <li>connects to the remote server as <code>admin</code></li>
  <li>executes a query and assigns the result to the variable <code>r</code>, then displays it server-side and returns it to be displayed on the client side too</li>
  <li>exits the console</li>
</ol>

### Interactive mode

```
$ ./console.sh
OrientDB console v.1.5 www.orientechnologies.com
Type 'help' to display all the commands supported.

orientdb> connect remote:localhost/demo admin admin
Connecting to database [remote:localhost/demo] with user 'admin'...OK

orientdb> jss;var r = db.query('select from ouser');print(r);r

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

The same example above is executed in batch mode:
```java
$ ./console.sh "connect remote:localhost/demo admin admin;jss;var r = db.query('select from ouser');print(r);r;exit"
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
orientdb> js;for( i = 0; i < 1000; i++ ){ db.query( 'insert into jstest (label) values ("test'+i+'")' ); }
```

### Create documents using wrapped Java API

```
orientdb> js new com.orientechnologies.orient.core.record.impl.ODocument('Profile').field('name', 'Luca').save()

Client side script executed in 0,426000 sec(s). Value returned is: Profile#11:52{name:Luca} v3
```

## Enable Server-side scripting

For security reasons server-side scripting is disabled by default on the server. To enable it change the enable field to <code>true</code> in the **orientdb-server-config.xml** file under the [Server Side Script Interpreter Plugin](Script-Interpreter-Plugin.md) component and set "Javascript" between the supported languages:
```xml
<!-- SERVER SIDE SCRIPT INTERPRETER. WARNING! THIS CAN BE A SECURITY HOLE: ENABLE IT ONLY IF CLIENTS ARE TRUSTED, TO TURN ON SET THE 'ENABLED' PARAMETER TO 'true' -->
  <handler class="com.orientechnologies.orient.server.handler.OServerSideScriptInterpreter">
    <parameters>
      <parameter name="enabled" value="true" />
      <parameter name="allowedLanguages" value="SQL,Javascript" />
    </parameters>
  </handler>
```


For security reason starting from *OrientDB 3.0.29*, the usage of Java classes is forbidden by default, with a class filter implmented in the JS engine.
To enable the access to classes or packages in your JS code change the `allowedPackages` field with comma separated packages or classes.
This also applies to Javascript server side function.

```xml
<!-- SERVER SIDE SCRIPT INTERPRETER. WARNING! THIS CAN BE A SECURITY HOLE: ENABLE IT ONLY IF CLIENTS ARE TRUSTED, TO TURN ON SET THE 'ENABLED' PARAMETER TO 'true' -->
  <handler class="com.orientechnologies.orient.server.handler.OServerSideScriptInterpreter">
    <parameters>
      <parameter name="enabled" value="true" />
      <parameter name="allowedLanguages" value="SQL,Javascript" />
       <!--  Comma separated packages  allowed in JS scripts eg. java.math.*, java.util.ArrayList -->
      <parameter name="allowedPackages" value=""/>
    </parameters>
  </handler>
```


For more information look at [Server Side Script Interpreter Plugin](Script-Interpreter-Plugin.md).

*NOTE: this will allow clients to execute any code inside the server. Enable it only if clients are trusted.*
