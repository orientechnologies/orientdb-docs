# New Security Features - Code Changes #

The motivation behind creating a new security layer for OrientDB was to meet the requirements of several customers who needed external authentication (specifically Kerberos and SPNEGO support), the ability to import users from specific groups via LDAP, password validation, and new auditing capabilities.

The OrientDB *Client*, *Core*, *Server*, and *Enterprise Agent* modules were all affected by the new security system.  At the heart is a new interface called `OSecuritySystem` that provides most of the high-level methods required for implementing the main features.  The `Orient` instance in the *Core* stores a reference to the `OSecuritySystem` instance, and it can be accessed by calling `Orient.instance().getSecurity().`  Note that this only applies when called from the Server.  Otherwise, `getSecurity()` will just return null.

Another main interface, called `OServerSecurity`, is derived from `OSecuritySystem`, and it provides some additional methods that are specific to the server.  In `OServer`, an implementation of `OServerSecurity`, called `ODefaultServerSecurity`, is created and stored. It can be accessed via a public method, `getSecurity()`, from the server instance.  When `ODefaultServerSecurity` is created in `OServer`, its instance is registered with `Orient`.

`ODefaultServerSecurity` handles loading the new JSON security configuration file that is stored under *config* and is called *security.json* by default.  Currently, *security.json* has five main sections: "server", "authentication", "passwordValidator", "ldapImporter", and "auditing".

The most important thing to take away from this implementation is the concept of *authenticators* which can be chained together to support multiple kinds of authentication.  As an example, the primary *authenticator* could be for Kerberos, followed by an NTLM *authenticator*, followed by a password *authenticator* (which allows usernames, passwords, and resources to be stored in the *security.json* file), and then followed by an `OServer` config *authenticator* (which supports the users section in *orientdb-server-config.xml*).  If authentication fails for the first *authenticator* then the next one in the chain is attempted.  This continues until all *authenticators* are tried.

Authorization works in a similar way.  The primary *authenticator* implementation is tried first to see if the specified user has the required resource permissions.  If not successful, the second *authenticator* is then tried, and so forth.

Lastly, for the type of HTTP authentication that each *authenticator* supports, an authentication header will be created using each *authenticator*, starting with the primary.  As an example, this allows for a Kerberos "Negotiate" header to be returned as well as a "Basic" authentication header for fallback purposes.      
 
On the *Client* side, there's a new interface, called `OCredentialInterceptor`, which allows for providing single sign-on security implementations (such as for Kerberos, NTLM) while still working with the OrientDB authentication framework.

The other significant change is in the *Core* and happens in `OMetadataDefault` in its `init()` method.  Previously, an instance of `OSecurityShared` was created.  Now, an `OSecurity` instance is created by calling `OSecurityManager.instance().newSecurity()`.  The reason for this is to support different OSecurity implementations depending on the authentication requirements.  As an example, for external authentication, an `OSecurityExternal` instance will be created.  `OSecurityExternal` derives from `OSecurityShared` but overrides `authenticate()`, calling the security system's `authenticate()` method instead (`Orient.instance().getSecurity().authenticate()`).

Enterpise auditing has some new capabilities as well.  Tracking of creating and dropping classes has been added as well as when nodes join and leave the cluster in a distributed setup.  Writing to Syslog as part of the auditing log has been added too.


## Client ##

### OServerAdmin ###
Modified the `connect()` method to create a new `OCredentialInterceptor` from the security manager and, if successful, calls its `intercept()` method, and then retrieves the username and password from the interceptor.

```
OCredentialInterceptor ci = OSecurityManager.instance().newCredentialInterceptor();
			
if(ci != null)
{
  ci.intercept(storage.getURL(), iUserName, iUserPassword);
  username = ci.getUsername();
  password = ci.getPassword();
}
```


### OStorageRemote ###
Modified the `open()` method to create a new `OCredentialInterceptor` from the security manager and, if successful, calls its `intercept()` method, and then retrieves the username and password from the interceptor.

```
OCredentialInterceptor ci = OSecurityManager.instance().newCredentialInterceptor();

if(ci != null)
{	
  ci.intercept(getURL(), iUserName, iUserPassword);
  connectionUserName = ci.getUsername();
  connectionUserPassword = ci.getPassword();
}
else // Do Nothing
{
  connectionUserName = iUserName;
  connectionUserPassword = iUserPassword;
}
```


## Core ##

