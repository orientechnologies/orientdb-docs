
# Introduction to OrientDB Studio 

People have different preferences to how they would like to interact with a database.  Some prefer to work through an application, some through an API, some a console.  OrientDB _Studio_ is for those who are most comfortable operating on databases through a graphical user interface.

When you start the OrientDB Server, the JVM also runs Studio on port 2480.  Running OrientDB on your local system, you can access it through the web browser by navigating to [http://localhost:2480](http://localhost:2480).  To access Studio on a remote machine, you may want to use an SSH tunnel for better security.

![Home Page](../images/studio/studio-login.png)

From the Studio Home Page, you can:

* [Connect](working-with-databases/Studio-Common-Database-Operations.md#connecting-to-an-existing-database) to an existing database
* [Create](working-with-databases/Studio-Common-Database-Operations.md#creating-a-new-database) a new database
* [Import](working-with-databases/Studio-Common-Database-Operations.md#importing-a-public-database) a public (OrientDB) database
* [Drop](working-with-databases/Studio-Common-Database-Operations.md#dropping-an-existing-database) an existing database
* [Start a migration](backups-imports-exports/Studio-Teleporter.md) to OrientDB using the tool Teleporter
* Access the [Server Management](server-management/README.md) features
