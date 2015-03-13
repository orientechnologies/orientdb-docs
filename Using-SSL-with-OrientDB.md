# SSL

Starting from v1.7, OrientDB provides the ability to secure is HTTP and BINARY protocols using SSL (For Distributed SSL see the HazelCast Documentation).


## Setting up the Key and Trust Stores

OrientDB uses the JAVA Keytool to setup and manage certificates. This tutorial shows how to create key and trust stores that reference
a self signed cert. Use of CA signed certs is outside the scope of this document. For more details on using the java Keytool please visit
<http://docs.oracle.com/javase/7/docs/technotes/tools/index.html#security> and for more information.


1. Using keytool, create a certificate for the server:

    ```keytool -genkey -alias server -keystore orientdb.ks -keyalg RSA -keysize 2048 -validity 3650```

2. Export the server's certificate so it can be shared with clients:

    ```keytool -export -alias server -keystore orientdb.ks -file orientdb.cert```

3. Create a certificate/keystore for the console/clients:

    ```keytool -genkey -alias console -keystore orientdb-console.ks -keyalg RSA -keysize 2048 -validity 3650```

4. Create a trust-store for the client, and import the server's certificate. This establishes that the client "trusts" the server:

    ```keytool -import -alias server -keystore orientdb-console.ts -file orientdb.cert```


NOTE: You will need to repeat steps 3 and 4 for each remote client vm you wish to connect to the server.
      Remember to change the alias and keystore and trust-store filenames accordingly.


## Configuring the Server

The OrientDB server config ($ORIENTDB_HOME/config/orientdb-server-config.xml) does not enable SSL by default. To enable SSL on a protocol
listener you simply change the "socket" attribute of the <listener> from "default" to one of your configured <socket> definitions.

There are two default definitions named "ssl" and "https". These should be sufficient for most uses cases, however more can be defined if you
want to secure different listeners with there own certificates or want custom socket factory implementations. When using the "ssl" implementation
keep in mind that the default port for OrientDB SSL is 2434 and that your port-range should be changed to 2434-2440.

By default, the OrientDB Server looks for its keys and trust stores in $ORIENTDB_HOME/config/cert. This is configured using the <socket> parameters. Make sure that all of the key and trust stores created in the previous setup are in the correct directory and that the passwords used are also correct.

Note that paths are relative to $ORIENTDB_HOME. Absolute paths are supported.

Example Configuration

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

## Configuring the Console

To enable SSL for remote connections using the console, a few changes to the console script are required.

1. Confirm that your KEYSTORE, TRUSTSTORE and repective PASSWORD variables are set correctly.
2. In the SSL_OPTS definition set the "client.ssl.enabled" system property to "true"


## Configuring Client

Configuring remote clients can be done using standard java system property patterns.

Properties:

- ```client.ssl.enabled```: Used to enable/disable SSL. Accepts "true" or "false". Only needed when using remote binary client connections.
- ```javax.net.ssl.keyStore```: Path to key store
- ```javax.net.ssl.keyStorePassword```: Key store password
- ```javax.net.ssl.trustStore```: Path to trust store
- ```javax.net.ssl.trustStorePassword```: Trust store password

Use steps 3 and 4 from the "Setting up the Key and Trust Stores" section to create client certificates and trust of the server. Paths to the
stores will be client specific and do not need to be the same as the server.

If you would like to use key and/or truststores other that the default JVM they should use instead:

- ```client.ssl.keyStore```: Path to key store
- ```client.ssl.keyStorePass```: Key store password
- ```client.ssl.trustStore```: Path to trust store
- ```client.ssl.trustStorePass```: Trust store password

Example Java Command Line:

```
java -Dclient.ssl.enabled=false -Djavax.net.ssl.keyStore=</path/to/keystore> -Djavax.net.ssl.keyStorePassword=<keystorepass> \
	-Djavax.net.ssl.trustStore=</path/to/truststore> -Djavax.net.ssl.trustStorePassword=<truststorepass>
```

Example Java Implementation:

```java
System.setProperty("client.ssl.enabled", <"true"|"false">); # This will only be needed for remote binary clients
System.setProperty("javax.net.ssl.keyStore", </path/to/keystore>);
System.setProperty("javax.net.ssl.keyStorePassword", <keystorepass>);
System.setProperty("javax.net.ssl.trustStore", </path/to/truststore>);
System.setProperty("javax.net.ssl.trustStorePassword", <truststorepass>);
```

If you want to verify/authenticate client certificates, you need to take a few extra steps on the server:

1. Export the client's certificate so it can be shared with server:

    ```keytool -export -alias <client_alias> -keystore <client.ks> -file client_cert```

   Example using console:

    ```keytool -export -alias console -keystore orientdb-console.ks -file orientdb-console.cert```

2. Create a truststore for the server if one does not exist, and import the client's certificate. This establishes that the server "trusts" the client:

    ```keytool -import -alias <client_alias> -keystore orientdb.ts -file client_cert```

   Example using console:

    ```keytool -import -alias console -keystore orientdb.ts -file orientdb-console.cert```


In the server config make sure that client authentication is enabled for the <socket> and that the trust-store path and password are correct:

Example

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
```