### Orient ###
Added getter and setter methods for the OSecuritySystem variable.

```
private volatile OSecuritySystem security;

public OSecuritySystem getSecurity() { return this.security; }
public void setSecurity(final OSecuritySystem security) {
  this.security = security;

}
```  


### OGlobalConfiguration ###
Added several new properties to support Kerberos on the client and other server-related security properties. 

These properties are OrientDB client-specific only:

|Property|Description|
|--------|-----------|
|"client.krb5.config"|Specifies the location of the Kerberos configuration file (typically krb5.conf).|
|"client.krb5.ccname"|Specifies the location of the Kerberos credential cache file.|
|"client.krb5.ktname"|Specifies the location of the Kerberos keytab file.|
|"client.credentialinterceptor"|Specifies the name of the credential interceptor class to use.|

These properties are OrientDB server-specific only:

|Property|Description|
|--------|-----------|
|"security.createDefaultUsers"|Indicates if "default users" should be created.  When set to true and the server instance is new, the default users in orientdb-server-config.xml will be created.  Also, if set to true, when a new database is created the default database users will be created.|
|"server.security.file"|Specifies the location (and name) of the JSON security configuration file.  By default, the file is named *security.json* and is located in the *config* directory.| 


### OMetadataDefault ###
In the `init()` method, notice that `final OSecurityShared instance = new OSecurityShared();`

```
new Callable<OSecurityShared>() {
 public OSecurityShared call() {
   final OSecurityShared instance = new OSecurityShared();
   if (iLoad) {
     security = instance;
     instance.load();
   }
   return instance;
 }
}), database);
```

is changed to `final OSecurity instance = OSecurityManager.instance().newSecurity();`

```
new Callable<OSecurity>() {
 public OSecurity call() {
   final OSecurity instance = OSecurityManager.instance().newSecurity();
   if (iLoad) {
     security = instance;
     instance.load();
   }
   return instance;
 }
}), database);
```


### OSchemaShared ###
In the `dropClassInternal()` method, added calls to `onDropClass()` for all the *ODatabaseLifecycleListener* listeners.

```
// WAKE UP DB LIFECYCLE LISTENER
for (Iterator<ODatabaseLifecycleListener> it = Orient.instance().getDbLifecycleListeners(); it.hasNext(); )
  it.next().onDropClass(getDatabase(), cls);
```


### OSecurityManager ###
Added four new methods to support the credential interceptor, security factory, and new OSecurity instances.  Created a default OSecurityFactory instance.

```
private OSecurityFactory securityFactory = new OSecuritySharedFactory();
	
public OCredentialInterceptor newCredentialInterceptor()
	// Dynamically creates an OCredentialInterceptor instance using the OGlobalConfiguration.CLIENT_CREDENTIAL_INTERCEPTOR property.

public OSecurityFactory getSecurityFactory() { return securityFactory; }

public void setSecurityFactory(OSecurityFactory factory) { securityFactory = factory; }  

public OSecurity newSecurity()
{
  if(securityFactory != null) return securityFactory.newSecurity();
    
  return null;
}

```

### OSecurityShared ###
In the `isAllowed()` method, added a fix to check for if `iAllowAll` is null.  Also added a check for `areDefaultUsersCreated()` when calling `createUser()`.

```
if(Orient.instance().getSecurity() == null || Orient.instance().getSecurity().areDefaultUsersCreated())
	createUser(…)
```

Also changed the protection of the `getDatabase()` method from private to protected.


### OUserTrigger ###
In the `encodePassword()` method, added a call to the security system's `validatePassword()` method.

```
if(Orient.instance().getSecurity() != null)
{
  Orient.instance().getSecurity().validatePassword(password);
}
```

### New Files - Added to orient/core/security ###
|File|Description|
|----|-----------|
|OCredentialInterceptor.java|Provides a basic credential interceptor interface with three methods: getUsername(), getPassword(), and intercept().|
|OInvalidPasswordException.java|Provides a specific exception used by password validator implementations for failed validation.  Derives from OSecurityException.|
|OPasswordValidator.java|Provides a simple interface for validating passwords.  Contains one method: validatePassword().|
|OSecurityExternal.java|Extends OSecurityShared, providing external authentication by calling Orient.instance().getSecurity().authenticate().|
|OSecurityFactory.java|Provides an interface for creating new OSecurity instances.  Contains one method: newSecurity().|
|OSecuritySharedFactory.java|Implements the OSecurityFactory interface for OSecurityShared instances.  Its newSecurity() method returns a new OSecurityShared instance.|
|OSecuritySystem.java|Provides a basic interface for a modular security system supporting external authenticators.|
|OSecuritySystemException.java|Provides a specific exception used by OSecuritySystem implementations.|


