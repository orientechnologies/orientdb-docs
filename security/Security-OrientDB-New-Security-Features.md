---
search:
   keywords: ['security', 'new features']
---

# New Security Features - OrientDB

## Overview
The new security features in OrientDB (introduced in release 2.2) provide an extensible framework for adding external authenticators, password validation, LDAP import of database roles and users, advanced auditing capabilities, and syslog support.

The new security system uses a JSON configuration file, located in the *config* directory.  The default name of the file is *security.json*, but it can be overridden by setting the "server.security.file" property in *orientdb-server-config.xml* or by setting the global server property, "server.security.file".

To see the complete configuration options, click here: [Security Configuration](Security-Config.md).


## Authenticators
In addition to the built-in authentication of users that happens inside the database engine, the new OrientDB security system supports multiple types of external *authenticators*.  Each *authenticator* implements various methods to support authentication and authorization, among other things.  

All *authenticators* can be configured in the "authentication" section of the [security configuration](Security-Config.md).


### Current Implementations
Currently, OrientDB provides a [Kerberos authenticator](#kerb-auth), a [password authenticator](#pw-auth) for authenticating users in the *security.json* file, a [server config authenticator](#sc-auth) for authenticating users in the *orientdb-server-config.xml* file, and a [symmetric key authenticator](#sk-auth) (Enterprise-only).  Additional *authenticators* may be provided in the future, and it's very easy to build new ones.

#### <a id="kerb-auth"></a>OKerberosAuthenticator
This *authenticator* provides support for Kerberos authentication and full browser SPNEGO support.  See the [security configuration](Security-Config.md) page for full details on configuring this *authenticator* for Kerberos.

Also, see [Kerberos client examples](Security-Kerberos-Client-Examples.md) to see how to use the OrientDB clients with Kerberos.

#### <a id="pw-auth"></a>ODefaultPasswordAuthenticator
The `ODefaultPasswordAuthenticator` supports adding server users with passwords and resources to the *security.json* configuration file.  The main purpose of this is to allow having server users in a single file (along with all the other security settings) without having to maintain them in the separate *orientdb-server-config.xml* file.  See the example in the [security configuration](Security-Config.md) page.

#### <a id="sc-auth"></a>OServerConfigAuthenticator
The `OServerConfigAuthenticator` is similar to `ODefaultPasswordAuthenticator` in that it supports server users with passwords and resources, but it's designed to be used with the users in the *orientdb-server-config.xml* configuration file instead.

#### <a id="su-auth"></a>OSystemUserAuthenticator
The `OSystemUserAuthenticator` supports the new *system user* type that's stored in the system database.

#### <a id="sk-auth"></a>Symmetric Key Authenticator
The `Symmetric Key Authenticator` provides support for authenticating users via a shared symmetric key.

There are two versions of the `Symmetric Key Authenticator`, one that enables authenticating server users and one that enables authenticating system users.

### Chaining *Authenticators*
What's important to note is that the *authenticators* can be thought of as being chained together so that if the first *authenticator* in the list fails to authenticate a user, then the next *authenticator* in the chain is tried.  This continues until either a user is successfully authenticated or all *authenticators* are tried.  This "chaining of *authenticators*" is used for authentication, authorization, retrieving HTTP authentication headers, and several other security features.

### Default Authentication
As mentioned previously, OrientDB has a built-in authentication system for each database, and it is enabled by default.  To disable it, set the "allowDefault" property in the "authentication" section of the *security.json* configuration to false.  When enabled, the built-in authentication acts as a "fallback" if the external *authenticators* cannot authenticate or authorize a user.   


## Password Validator ##
Another new feature of the security system is a customizable password validator.  The provided validator is called `ODefaultPasswordValidator` that, when enabled, validates user-chosen passwords based on minimum length and regular expressions.  Which numbers, uppercase letters, and special characters are permitted along with their required count is specified by a regular expression for each.  Like all the security components, the password validator can be extended or completely replaced with a custom password validator component.

See the [security configuration](Security-Config.md) page for details on how to configure the password validator.


## LDAP Import ##
Another often-requested feature, importing of LDAP users, is now available as part of OrientDB.  Each database can be configured to import from multiple LDAP domains, each domain may specify multiple LDAP servers, and the users and their corresponding roles can be specified per-domain using a standard LDAP filter.

The [security configuration](Security-Config.md) page explains in great details all the options for the default LDAP importer.


## Auditing/Syslog ##
Enhancements to the auditing component have also been made.  The audit log now supports monitoring of a class being created and dropped as well as when distributed nodes join and leave the cluster.  Additionally, for operating systems that support *syslog*, a new *syslog* plug-in has been added for recording auditing events.  

See the [security configuration](Security-Config.md) page for details on auditing properties.

## Reloading ##
The new security system supports dynamic reloading by an HTTP POST request.  The path to the configuration file to use is provided as JSON content.  The provided credentials must have sufficient privileges to reload the security module.

Here's an example using *curl* with basic authentication:
```
curl -u root:password -H "Content-Type: application/json" -X POST -d '{ "configFile" : "${ORIENTDB_HOME}/config/security.json" }'  servername:2480/security/reload 
```

Here's another example using *curl* using Kerberos/SPNEGO authentication:
```
curl --negotiate -u : -H "Content-Type: application/json" -X POST -d '{ "configFile" : "${ORIENTDB_HOME}/config/security.json" }'  servername:2480/security/reload 
```
	
Notice the passed-in JSON "configFile" property.  Any valid security configuration file may be specified here, making testing multiple configurations possible.

### Reloading Individual Components ###
Instead of reloading the entire security system, it's also possible to reload individual security components.

Here's an example using *curl* with basic authentication:
```
curl -u root:password -H "Content-Type: application/json" -X POST -d '{ "module" : "auditing", "config" : "{ACTUAL JSON CONTENT}" }'  servername:2480/security/reload 
```

Notice, instead of specifying "configFile" you use "config" and the "module" property.

Currently, you can reload the following security components:
- server
- authentication
- passwordValidator
- ldapImporter
- auditing
