# SSL

Beginning with version 1.7, OrientDB provides support for securing its HTTP and BINARY protocols through SSL.  For distributed SSL, see the HazelCast documentation.

For more information on securing OrientDB, see the following pages:
- [Database security](Database-Security.md)
- [Server security](Server-Security.md)
- [Database Encryption](Database-Encryption.md)


## Setting up the Key and Trust Stores

In order to set up and manage certificates, OrientDB uses the Java Keytool.  Using certificates signed by a Certificate Authority (CA) is beyond the scope of this tutorial.  For more information on using the Java Keytool, see the [Documentation](http://docs.oracle.com/javase/7/docs/technotes/tools/index.html#security).

To create key and trust stores that reference a self-signed certificate, use the following guide:

1. Using Keytool, create a certificate for the server:

   <pre>
   # <code class="lang-sh userinput">keytool -genkey -alias server -keystore orientdb.ks \
        -keyalg RSA -keysize 2048 -validity 3650</code>
   </pre>

1. Export the server certificate to share it with client:

   <pre>
   # <code class="lang-sh userinput">keytool -export -alias server -keystore orientdb.ks \
	      -file orientdb.cert</code>
   </pre>

1. Create a certificate/keystore for the console/clients:

   <pre>
   # <code class="lang-sh userinput">keytool -genkey -alias console -keystore orientdb-console.ks \
	      -keyalg RSA -keysize 2048 -validity 3650</code>
   </pre>

1. Create a trust-store for the client, then import the server certificate.  

   <pre>
   # <code class="lang-sql userinput">keytool -import -alias server -keystore orientdb-console.ts \
	      -file orientdb.cert</code>
   </pre>

   This establishes that the client trusts the server.

You now have a self-signed certificate to use with OrientDB.  Bear in mind that for each remote client JVM you want to connect to the server, you need to repeat steps three and four.  Remember to change the alias, keystore and trust-store filenames accordingly.


## Configuring OrientDB for SSL


### Server Configuration

The server configuration file, `$ORIENTDB_HOME/config/orientdb-server-config.xml`, does not use SSL by default.  To enable SSL on a protocol listener, you must change the `socket` attribute to the `<listener>` value from `default` to one of your configured `<socket>` definitions.

There are two default definitions available: `ssl` and `https`.  For most use cases this is sufficient, however you can define more if you want to secure different listeners with their own certificates or would like to use a custom factory implementations. When using the `ssl` implementation, bear in mind that the default port for OrientDB SSL is `2434`.  You need to change your port range to `2434-2440`.

By default, the OrientDB server looks for its keys and trust-stores in `$ORIENTDB_HOME/config/cert`.  You can configure it using the `<socket>` parameters.  Be sure that all the key and trust-stores created in the previous setup are in the correct directory and that the passwords used are correct.

>**NOTE**: Paths are relative to `$ORIENTDB_HOME`.  OrientDB also supports absolute paths.

```xml
<sockets>
  <socket implementation="com.orientechnologies.orient.server.network.OServerSSLSocketFactory" name="ssl">
    <parameters>
      <parameter value="false" name="network.ssl.clientAuth"/>
      <parameter value="config/cert/orientdb.ks" name="network.ssl.keyStore"/>
      <parameter value="password" name="network.ssl.keyStorePassword"/>
       <!-- NOTE: We are using the same store for keys and trust.
        	This will change if client authentication is enabled. See Configuring Client section -->

      <parameter value="config/cert/orientdb.ks" name="network.ssl.trustStore"/>
      <parameter value="password" name="network.ssl.trustStorePassword"/>
    </parameters>
  </socket>

  ...

  <listener protocol="binary" ip-address="0.0.0.0" port-range="2424-2430" socket="default"/>
  <listener protocol="binary" ip-address="0.0.0.0" port-range="2434-2440" socket="ssl"/>
```

### Console Configuration

For remote connections using the console, you need to make a few changes to to `console.sh`, enable SSL:

1. Confirm that your `KEYSTORE`, `TRUSTSTORE` and respective `PASSWORD` variables are correctly set.

1. In the `SSL_OPTS` definition, set `client.ssl.enabled` system property to `true`.

### Client Configuration

To configure remote clients, use the standard Java system property patterns:

- `client.ssl.enabled`: Use this to enable/disable SSL.  The property accepts `true` or `false`.  You only need to define this when using remote binary client connections.
- `javax.net.ssl.keyStore`: Define the path to the keystore.
- `javax.net.ssl.keyStorePassword`: Defines the password to the keystore.
- `javax.net.ssl.trustStore`: Defines the path to the trust-store.
- `javax.net.ssl.trustStorePassword`: Defines the password to the trust-store.

Use the third and fourth steps from [Setting up the Key and Trust Stores](Using-SSL-with-OrientDB.md#setting-up-the-key-and-trust-stores) section above to create the client certificates and server trust.  The paths to the stores are client specific, but do not need to be the same as the server.

Note, if you would like to use key and/ore trust-stores other than that of the default JVN, you need to define the following variables as well:

- `client.ssl.keyStore`: Defines the path to the keystore.
- `client.ssl.keyStorePass`: Defines the keystore password.
- `client.ssl.trustStore`: Defines the path to the trust-store.
- `client.ssl.trustStorePass`: Defines the password to the trust-store.

Consider the following example, configuring SSL from the command-line through Java:

<pre>
$ <code class="lang-sh userinput">java -Dclient.ssl.enabled=false \
      -Djavax.net.ssl.keyStore=</path/to/keystore> \
      -Djavax.net.ssl.keyStorePassword=<keystorepass> \  
      -Djavax.net.ssl.trustStore=</path/to/truststore> \
      -Djavax.net.ssl.trustStorePassword=<truststorepass></code>
</pre>

As an alternative, you can define these variables through the Java API:


```java
System.setProperty("client.ssl.enabled", <"true"|"false">); # This will only be needed for remote binary clients
System.setProperty("javax.net.ssl.keyStore", </path/to/keystore>);
System.setProperty("javax.net.ssl.keyStorePassword", <keystorepass>);
System.setProperty("javax.net.ssl.trustStore", </path/to/truststore>);
System.setProperty("javax.net.ssl.trustStorePassword", <truststorepass>);
```

To verify or authenticate client certificates, you need to take a few additional steps on the server:

1. Export the client certificate, so that you can share it with the server:

   <pre>
   # <code class="lang-sh userinput">keytool -export -alias <client_alias> \
         -keystore <client.ks> -file client_cert</code>
   </pre>

   Alternatively, you can do this through the console:

   <pre>
   # <code class="lang-sh userinput">keytool -export -alias console -keystore orientdb-console.ks \
         -file orientdb-console.cert</code>
   </pre>

1. If you do not have a trust-store for the server, create one and import the client certificate.  This establishes that the server trusts the client:

   <pre>
   # <code class="lang-sh userinput">keytool -import -alias <client_alias> -keystore orientdb.ts \
         -file client_cert</code>
   </pre>

    Alternatively, you can manage the same through the console:

   <pre>
   # <code class="lang-sh userinput">keytool -import -alias console -keystore orientdb.ts \ 
         -file orientdb-console.cert</code>
   </pre>

In the server configuration file, ensure that you have client authentication enabled for the `<socket>` and that the trust-store path and password are correct:

```xml
  <sockets>
    <socket implementation="com.orientechnologies.orient.server.network.OServerSSLSocketFactory" name="ssl">
      <parameters>
        <parameter value="true" name="network.ssl.clientAuth"/>
        <parameter value="config/cert/orientdb.ks" name="network.ssl.keyStore"/>
        <parameter value="password" name="network.ssl.keyStorePassword"/>

        <!-- NOTE: We are using the trust store with the imported client cert. You can import as many client as you would like -->
        <parameter value="config/cert/orientdb.ts" name="network.ssl.trustStore"/>
        <parameter value="password" name="network.ssl.trustStorePassword"/>
      </parameters>
    </socket>
    ...
</sockets>
```