### OSecuritySystem ###
OSecuritySystem is a base interface and requires the following methods:

|Method        |Description|
|--------------|-----------|
|authenticate()|Takes a username and password and returns the authenticated *principal* (on success) or null (on failure).|
|areDefaultUsersCreated()|Returns a boolean indicating if the "createDefaultUsers" security property is set to true or false.  When set to true and the server instance is new, the default users in orientdb-server-config.xml will be created.  Also, if set to true, when a new database is created the default database users will be created.|
|getAuthenticationHeader()|Returns the current HTTP authentication header.  Depending on which *authenticator(s)* is installed, multiple authentication headers may be returned to support primary, secondary, and fallback browser authentication types.|
|isAuthorized()|Takes a username and resource list (as a String).  Walks through the installed *authenticators* and returns true if a matching username is found that has the required authorization for the specified resource list.|  
|isDefaultAllowed()|Returns a boolean indicating if the "authentication"."allowDefault" property is set to true or false.  When set to true and authentication fails using the installed *authenticators*, the default database authentication may also be used.|  
|isEnabled()|Returns a boolean indicating if the security system is enabled.|
|isSingleSignOnSupported()|Returns a boolean that indicates if the primary authenticator supports single sign-on.|
|validatePassword()|Takes a password and, if a password validator is installed, throws an OInvalidPasswordException if the provided password fails to meet the validation criteria.|


### New Directory (kerberos) - Added to orient/core/security ###
Added a new kerberos directory under orient/core/security.


### New Files - Added to orient/core/security/kerberos ###
|File|Description|
|----|-----------|
|OKerberosCredentialInterceptor.java|Provides an implementation of OCredentialInterceptor, specific to Kerberos.|
|OKrb5ClientLoginModuleConfig.java|Provides a custom Kerberos client login `Configuration` implementation.|


## Server ##

### OServer ###
Added a new variable for an `OServerSecurity` instance along with getter/setter methods.

Created a new method called `authenticateUser()`.  If the `OServerSecurity` instance is enabled, it calls its `authenticate()` method; and if a valid *principal* is returned, then its `isAuthorized()` method is called.  If `OServerSecurity` is not enabled, then the default `OServer` authentication and authorization methods are used.

Modified the `activate()` method, adding the creation of a new `ODefaultServerSecurity` instance, assigning it to the `serverSecurity` variable, and calling `Orient.instance.setSecurity(serverSecurity)`. 

Changed the `serverLogin()` method, calling `authenticateUser()` instead.

Modified the `authenticate()` method, also calling `authenticateUser()` instead. 

Updated the `isAllowed()` method, calling the server security's `isAuthorized()` method, if the security module is enabled.  Otherwise, the default implementation is used.

Changed the `getUser()` method, calling the server security's `getUser()` method, if the security module is enabled.  Otherwise, the default implementation is used.

Modified the `openDatabase()` method, checking and using the returned value of `serverLogin()`.  This is done because in some security implementations the user is embedded inside a ticket of some kind that must be decrypted in order to retrieve the actual user identity.  If serverLogin() is successful that user identity is returned.

Updated the `loadUsers()` method, adding a check to `serverSecurity.areDefaultUsersCreated()` before calling `createDefaultServerUsers()`.

Changed `createDefaultServerUsers()`, immediately returning if `serverSecurity.arePasswordsStored()` returns false.

Added a try/catch block in `registerPlugins()` around the handler loading.  This prevents a bad plugin from keeping the entire system from starting. 


### OHttpUtils ###
Added SPNEGO negotiate header support.

```
public static final String HEADER_AUTHENTICATE_NEGOTIATE = "WWW-Authenticate: Negotiate";
public static final String AUTHORIZATION_NEGOTIATE       = "Negotiate";
```


### ONetworkProtocolHttpAbstract ###
Changed the `handlerError()` method, using `server.getSecurity().getAuthenticationHeader()` to set the `responseHeaders` variable.

Modified `readAllContent()`, adding "Negotiate" support.

Added two new commands, `OServerCommandGetSSO()` and `OServerCommandGetPing()`, in `registerStatelessCommands()`.


