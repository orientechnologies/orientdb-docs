
# OrientDB Kerberos Client Examples

The Java API client is dependent on the *KRB5_CONFIG* and *KRB5CCNAME* environment variables being set.  Alternatively, you can pass them to the Java program via `-Dclient.krb5.config=…` and `-Dclient.krb5.ccname=…`, respectively.  You can also set them in your Java client program by calling `System.setProperty("client.krb5.config", "…./krb5.conf")`.

If a keytab is preferred, the *KRB5_CLIENT_KTNAME* environment variable may be set with the path to the keytab.  Alternatively, you may pass the keytab path as the system property *client.krb5.ktname*.

What enables the Kerberos client support is a system property called *client.credentialinterceptor*.  This must be set with the full package name to the Kerberos credential interceptor, as such:

`java -Dclient.credentialinterceptor=com.orientechnologies.orient.core.security.kerberos.OKerberosCredentialInterceptor`
	
or
	
`System.setProperty("client.credentialinterceptor", "com.orientechnologies.orient.core.security.kerberos.OKerberosCredentialInterceptor");`


In either case, this system property must be set to enable the Java client Kerberos support.

To use the client, you must specify the principal in the *username* field.  The *password* field may also specify the SPN to use to retrieve the service ticket, but if left as an empty string, then the SPN will be generated from the host portion of the URL as such: "OrientDB/" + host.

The principal must either exist as a server user or must exist as an OUser record in the database to be accessed.


## Java API Examples
The following is an example of how to use the OServerAdmin interface to send commands directly to the server:

	String url = "remote:server1.ad.somedomain.com:2424";
	String pri = "OrientDBClient@AD.SOMEDOMAIN.COM";
	String spn = "OrientDB/db1.somedomain.com";

	OrientDB orientDB = new OrientDB(url, pri, spn, OrientDBConfig.defaultConfig());
	orientDB.create("TestDB", ODatabaseType.PLOCAL);
	orientDB.close();

The next example shows how to open an existing OrientDB database from the Java client API:

	String url = "remote:server1.ad.somedomain.com:2424";
	String pri = "OrientDBClient@AD.SOMEDOMAIN.COM";
	String spn = "OrientDB/db1.somedomain.com";
	
	OrientDB orientDB = new OrientDB(url, OrientDBConfig.defaultConfig());
	ODatabaseSession db = orientDB.open("TestDB", pri, spn, ODatabaseType.PLOCAL);
	db.close();
	orientDB.close();


## JDBC Client
The JDBC client support is very similar to the native OrientDB Java client.  Make sure the *KRB5_CONFIG* and *KRB5CCNAME* environment variables (or system properties) are set accordingly and then set the *client.credentialinterceptor* system property and specify the URL, principal, and SPN appropriately:

	System.setProperty("client.credentialinterceptor", "com.orientechnologies.orient.core.security.kerberos.OKerberosCredentialInterceptor");
	
	String url = "remote:server1.ad.somedomain.com:2424/TestDB";
	String pri = "OrientDBClient@AD.SOMEDOMAIN.COM";
	String spn = "OrientDB/db1.somedomain.com";
	
	Class.forName("com.orientechnologies.orient.jdbc.OrientJdbcDriver");
	
	Properties info = new Properties();
	info.put("user", pri);
	info.put("password", spn);
	
	Connection conn = (OrientJdbcConnection) DriverManager.getConnection(url, info);
	
	Statement stmt = conn.createStatement();
	
	ResultSet rs = stmt.executeQuery("select from MyClass");
	

## OrientDB Console
To enable Kerberos in the OrientDB console, you'll need to modify the console.sh (or console.bat) script.

Simply add the credential interceptor system property to ORIENTDB_SETTINGS as such:

	ORIENTDB_SETTINGS="-Dclient.credentialinterceptor=com.orientechnologies.orient.core.security.kerberos.OKerberosCredentialInterceptor"
	
Here's an example of connecting to the previously used URL, principal, and SPN:

	connect remote:server1.ad.somedomain.com:2424 OrientDBClient@AD.SOMEDOMAIN.COM OrientDB/db1.somedomain.com
	
Here's another example, this time creating a remote plocal database on remote server:
	
	create database remote:server1.ad.somedomain.com:2424/NewDB OrientDBClient@AD.SOMEDOMAIN.COM OrientDB/db1.somedomain.com plocal
	
Lastly, this final example with the console shows connecting to the NewDB database that we just created:

	connect remote:server1.ad.somedomain.com:2424/NewDB OrientDBClient@AD.SOMEDOMAIN.COM OrientDB/db1.somedomain.com

