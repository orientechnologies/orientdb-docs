# System Users Implementation
The new OrientDB [security system](security/Security-OrientDB-New-Security-Features.md) installs a specialized *OSecurityShared* class, called *OSecurityExternal*, that supports external authentication of users, meaning that a username can be authenticated outside the realm of a local database.  Typically, there is a "chain of authenticators", specified in the *security.json* configuration file, in the "authentication" section, that will be checked to see if the username can be authenticated.  The authenticator for the *system users* is called *OSystemUserAuthenticator*.

If authentication is successful, *OSecurityExternal.authenticate()* then calls `Orient.instance().getSecurity().getSystemUser()` with the authenticated username and the name of the local database being opened.  (`Orient.instance().getSecurity()` returns an instance of the system security module, *ODefaultServerSecurity*.)  If a *system user* is found, `getSystemUser()` returns a derived *OUser* class instance, called *OSystemUser*.

## Database Open
When a database is opened, the ODatabaseDocumentTx.open() method calls `final OUser usr = metadata.getSecurity().authenticate(iUserName, iUserPassword);`.  If the new security system is enabled, the call to `metadata.getSecurity()` will return an instance of *OSecurityExternal*.  The `OSecurityExternal.authenticate()` method calls `Orient.instance().getSecurity().authenticate(iUserName, iUserPassword)`.  The method, `Orient.instance().getSecurity()` returns an instance of *ODefaultServerSecurity*, and its `authenticate()` method is where the chain of installed authenticators is called.

## OSystemUserAuthenticator 
*OSystemUserAuthenticator* implements a method, `public String authenticate(final String username, final String password)`, from the *OSecurityAuthenticator* interface.  This method queries the system database for an *OUser* record that matches the specified username and, if found, validates the provided password.  If successful, the username is returned, otherwise null.

## OSystemUser
As mentioned previously, when `Orient.instance().getSecurity().getSystemUser()` is called, if a system user is found, an *OSystemUser* instance is returned.  *OSystemUser* extends *OUser* and implements a new constructor, `public OSystemUser(final ODocument iSource, final String dbName)`, as well as a newly overrided method, `protected ORole createRole(final ODocument roleDoc)`.

The "database name" (dbName) parameter in *OSystemUser*'s constructor is used to filter which roles in the system database are associated with a user.  A list property, called *dbFilter*, can be set on an ORole record to assigned the database name.  If *dbName* is null, then only roles without a *dbFilter* property are associated with the *OSystemUser*.

## OSystemRole
In conjunction with *OSystemUser* is a new class, called *OSystemRole*, which derives from *ORole* and adds a new public method, `List<String> getDbFilter()`.  The *OSystemUser* `createRole()` method creates and returns *OSystemRole* instances.