### OServerCommandAuthenticatedDbAbstract ###
Replaced in `sendAuthorizationRequest()` the assignment to `header` of "Basic" authentication with the result of calling `server.getSecurity().getAuthenticationHeader(iDatabaseName)`.


### OServerCommandAuthenticatedServerAbstract ###
Replaced in `sendAuthorizationRequest()` the assignment to `header` of "Basic" authentication with the result of calling `server.getSecurity().getAuthenticationHeader(iDatabaseName)`.


### OServerCommandPostAuthToken ###
Replaced in `sendAuthorizationRequest()` the assignment to `header` of "Basic" authentication with the result of calling `server.getSecurity().getAuthenticationHeader(iDatabaseName)`.


### OServerConfigurationManager ###
In the `setUser()` method, removed the check for `iServerUserPasswd` being empty, as some security implementations do not require a password.


### New File - Added to orient/server/network ###
Added one new file, `OServerTLSSocketFactory.java`.

### OServerTLSSocketFactory ###
OServerTLSSocketFactory simply extends OServerSSLSocketFactory to make it clear that OrientDB does support TLS encryption by default.


### New Files - Added to orient/server/network/protocol/http/command/get ###
Added two new commands, `OServerCommandGetPing` and `OServerCommandGetSSO`.

### OServerCommandGetPing ###
Added a very simple Get *Ping* command, used by Studio, to test if the HTTP server is still alive.  As opposed to *listDatabases*, this command requires no authentication and no special authorization.  This is important for heavyweight *authenticators*, such as SPNEGO/Kerberos.


### OServerCommandGetSSO ###
This Get command is also used by Studio to determine if the primary *authenticator* supports single sign-on.  If single sign-on is supported, then the *username* and *password* credentials in the login dialog are not required. 


### New File - Added to orient/server/network/protocol/http/command/post ###
Added one new command, `OServerCommandPostSecurityReload`.

### OServerCommandPostSecurityReload ###
This command is designed to reload the current `OServerSecurity` module and accepts a path to the security JSON file to use.


### New Files - Added to orient/server/security ###
The following files were added to the security directory:

* OAuditingService.java
* ODefaultPasswordAuthenticator.java
* ODefaultServerSecurity.java
* OSecurityAuthenticator.java
* OSecurityAuthenticatorAbstract.java
* OSecurityAuthenticatorException.java
* OSecurityComponent.java
* OServerConfigAuthenticator.java
* OServerSecurity.java
* OSyslog.java


### OAuditingService ###
Provides a simple auditing service interface, and specifies three `log()` methods.  Extends the `OSecurityComponent` interface.


### ODefaultPasswordAuthenticator ###
Extends the `OSecurityAuthenticatorAbstract` class, providing a default *authenticator* that supports a username, password, and resource list. 


### ODefaultServerSecurity ###
Provides the default server security implementation, supporting these interfaces: `OSecurityFactory`, `OServerLifecycleListener`, and `OServerSecurity`.


### OSecurityAuthenticator ###
Provides an interface for implementing a security *authenticator*.  Extends the `OSecurityComponent` interface. 

Requires the following methods.

|Method|Description|
|------|-----------|
|authenticate()|Authenticates the specifed username and password.  The authenticated *principal* is returned if successful, otherwise null.|
|getAuthenticationHeader()|Returns the HTTP authentication header supported by this *authenticator*.|
|getClientSubject()|If supported by this *authenticator*, returns a `Subject` object with this *authenticator's* credentials.|
|getName()|Returns the name of this `OSecurityAuthenticator`.|
|getUser()|Returns an `OServerUserConfiguration` object if the matching username is found for this *authenticator*.  Returns null otherwise.|
|isAuthorized()|Takes a username and resource list (as a String).  Returns true if a matching username is found for this *authenticator* that has the required authorization for the specified resource list.|
|isSingleSignOnSupported()|Returns a boolean that indicates if this *authenticator* supports single sign-on.|


### OSecurityAuthenticatorAbstract ###
Provides an abstract implementation of `OSecurityAuthenticator`upon which most *authenticators* are derived.


### OSecurityAuthenticatorException ###
Provides a custom OException that security *authenticators* can throw.


### OSecurityComponent ###
Provides an interface for creating security components that all modules in the security JSON configuration implement.

`OSecurityComponent` consists of four methods: `active()`, `config()`, `dispose()`, and `isEnabled()`.


