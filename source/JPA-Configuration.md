# JPA

There are two ways to configure OrientDB JPA

## Configuration
The first - do it through /META-INF/persistence.xml
Folowing OrientDB properties are supported as for now:

*javax.persistence.jdbc.url, javax.persistence.jdbc.user, javax.persistence.jdbc.password, com.orientdb.entityClasses*

You can also use *&lt;class&gt;* tag

Example:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence version="2.0"
	xmlns="http://java.sun.com/xml/ns/persistence" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://java.sun.com/xml/ns/persistence http://java.sun.com/xml/ns/persistence/persistence_2_0.xsd">
	<persistence-unit name="appJpaUnit">
		<provider>com.orientechnologies.orient.object.jpa.OJPAPersistenceProvider</provider>

		<!-- JPA entities must be registered here -->
		<class>com.example.domain.MyPOJO</class>

		<properties>
			<property name="javax.persistence.jdbc.url" value="remote:localhost/test.odb" />
			<property name="javax.persistence.jdbc.user" value="admin" />
			<property name="javax.persistence.jdbc.password" value="admin" />
			<!-- Register whole package.
                             See com.orientechnologies.orient.core.entity.OEntityManager.registerEntityClasses(String) for more details -->
			<property name="com.orientdb.entityClasses" value="com.example.domains" />
		</properties>
	</persistence-unit>
</persistence>
```
## Programmatic
The second one is programmatic:

### Guice example

```java
com.google.inject.persist.jpa.JpaPersistModule.properties(Properties)
```

```java
/**
 * triggered as soon as a web application is deployed, and before any requests
 * begin to arrive
 */
@WebListener
public class GuiceServletConfig extends GuiceServletContextListener {
	@Override
	protected Injector getInjector() {
		return Guice.createInjector(
                        new JpaPersistModule("appJpaUnit").properties(orientDBProp),
                        new ConfigFactoryModule(),
                        servletModule);
	}

	protected static final Properties orientDBProp = new Properties(){{
		setProperty("javax.persistence.jdbc.url", "remote:localhost/test.odb");
		setProperty("javax.persistence.jdbc.user", "admin");
		setProperty("javax.persistence.jdbc.password", "admin");
		setProperty("com.orientdb.entityClasses", "com.example.domains");
	}};

	protected static final ServletModule servletModule = new ServletModule() {
		@Override
		protected void configureServlets() {
			filter("/*").through(PersistFilter.class);
			// ...
	};
}
```

### Native example
```java
// OPEN THE DATABASE
OObjectDatabaseTx db = new OObjectDatabaseTx ("remote:localhost/petshop").open("admin", "admin");

// REGISTER THE CLASS ONLY ONCE AFTER THE DB IS OPEN/CREATED
db.getEntityManager().registerEntityClasses("foo.domain");
```

DB properties, that were passed programmatically, will overwrite parsed from XML ones


## Note
Config parser checks persistence.xml with validation schemes (XSD), so configuration file must be valid.

[1.0](https://github.com/orientechnologies/orientdb/blob/develop/object/src/main/resources/META-INF/persistence/persistence_1_0.xsd), [2.0](https://github.com/orientechnologies/orientdb/blob/develop/object/src/main/resources/META-INF/persistence/persistence_2_0.xsd) and [2.1](https://github.com/orientechnologies/orientdb/blob/develop/object/src/main/resources/META-INF/persistence/persistence_2_1.xsd) XSD schemes are supported.
