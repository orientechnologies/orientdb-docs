# OrientDB Security Configuration #
The new OrientDB security system uses a JSON configuration file that's located by default in the *config* directory.  The default name of the file is *security.json*, but it can be overridden by setting the "server.security.file" property in *orientdb-server-config.xml* or by setting the global server property, "server.security.file".

The security.json configuration file may contain up to eight global properties: "enabled", "debug", "server", "authentication", "passwordValidator", "ldapImporter", "auditing", and "syslog".

Here's a description of each top-level property in the security.json file.

|Property|Description|
|--------|-----------|
|"enabled"|If set to true (the default), the OrientDB security module that provides external authentication, authorization, password validation, LDAP import, and advanced auditing will be enabled.|
|"debug"|When set to true (false is the default), additional context information will be written to the OrientDB server log pertaining to the security system's operation.|
|"server"|This property is an object with one sub-property, "createDefaultUsers".  It is described below.|
|"authentication"|This property is an object with two sub-properties, "allowDefault" and "authenticators", and it is described in greater detail below.  Its purpose defines the available security authenticators.|
|"passwordValidator"|This property is also an object and defines the parameters required for the security system's password validator when enabled.  It is described in detail below.|
|"ldapImporter"|This property is an object with up to five sub-properties, and it defines the LDAP importer object.  See below for more details.|
|"auditing"|This property is also an object and contains two sub-properties, "class" and "enabled", and is described below.|
|"syslog"|This property is an object and contains five sub-properties.  It is described below.| 

## "server"
The "server" object contains one property called "createDefaultUsers".

|Property|Description|
|--------|-----------|
|"createDefaultUsers"|When set to true (the default), the default OrientDB users will be created for new databases and the default orientdb-server-config.xml users will be created on the first run of the server.|


## "authentication"
The "authentication" object specifies security authenticators for OrientDB and their order.  Here's an example:

```
"authentication" :
{
	"allowDefault" : true,

	"authenticators" :
	[
		{
			"name"		: "Kerberos",
			"class"		: "com.orientechnologies.security.kerberos.OKerberosAuthenticator",
			"enabled"	: true,
			"debug"		: false,
	
			"krb5_config"	: "/etc/krb5.conf",
			
			"service" :
			{
				"ktname" 	: "/etc/keytab/kerberosuser",
				"principal"	: "kerberosuser/kerberos.domain.com@REALM.COM"
			},
	
			"spnego" :
			{
				"ktname" 	: "/etc/keytab/kerberosuser",
				"principal"	: "HTTP/kerberos.domain.com@REALM.COM"
			},
	
			"client" :
			{
				"useTicketCache"	: true,
				"principal" 		: "kerberosuser@REALM.COM",
				"renewalPeriod"		: 300
			}
		},
		
		{
			"name"				: "Password",
			"class"				: "com.orientechnologies.orient.server.security.authenticator.ODefaultPasswordAuthenticator",
			"enabled"			: true,
			"users" 			:
			[
				{ "username" : "guest", "resources" : "connect,server.listDatabases,server.dblist" }
			]
		},

		{
			"name"				: "ServerConfig",
			"class"				: "com.orientechnologies.orient.server.security.authenticator.OServerConfigAuthenticator",
			"enabled"			: true
		},

		{
			"name"				: "SystemAuthenticator",
			"class"				: "com.orientechnologies.orient.server.security.authenticator.OSystemUserAuthenticator",
			"enabled"			: true
		}	]
}
```

Notice that "authentication" has two sub-properties, "allowDefault" and "authenticators".  The "allowDefault" property, when set to true, tells the security system that if authentication fails for all the specified authenticators to allow OrientDB's default (built-in) authentication mechanism to also try.

The "authenticators" property is an array of authenticator objects.  The order of the authenticators is significant, as the first is the primary authenticator.  Subsequent authenticators in the list are called, if the first authenticator fails.  This continues until either authentication succeeds or the list of authenticators is exhausted.  If the "allowDefault" property is true and authentication is being called for a database, then OrientDB's native database security will then be attempted.

Each authenticator object supports at least three properties: "name", "class", and "enabled".

