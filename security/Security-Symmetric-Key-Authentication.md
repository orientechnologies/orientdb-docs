---
search:
   keywords: ['security', 'authentication', 'symmetric key', 'keystore', 'AES', 'cipher']
---

# Symmetric Key Authentication
Symmetric key authentication enables the use of a shared secret key to authenticate an OrientDB user.  Support for this was added to OrientDB Enterprise Edition in 2.2.14.

Two new server-side authenticators were added: OSecuritySymmetricKeyAuth and OSystemSymmetricKeyAuth.  See [Security Configuration](Security-Config.md).

## Overview
Symmetric key authentication works by both the server and the client sharing a secret key for an OrientDB user that's used to authenticate a client.

When a Java client (or via the OrientDB console) uses a symmetric key and tries to connect to an OrientDB server or open a database, the *username* is encrypted using the specified secret key.  On the server-side, the user's corresponding secret key will be used to decrypt the username.  If both usernames match, then the client is successfully authenticated.

The normal *password* field is used to encode the encrypted username as well as information specific to the key type.  A Java client can use the OSymmetricKey class to encrypt the username as part of the password field or can use the OSymmetricKeyCI credential interceptor.

Note that the symmetric key is *never* sent from the client to the server as part of the authentication process.

## OSymmetricKey Client Example
The OSymmetricKey class is used to create symmetric secret keys, load them from various sources, and to encrypt/decrypt data.

Here's an example using a Base64 key string with an OSymmetricKey object to encrypt the username, "Bob", and send that as the password field of the OServerAdmin connect() method:

```
String key = "8BC7LeGkFbmHEYNTz5GwDw==";
OSymmetricKey sk = new OSymmetricKey("AES", "AES/CBC/PKCS5Padding", key);

String url = "remote:localhost";
String username = "Bob";
String password = sk.encrypt(username);

OServerAdmin serverAdmin = new OServerAdmin(url).connect(username, password);
serverAdmin.createDatabase("TestDB", "graph", "plocal");
serverAdmin.close();
```

## OSymmetricKeyCI Console Example
To use the symmetric key authentication from the OrientDB console, you need to set the credential interceptor in the console.sh (or console.bat for Windows) script.

Add this property to the `ORIENTDB_SETTINGS` variable:
```
ORIENTDB_SETTINGS="-Dclient.credentialinterceptor=com.orientechnologies.orient.core.security.symmetrickey.OSymmetricKeyCI"
```

The symmetric key credential interceptor is called `OSymmetricKeyCI`.

The password field is used to specify a JSON document that contains the properties for using a secret key string, a file containing a secret key string, or a Java KeyStore file.

One of the required JSON properties is 'transform', which indicates the cipher transformation.  If 'transform' is not specified as part of the JSON document, the global property, `client.ci.ciphertransform` can be set in `ORIENTDB_SETTINGS` instead.

Another property that can be set is the key's algorithm type, set by specifying 'algorithm' in the JSON document.  If 'algorithm' is not specified then the algorith is determined from the cipher transformation.  The key's algorithm can also be set as part of the `ORIENTDB_SETTINGS` using the global property `client.ci.keyalgorithm`.

Example:
```
ORIENTDB_SETTINGS="-Dclient.credentialinterceptor=com.orientechnologies.orient.core.security.symmetrickey.OSymmetricKeyCI -Dclient.ci.keyalgorithm=AES -Dclient.ci.ciphertransform=AES/CBC/PKCS5Padding"
```

### key
Here's a console example using an AES 128-bit key:
```
connect remote:localhost:2424 serveruser "{'transform':'AES/CBC/PKCS5Padding','key':'8BC7LeGkFbmHEYNTz5GwDw=='}"
```
Note that the cipher transformation is specified via 'transform'.  If 'algorithm' is not specified (the key's algorithm), then the algorith is determined from the cipher transformation.

### keyFile
Here's a console example using an AES key file:
```
connect remote:localhost:2424 serveruser "{'transform':'AES/CBC/PKCS5Padding','keyFile':'config/user.key'}"
```

### keyStore
Using a Java KeyStore requires a few more properties.  Here's an example:
```
connect remote:localhost:2424 serveruser "{'keyStore':{ 'file':'config/server.ks', 'password':'password', 'keyAlias':'useralias', 'keyPassword':'password' } }"
```
In the above example, it's assumed the cipher transformation is set as part of the `ORIENTDB_SETTINGS`.

The 'keyStore' property is an object with the following properties:
#### 'file'
The 'file' property is a path to a Java KeyStore file that contains the secret key. Note that the JCEKS KeyStore format must be used to hold secret keys.

#### 'password'
The 'password' property holds the password for the KeyStore file. It is optional.

#### 'keyAlias'
The 'keyAlias' property is the alias name of the secret key in the KeyStore file. It is required.

#### 'keyPassword'
The 'keyPassword' property holds the password for the secret key in the KeyStore and is optional.

