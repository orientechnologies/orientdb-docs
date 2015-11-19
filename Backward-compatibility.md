#Backward Compatibility
____

OrientDB supports binary compatibility between previous releases and latest release.
Binary compatibility is supported at least between last 2 minor versions.

For example, lets suppose that we have following releases 1.5, 1.5.1, 1.6.1, 1.6.2, 1.7, 1.7.1 then binary compatibility at least between 1.6.1, 1.6.2, 1.7, 1.7.1 releases will be supported.

If we have releases 1.5, 1.5.1, 1.6.1, 1.6.2, 1.7, 1.7.1, 2.0  then binary compatibility will be supported at least between releases 1.7, 1.7.1, 2.0.

Binary compatibility feature is implemented using following algorithm:
1. When storage is opened, version of binary format which is used when storage is created is read from storage configuration.
2. Factory of objects are used to present disk based data structures for current binary format is created.

Only features and database components which were exist at the moment when current binary format was latest one will be used. It means that you can not use all database features available in latest release if you use storage which was created using old binary format version. It also means that bugs which are fixed in new versions may be (but may be not) reproducible on storage created using old binary format.

To update binary format storage to latest one you should export database in JSON format and import it back.
Using either console commands [export database](Console-Command-Export.md) and [import database](Console-Command-Import.md) or Java API look at `com.orientechnologies.orient.core.db.tool.ODatabaseImport`, `com.orientechnologies.orient.core.db.tool.ODatabaseExport` classes and `com.orientechnologies.orient.test.database.auto.DbImportExportTest` test.

+ Current binary format version can be read from `com.orientechnologies.orient.core.db.record.OCurrentStorageComponentsFactory#binaryFormatVersion` proporty.
+ Instance of `OCurrentStorageComponentsFactory` class can be retrieved by call of `com.orientechnologies.orient.core.storage.OStorage#getComponentsFactory` method. 
+ Latest binary format version can be read from here `com.orientechnologies.orient.core.config.OStorageConfiguration#CURRENT_BINARY_FORMAT_VERSION`.

Please note that binary compatibility is supported since __1.7-rc2__ version for plocal storage (as exception you can read database created in 1.5.1 version by 1.7-rc2 version).

Return to [Upgrade](Upgrade.md).