|Property|Description|
|--------|-----------|
|"name"|The "name" property must be unique among the authenticators and can be used by other security components to reference which authenticator is used to authenticate a service.  As an example, the OLDAPImporter component may specify an "authenticator" to use and it must correspond to the "name" property.|
|"class"|The "class" property defines which authenticator component is instantiated for the security authenticator.  The available authenticators are: ODefaultPasswordAuthenticator, OKerberosAuthenticator, OServerConfigAuthenticator, and OSystemUserAuthenticator.  All are described below.|
|"enabled"|When set to true, the authenticator is used as part of the chain of authenticators.  If set to false, the authenticator is ignored.|


### ODefaultPasswordAuthenticator 
*ODefaultPasswordAuthenticator* supports an additional "users" property which contains an array of user objects.  Each user object must contain "user" and "resource" properties.  An optional "password" property is also permitted if authentication using a password is required.
	
Each user object can be used for authorization of the specified resources as well as authentication, if a password is present.
	
The full classpath for the "class" property is "com.orientechnologies.orient.server.security.authenticator.ODefaultPasswordAuthenticator".

Here's an example of the "users" property:

		"users" 				:
		[
			{ "username" : "someuser", "resources" : "*" }
		]

The "resources" property uses the same format as the "resources" property for each `<user>` in the `<users>` section of the orientdb-server-config.xml file.

Additionally, *ODefaultPasswordAuthenticator* supports a "caseSensitive" property.  It defaults to true.  When set to false, usernames are not case-sensitive when retrieved for password or resources look-up.
	
### OServerConfigAuthenticator
*OServerConfigAuthenticator* utilizes the <users> element in the orientdb-server-config.xml file and permits its list of server users to be used for authentication and authorization of resources.  Beyond "name", "class", and "enabled", *OServerConfigAuthenticator* requires no additional properties.
	
The full classpath for the "class" property is "com.orientechnologies.orient.server.security.authenticator.OServerConfigAuthenticator".

*OServerConfigAuthenticator*'s "caseSensitive" property is always false, meaning that usernames are not case-sensitive when retrieved for password or resources look-up.

### OSystemUserAuthenticator
*OSystemUserAuthenticator* implements authentication and authorization support for *system users* that reside in the OrientDB system database.  Beyond "name", "class", and "enabled", *OSystemUserAuthenticator* requires no additional properties.

The full classpath for the "class" property is "com.orientechnologies.orient.server.security.authenticator.OSystemUserAuthenticator".

### OKerberosAuthenticator
*OKerberosAuthenticator* provides support for Kerberos/SPNEGO authentication.  In addition to the usual "name", "class", and "enabled" properties, the *OKerberosAuthenticator* component also supports "debug", "krb5_config", "service", "spnego", and "client" properties.  All of these properties are defined in greater detail below.
	
The full classpath for the "class" property is "com.orientechnologies.security.kerberos.OKerberosAuthenticator".

#### "debug"
When set to true, all of the Kerberos and SPNEGO authentication are displayed in the server's logfile.  This can be very useful when debugging authentication problems.

#### "krb5_config"
By default, the KRB5_CONFIG environment variable is used to tell the Java Kerberos libraries the location of the krb5.conf file.  However, the krb5_config property may be used to override this.

#### "service"
The "service" property contains two sub-properties, "ktname" and "principal".

|Sub-Property|Description|
|------------|-----------|
|"ktname"|This specifies the location of the keytab file used to obtain the key for decrypting OrientDB client service tickets.  By default, the KRB5_KTNAME environment variable is used to determine the location of the server's keytab file.  However, the ktname property may be used to override this.|
|"principal"|This specifies the LDAP/AD user that's associated with the OrientDB SPN.  This is used to obtain the correct service key to decrypt service tickets from OrientDB clients.  This is a mandatory property.|


#### "spnego"
The "spnego" property contains two sub-properties, "ktname" and "principal".
		
|Sub-Property|Description|
|------------|-----------|
|"ktname"|This specifies the location of the keytab file used to obtain the key for decrypting OrientDB SPNEGO service tickets.  By default (and the same as the "service" property), the KRB5_KTNAME environment variable is used to determine the location of the server's keytab file.  However, the "ktname" property may be used to override this.|
|"principal"|This specifies the LDAP/AD user that's associated with the OrientDB SPN.  This is used to obtain the correct service key to decrypt service tickets from OrientDB SPNEGO clients.  This is a mandatory property.|

#### "client"
The "client" property is used by OrientDB for configuring the LDAP/AD importer user, and it may contain five different sub-properties: "ccname", "ktname", "principal", "useTicketCache", and "renewalPeriod".

