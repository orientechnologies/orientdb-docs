# Mail Plugin

Java class implementation:
```java
com.orientechnologies.orient.server.plugin.mail.OMailPlugin
```
Available since: **v. 1.2.0**.

## Introduction

Allows to send (and in future read) emails.

## Configuration

This plugin is configured as a [Server handler](DB-Server.md#handlers). The plugin can be configured in easy way by changing parameters:

<table>
  <tr><th>Name</th><th>Description</th><th>Type</th><th>Example</th><th>Since</th></tr>
  <tr><td>enabled</td><td>true to turn on, false (default) is turned off</td><td>boolean</td><td>true</td><td>1.2.0</td></tr>
  <tr><td><code>profile.&lt;name&gt;.mail.smtp.host</code></td><td>The SMTP host name or ip-address</td><td>string</td><td>smtp.gmail.com</td><td>1.2.0</td></tr>
  <tr><td><code>profile.&lt;name&gt;.mail.smtp.port</code></td><td>The SMTP port</td><td>number</td><td>587</td><td>1.2.0</td></tr>
  <tr><td><code>profile.&lt;name&gt;.mail.smtp.auth</code></td><td>Authenticate in SMTP</td><td>boolean</td><td>true</td><td>1.2.0</td></tr>
  <tr><td><code>profile.&lt;name&gt;.mail.smtp.starttls.enable</code></td><td>Enable the starttls</td><td>boolean</td><td>true</td><td>1.2.0</td></tr>
  <tr><td><code>profile.&lt;name&gt;.mail.smtp.user</code></td><td>The SMTP username</td><td>string</td><td>yoda@starwars.com</td><td>1.2.0</td></tr>
  <tr><td><code>profile.&lt;name&gt;.mail.from</code></td><td>The source's email address</td><td>string</td><td>yoda@starwars.com</td><td>1.7</td></tr>
  <tr><td><code>profile.&lt;name&gt;.mail.smtp.password</code></td><td>The SMTP password</td><td>string</td><td>UseTh3F0rc3</td><td>1.2.0</td></tr>
  <tr><td><code>profile.&lt;name&gt;.mail.date.format</code></td><td>The date format to use, default is "yyyy-MM-dd HH:mm:ss"</td><td>string</td><td>yyyy-MM-dd HH:mm:ss</td><td>1.2.0</td></tr>
</table>

Default configuration in orientdb-server-config.xml. Example:
```xml
<!-- MAIL, TO TURN ON SET THE 'ENABLED' PARAMETER TO 'true' -->
<handler
class="com.orientechnologies.orient.server.plugin.mail.OMailPlugin">
  <parameters>
    <parameter name="enabled" value="true" />
    <!-- CREATE MULTIPLE PROFILES WITH profile.<name>... -->
    <parameter name="profile.default.mail.smtp.host" value="smtp.gmail.com"/>
    <parameter name="profile.default.mail.smtp.port" value="587" />
    <parameter name="profile.default.mail.smtp.auth" value="true" />
    <parameter name="profile.default.mail.smtp.starttls.enable" value="true" />
    <parameter name="profile.default.mail.from" value="test@gmail.com" />
    <parameter name="profile.default.mail.smtp.user" value="test@gmail.com" />
    <parameter name="profile.default.mail.smtp.password" value="mypassword" />
    <parameter name="profile.default.mail.date.format" value="yyyy-MM-dd HH:mm:ss" />
  </parameters>
</handler>
```

## Usage

The message is managed as a map of properties containing all the fields those are part of the message.

Supported message properties:
<table><tbody>
  <tr><th>Name</th><th>Description</th><th>Mandatory</th><th>Example</th><th>Since</th></tr>
  <tr><td>from</td><td>source email address</td><td>No</td><td>to : "first@mail.com", "second@mail.com"</td><td>1.7</td></tr>
  <tr><td>to</td><td>destination addresses separated by commas</td><td>Yes</td><td>to : "first@mail.com", "second@mail.com"</td><td>1.2.0</td></tr>
  <tr><td>cc</td><td>Carbon copy addresses separated by commas</td><td>No</td><td>cc: "first@mail.com", "second@mail.com"</td><td>1.2.0</td></tr>
  <tr><td>bcc</td><td>Blind Carbon Copy addresses separated by commas</td><td>No</td><td>bcc : "first@mail.com", "second@mail.com"</td><td>1.2.0</td></tr>
  <tr><td>subject</td><td>The subject of the message</td><td>No</td><td>subject : "This Email plugin rocks!"</td><td>1.2.0</td></tr>
  <tr><td>message</td><td>The message's content</td><td>Yes</td><td>message : "Hi, how are you mate?"</td><td>1.2.0</td></tr>
  <tr><td>date</td><td>The subject of the message. Pass a java.util.Date object or a string formatted following the rules specified in "mail.date.format" configuration parameter or "yyyy-MM-dd HH:mm:ss" is taken</td><td>No, if not specified current date is assumed</td><td>date : "2012-09-25 13:20:00"</td><td>1.2.0</td></tr>
  <tr><td>attachments</td><td>The files to attach</td><td>No</td><td></td><td>1.2.0</td></tr>
</tbody></table>

## From Server-Side Functions

The Email plugin install a new variable in the server-side function's context: "mail". "profile" attribute is the profile name in [configuration](#Configuration).

Example to send an email writing a function in JS:
```javascript
mail.send({
      profile : "default",
      to: "orientdb@ruletheworld.com",
      cc: "yoda@starwars.com",
      bcc: "darthvader@starwars.com",
      subject: "The EMail plugin works",
      message : "Sending email from OrientDB Server is so powerful to build real web applications!"
    });
```

On Nashorn (>= Java8) the mapping of JSON to Map is not implicit. Use this:

```javascript
mail.send( new java.util.HashMap{
      profile : "default",
      to: "orientdb@ruletheworld.com",
      cc: "yoda@starwars.com",
      bcc: "darthvader@starwars.com",
      subject: "The EMail plugin works",
      message : "Sending email from OrientDB Server is so powerful to build real web applications!"
  });
```

## From Java

```java
OMailPlugin plugin = OServerMain.server().getPlugin("mail");

Map<String, Object> message = new HashMap<String, Object>();
message.put("profile", "default");
message.put("to",      "orientdb@ruletheworld.com");
message.put("cc",      "yoda@starts.com,yoda-beach@starts.com");
message.put("bcc",     "darthvader@starwars.com");
message.put("subject", "The EMail plugin works");
message.put("message", "Sending email from OrientDB Server is so powerful to build real web applications!");

plugin.send(message);
```
