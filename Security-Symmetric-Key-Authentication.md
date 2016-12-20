---
search:
   keywords: ['security', 'authentication', 'symmetric key']
---

# Symmetric Key Authentication
Symmetric key authentication enables the use of a shared secret key to authenticate an OrientDB user.  Support for this was added to OrientDB Enterprise Edition in 2.2.14.

Two new server-side authenticators were added: OSecuritySymmetricKeyAuth and OSystemSymmetricKeyAuth.  See [Security Configuration](Security-Config.md).

## Overview
Symmetric key authentication works by both the server and the client sharing a secret key for an OrientDB user that's used to authenticate a client.

When a Java client (or via the OrientDB console) uses a symmetric key and tries to connect to an OrientDB server or open a database, the *username* is encrypted using the specified secret key.  On the server-side, the user's corresponding secret key will be used to decrypt the username.  If both usernames match, then the client is successfully authenticated.

The normal *password* field is used to encode the encrypted username as well as information specific to the key type.  A Java client can use the OSymmetricKey class to encrypt the username as part of the password field or can use the OSymmetricKeyCI credential interceptor.

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

### key

### keyFile

### keyStore