|Sub-Property|Description|
|------------|-----------|
|"ccname"|By default, the KRB5CCNAME environment variable is used to determine the location of the local credential cache file.  However, the "ccname" property may be used to override this.  This is only used if "useTicketCache" is set to true.|
|"ktname"|By default, the KRB5_CLIENT_KTNAME environment variable is used to determine the location of the server's client keytab file.  However, the "ktname" property may be used to override this.  This is only used if "useTicketCache" is set to false.|
|"principal"|This is the name of the principal used with the client credentials when accessing the LDAP service.  It is a required property.|
|"useTicketCache"|Defaults to false.  If true, the local ticket cache will be used to provide the client credentials to the LDAP service.  The KRB5CCNAME environment variable is used to determine the location of the ticket cache if the "ccname" property is not specified.  If false (or not present) then the specified keytab file (ktname) is used.|
|"renewalPeriod"|This is an optional property, and it specifies how often the LDAP client service ticket is renewed (in minutes).   It defaults to 5 hours.|
	

## "passwordValidator"
The "passwordValidator" object specifies an optional password validator that the OrientDB security system uses when applying new passwords.  The supported properties of the password validator object depend on the type of object specified but always contain at least "class" and "enabled".  The "class" property defines which password validator component is instantiated.  The "enabled" property (defaults to true) specifies whether the password validator component is active or not.

OrientDB ships with an *ODefaultPasswordValidator* component.  Its properties are defined below, and each is only required if it's included in the "passwordValidator" property.

The full classpath for the "class" property is "com.orientechnologies.security.password.ODefaultPasswordValidator".

### ODefaultPasswordValidator

|Property|Description|
|--------|-----------|
|"minimumLength"|This property defines the minimum number of characters required in the password.|
|"numberRegEx"|This property defines the regular expression for the minimum count of required numbers and what symbols are considered numbers.|
|"uppercaseRegEx"|This property defines the regular expression for the minimum count of required uppercase characters and what symbols are considered uppercase characters.|
|"specialRegEx"|This property defines the regular expression for the minimum count of special characters and what symbols are considered special characters.|

Here is an example of the *ODefaultPasswordValidator*'s configuration in the security.json file:
	
	"passwordValidator" :
	{
		"class"				: "com.orientechnologies.security.password.ODefaultPasswordValidator",
		"minimumLength"		: 5,
		"numberRegEx"		: "(?:[0-9].*){2}",
		"uppercaseRegEx"	: "(?:[A-Z].*){3}",
		"specialRegEx"		: "(?:[^a-zA-Z0-9 ].*){2}"
	}
	

## "ldapImporter"
The "ldapImporter" object defines the properties for the LDAP importer security component.  As with the other security components, the LDAP importer object always has a "class" property and optional "enabled" and "debug" properties.  The "class" property defines which LDAP importer component is instantiated.  The "enabled" property (defaults to true) specifies whether the LDAP importer component is active or not.

OrientDB provides a default OLDAPImporter component, and its properties are defined below.  The full classpath for the "class" property is "com.orientechnologies.security.ldap.OLDAPImporter".

### OLDAPImporter
|Property|Description|
|--------|-----------|
|"period"|This property is in seconds and determines how often the LDAP synchronization occurs.|
|"databases"|This property contains an array of objects.  Each object represents an OrientDB database along with LDAP domains to import.|

#### Database Object 
Each database object contains three properties: "database", "ignoreLocal", and "domains".  The "database" property is just the name of the OrientDB database.  The "ignoreLocal" property is an optional boolean property that defaults to true.  When true it indicates that existing users in the specified database will not be deleted if they are not present in the imported LDAP users list.  The "domains" property is described below.

##### "domains" 
The "domains" property contains an array of objects, each with "domain", "servers", and "users" properties, and an optional "authenticator" property.

|Property|Description|
|--------|-----------|
|"domain"|This property must be unique for each database object and is primarily used with the *_OLDAPUser* class within each OrientDB database.|
|"authenticator"|The "authenticator" property specifies which of the authenticators should be used to communicate with the LDAP server.  If none is specified, then the primary authenticator is used.|
|"servers"|This property is an array of server objects, each specifying the URL of the LDAP server.  It is described below.|
|"users"|This property is an array of user objects, each specifying the baseDN, filter, and roles to use for importing.  It is described below.|  