### OServerConfigAuthenticator ###
Provides an `OSecurityAuthenticator` implementation that supports the users listed in orientdb-server-config.xml.  It extends `OSecurityAuthenticatorAbstract`.


### OServerSecurity ###
Provides an interface for server-specific security features.  It extends `OSecuritySystem`.

Requires the following methods.

|Method|Description|
|------|-----------|
|getAuthenticator()|Returns the `authenticator` based on name, if one exists.|
|getPrimaryAuthenticator()|Returns the first `authenticator` in the chain of `authenticators`, which is the primary authenticator.|
|getUser()|Some `authenticators` support maintaining a list of users and associated resources (and sometimes passwords).  Returns the associated `OServerUserConfiguration` if one exists for the specified *username*.|
|openDatabase()|Opens the specified *dbName*, if it exists, as the *superuser*.|
|registerAuditingService()|Supports a pluggable, external `OAuditingService` instance.|
|registerSecurityClass()|Supports multiple, pluggable, external security components.|
|reload()|Reloads the server security module using the specified *cfgPath*.|


### OSyslog ###
Provides an interface to syslog (and other such event logging systems) and specifies three `log()` methods.  Extends the `OSecurityComponent` interface.

## graphdb/config ##
### orientdb-server-config.xml ###
Replaced OServerSSLSocketFactory with OServerTLSSocketFactory.


### security.json ###
Added a default security.json implementation file.

## Security Plugin
To support a single location for all the new security component implementations, a new project, *orientdb-security*, has been created.

The following security components now reside here:
- ODefaultAuditing
- ODefaultPasswordAuthenticator
- ODefaultPasswordValidator
- ODefaultSyslog
- OKerberosAuthenticator
- OLDAPImporter
- OServerConfigAuthenticator



## Enterprise Agent ##

### OAuditingHook ###
[This was moved into *orientdb-security*.]

Added support for auditing of CREATECLASS and DROPCLASS events.

Added optional support for *syslog* audit logging as well.


### OAuditingListener ###
[This was moved into *orientdb-security* and renamed `ODefaultAuditing`.]

Implemented two new interfaces, `OAuditingService` and `ODistributedLifecycleListener`.

Also moved `Orient.instance().addDbLifecycleListener(this)` to the `active()` method.


### OEnterpriseAgent ###
[This was removed from the agent and added to `OSecurityPlugin` in *orientdb-security*.]

Added a new method, `registerSecurityComponents()`, for registering Enterprise-only security components in the security system.

Added a call to `registerSecurityComponents()` in the `startup()` method.


### agent/kerberos ###
[This was moved into *orientdb-security*.]

Added a new *kerberos* directory and the following new files.

|File|Description|
|----|-----------|
|OKerberosAuthenticator.java|Implements a Kerberos-specific security *authenticator* that extends `OSecurityAuthenticatorAbstract`.|
|OKerberosLibrary.java|Provides a collection of static methods used by the Kerberos *authenticator*.|
|OKrb5LoginModuleConfig.java|Provides a custom Kerberos login `Configuration` implementation.|


### agent/ldap ###
[This was moved into *orientdb-security*.]

Added a new *ldap* directory and the following new files.

|File|Description|
|----|-----------|
|OLDAPImporter.java|Provides LDAP user/group importer into a database.  Implements the `OSecurityComponent` interface.|
|OLDAPLibrary.java|Provides a collection of static methods used by the LDAP importer.|
|OLDAPServer.java|Provides a simple class used by OLDAPImporter and OLDAPLibrary for specifying LDAP servers.|


### agent/security ###
[This was moved into *orientdb-security*.]

Added a new *security* directory and the following new files.

|File|Description|
|----|-----------|
|ODefaultPasswordValidator.java|Provides a default implementation for validating passwords.  Implements `OPasswordValidator` and `OSecurityComponent`.|
|ODefaultSyslog.java|Provides a default implementation of the `OSyslog` interface.|


### resources ###
[This was moved into *orientdb-security*.]

Modified the default-auditing-config.json file, adding class support for "onCreateClassEnabled", "onCreateClassMessage", "onDropClassEnabled", and "onDropClassMessage". 


### pom.xml ###
[This was moved into *orientdb-security*.]

Added the dependency for CloudBees *syslog* client support:

```
<dependency>
   <groupId>com.cloudbees</groupId>
   <artifactId>syslog-java-client</artifactId>
   <version>1.0.9-SNAPSHOT</version>
</dependency>
```


