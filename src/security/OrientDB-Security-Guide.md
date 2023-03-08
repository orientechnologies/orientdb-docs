# OrientDB Security Guide #

The *OrientDB Security Guide* has three sections on security-related topics when running an instance of OrientDB:

- Security Recommendations Checklist
- Data Protection and Privacy
- OrientDB Security Documentation  

## Security Recommendations Checklist ##

The following is a list of recommended suggestions for improving the security of a default OrientDB installation:

- Disable Default Users
- Review Port Settings
- Enable TLS Encryption
- Enable Database Encryption
- Configure The JavaScript Sandbox
- Avoid Exposing The OrientDB Server To A Public Network
- Enable Auditing (Enterprise Only)
- Validate Plug-Ins

### Default Users and Roles ###
By default, when a new database is created, three default roles and their respective users are created.

The roles are *admin*, *reader*, and writer.  Three users are also created corresponding to each role: *admin*, *reader*, and *writer*.

A default password is also created for each user.  The password is the same as the user's name (e.g., the *admin* user's password is set to *admin*).

**SECURITY RECOMMENDATION**: Disable creation of default users.

To disable the creation of defaults roles and users when a database is created edit the *security.json* file in the *config* directory.  Set the *createDefaultUsers* property to false.

```
  "server": {
    "createDefaultUsers": false
  },
```

### Ports ###
The default configuration for an OrientDB server utilizes multiple communication ports:
- 2424 is the default binary protocol port used by binary protocol drivers.
- 2434 is the default Hazelcast discovery and multicast port (if distributed is enabled).
- 2480 is the default REST API endpoint port and also used by OrientDB Studio.
- 8182 is the default Gremlin Server port (if installed and enabled).

By default, none of the communications on these ports uses encryption.

**SECURITY RECOMMENDATION**: Enable TLS encryption for each protocol.

### TLS Encryption ###
OrientDB supports TLS 1.2 in-transit encryption.  However, this is not enabled in the default installation.

See [TLS Encryption](Using-SSL-with-OrientDB.md).


**SECURITY RECOMMENDATION**: Enable TLS encryption for each protocol.

### Database Encryption ###
OrientDB supports at-rest AES and DES database encryption.  A global encryption key can be set for all databases or a separate encryption can be set on each database.

See [Database Encryption](Database-Encryption.md).

By default, OrientDB databases are not encrypted.

**SECURITY RECOMMENDATION**: Enable at-rest encryption for each database. 

### JavaScript Sandbox ###
The OrientDB JavaScript engine runs in a sandbox.  By default, no packages are allowed to be accessed.

To allow specific Java packages edit the *OServerSideScriptInterpreter* handler in the *orientdb-server-config.xml* file under the *config* directory.

The parameter to edit is "allowedPackages".  Its value is a comma-separated list of packages. 

```
<handler class="com.orientechnologies.orient.server.handler.OServerSideScriptInterpreter">
	<parameters>
		<parameter name="enabled" value="true"/>
		<parameter name="allowedLanguages" value="SQL"/>
		<!--  Comma separated packages  allowed in JS scripts eg. java.math.*, java.util.ArrayList -->
		<parameter name="allowedPackages" value="com.orientechnologies.orient.core.security.OSecurityManager"/>
	</parameters>
</handler>
```
For more information see [JavaScript Functions](../admin/Functions-DB-Access.md)


**SECURITY RECOMMENDATION**: Be careful which packages are allowed, as granting access to certain packages could compromise the system security.

### OrientDB Web Server ###

It is not recommended to expose the OrientDB Web Server directly on the Internet or public networks.

For more information on this and JSONP, cross-site requests, and clickjacking, see: [OrientDB Web Server Security](../internals/Web-Server.md).

**SECURITY RECOMMENDATION**: Do not expose the OrientDB Web Server on the Internet or public networks.

### Enable Auditing (Enterprise Only) ###
If you are using the Enterprise version of OrientDB, it is recommended to enable the auditing feature.

For more information: [OrientDB Auditing](../ee/Auditing.md)

**SECURITY RECOMMENDATION**: Enable the auditing capability.

### Validate Plug-Ins ###
Since OrientDB supports both static and dynamic plug-ins, which have total access to the entire system, it is recommended to validate the installed plug-ins for authenticity and to limit write access to the *plugins* directory.

**SECURITY RECOMMENDATION**: Validate installed plug-ins.

## Data Protection and Privacy ##
See [SAP Enterprise OrientDB Data Protection and Privacy Approach for Products](SAP-Enterprise-OrientDB-DPP.md).


## OrientDB Security Documentation ##
More comprehensive information about OrientDB security can be found here:

- [New Security Features](Security-OrientDB-New-Security-Features.md)
- [Database security](Database-Security.md)
- [Server security](Server-Security.md)
- [Database Encryption](Database-Encryption.md)
- [Secure SSL connections](Using-SSL-with-OrientDB.md)
- [OrientDB Web Server](../internals/Web-Server.md)