###### "servers"
|Property|Description|
|--------|-----------|
|"url"|This property specifies the LDAP server's URL.  (ldaps is supported.)|
|"isAlias"|This is a boolean property.  When true, the hostname specified in the URL is treated as an alias, and the real address is queried followed by a reverse DNS lookup.  This is useful for a hostname that is an alias for multiple LDAP servers.  The "isAlias" property defaults to false and is not a mandatory property.|

###### "users"
LDAP users are imported based on a starting location within the directory and filtered using a standard LDAP filter rule.

|Property|Description|
|--------|-----------|
|"baseDN"|The "basedDN" property specifies the distinguished name of the starting point for the LDAP import, e.g., "CN=Users,DC=ad,DC=domain,DC=com".|
|"filter"|This property specifies the LDAP filter to use for importing users.  Here's a simple example: "(&(objectCategory=person)(objectclass=user)(memberOf=CN=ODBUser,CN=Users,DC=ad,DC=domain,DC=com))".|
|"roles"|This is an array of strings, specifying the corresponding OrientDB roles that will be assigned to each user that is imported from the current group.|

As an alternative to the "users" property in the security configuration file, *OLDAPImporter* also supports using a class in the database, called *_OLDAPUser*, for importing LDAP users based on the same properties.  See below for more details.

### Example
Here's an example of the "ldapImporter" property:

```	
"ldapImporter" :
{
	"class"		: "com.orientechnologies.security.ldap.OLDAPImporter",
	"enabled"	: true,
	"debug"		: false,
	"period"	: 60,
	"databases" :
	[
		{
			"database"		: "MyDB",
			"ignoreLocal"	: true,
			"domains"		: 
			[
				{
					"domain"		: "ad.domain.com",
					"authenticator" : "Kerberos",
					
					"servers"	:
					[
						{
							"url"		: "ldap://alias.ad.domain.com:389",
							"isAlias"	: true
						}
					],
					
					"users" :
					[
						{
							"baseDN"	: "CN=Users,DC=ad,DC=domain,DC=com",
							"filter"	: "(&(objectCategory=person)(objectclass=user)(memberOf=CN=ODBUser,CN=Users,DC=ad,DC=domain,DC=com))",
							"roles"		: ["reader", "writer"]
						},
						{
							"baseDN"	: "CN=Users,DC=ad,DC=domain,DC=com",
							"filter"	: "(&(objectCategory=person)(objectclass=user)(memberOf=CN=ODBAdminGroup,CN=Users,DC=ad,DC=domain,DC=com))",
							"roles"		: ["admin"]
						}
					]
				}
			]
		}
	]
}
```

### *_OLDAPUser* Class ###
The OrientDB *_OLDAPUser* class can be used in place of or in addition to the "users" section of "ldapImporter".

The class has four properties defined: *Domain*, *BaseDN*, *Filter*, and *Roles*. 

|Property|Description|
|--------|-----------|
|Domain|The *Domain* property must match the "domain" property of a domain object in the "domains" array of an "ldapImporter" database object.|
|BaseDN|This property is equivalent to the "baseDN" property of a user object in the "users" array.|
|Filter|This property is equivalent to the "filter" property of a user object in the "users" array.|
|Roles|The *Roles* property is equivalent to the "roles" array of a user object in the "users" array.  However, the value of *Roles* is a single string, and each role is separated by a comma.|


## "auditing"
The *auditing* component of the new security system is configured with the "auditing" object.  It has two properties, the usual "class" and "enabled" properties.

## "syslog"
The "syslog" component can be configured with these properties.

|Property|Description|
|--------|-----------|
|"class"|The "class" property defines which component is instantiated for the *syslog* object.  The default class for the *syslog* component is "com.orientechnologies.security.syslog.ODefaultSyslog".|
|"enabled"|When set to true, the *syslog* component is used in conjunction with the regular OrientDB auditing log.|
|"hostname"|This property specifies the name or address of the *syslog* daemon.|
|"port"|The "port" property specifies which UDP port to use when communicating with the *syslog* daemon.  The default *syslog* port of 514 is used if "port" is not specified.|
|"appName"|This property indicates what *application name* is displayed in the *syslog* output.  By default, it's set to "OrientDB".| 

Here's an example of the "syslog" configuration:
```
"syslog" :
{
	"class"		: "com.orientechnologies.security.syslog.ODefaultSyslog",
	"enabled"	: true,
	"hostname"	: "localhost",
	"port"		: 514,
	"appName"	: "OrientDB"
}
```
