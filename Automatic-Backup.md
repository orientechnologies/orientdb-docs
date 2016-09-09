---
search:
   keywords: ['server', 'plugin', 'automatic backup', 'backup']
---

# Automatic Backup Server Plugin

Using this server plugin, OrientDB executes regular backups on the databases.  It implements the Java class:

```java
com.orientechnologies.orient.server.handler.OAutomaticBackup
```


## Plugin Configuration

Beginning with version 2.2, OrientDB manages the server plugin configuration from a separate JSON.  You can update this file manually or through OrientDB Studio.

To enable automatic backups, use the following `<handler>` section in the `config/orientdb-server-config.xml` configuration file:

```xml
<!-- AUTOMATIC BACKUP, TO TURN ON SET THE 'ENABLED' PARAMETER TO 'true' -->
<handler class="com.orientechnologies.orient.server.handler.OAutomaticBackup">
    <parameters>
        <parameter name="enabled" value="false"/>
        <!-- LOCATION OF JSON CONFIGURATION FILE -->
        <parameter name="config" value="${ORIENTDB_HOME}/config/automatic-backup.json"/>
    </parameters>
</handler>
```

This section tells the OrientDB server to read the file at `$ORIENTDB_HOME/config/automatic-backup.json` for the automatic backup configuration.

```json
{
  "enabled": true,
  "mode": "FULL_BACKUP",
  "exportOptions": "",
  "delay": "4h",
  "firstTime": "23:00:00",
  "targetDirectory": "backup",
  "targetFileName": "${DBNAME}-${DATE:yyyyMMddHHmmss}.zip",
  "compressionLevel": 9,
  "bufferSize": 1048576
}
```

- **`"enabled"`** Defines whether it uses automatic backups.  The supported values are:
  - *`true`* Enables automatic backups.
  - *`false`* Disables automatic backups.  This is the default setting.
- **`"mode"`** Defines the backup mode.  The supported values are:
  - *`"FULL_BACKUP"`* Executes a full backup.  Prior to version 2.2, this was the only mode available.  This operation blocks the database.
  - *`"INCREMENTAL_BACKUP"`* Executes an [incremental backup](Incremental-Backup-And-Restore.md).  This is available only in the [Enterprise Edition](Enterprise-Edition.md).  It uses one directory per database.  This operation doesn't block the database.
  - *`"EXPORT"`* Executes an database export, using gziped JSON format. This operation is not blocking.
- **`"exportOptions"`** Defines export options to use with that mode.  This feature was introduced in version 2.2.
- **`"delay"`** Defines the delay time for each backup.  Supports the following suffixes:
  - *`ms`* Delay measured in milliseconds.
  - *`s`* Delay measured in seconds.
  - *`m`* Delay measured in minutes.
  - *`h`* Delay measured in hours.
  - *`d`* Delay measured in days.
- **`"firstTime"`** Defines when to initiate the first backup in the schedule.  It uses the format of `HH:mm:ss` in the GMT time zone, on the current day.
- **`"targetDirectory"`** Defines the target directory to write backups.  By default, it is set to the `backup/` directory.
- **`"targetFileName"`** Defines the target filename.  This parameter supports the use of the following variables, (that is, `"${DBNAME}-backup.zip"` produces `mydatabase-backup.zip`):
  - *`${DBNAME}`* Renders the database name.
  - *`${DATE}`* Renders the current date, using the [Java DateTime syntax](http://download.oracle.com/javase/1,5.0/docs/api/java/text/SimpleDateFormat.html) format.
- **`"dbInclude"`** Defines in a list the databases to include in the automatic backups.  If empty, it backs up all databases.
- **`"dbExclude"`** Defines in a list the databases to exclude from the automatic backups.
- **`"bufferSize"`** Defines the in-memory buffer sizes to use in compression.  By default, it is set to `1MB`.  Larger buffers mean faster backups, but they in turn consume more RAM.
- **`"compressionLevel"`** Defines the compression level for the resulting ZIP file.  By default it is set to the maximum level of `9`.  Set it to a lower value if you find that the backup takes too much time.


## Legacy Plugin Configuration

In versions prior to 2.2, the only option in configuring automatic backups is to use the `config/orientdb-server-config.xml` configuration file.   Beginning with version 2.2 you can manage automatic backup configuration through a separate JSON file or use the legacy approach.

The example below configures automatic backups/exports on the database as a [Server Plugin](DB-Server.md#handlers).


```xml
<!-- AUTOMATIC BACKUP, TO TURN ON SET THE 'ENABLED' PARAMETER TO 'true' -->
<handler class="com.orientechnologies.orient.server.handler.OAutomaticBackup">
  <parameters>
    <parameter name="enabled" value="false" />
     <!-- CAN BE: FULL_BACKUP, INCREMENTAL_BACKUP, EXPORT -->
     <parameter name="mode" value="FULL_BACKUP"/>
     <!-- OPTION FOR EXPORT -->
     <parameter name="exportOptions" value=""/>
    <parameter name="delay" value="4h" />
    <parameter name="target.directory" value="backup" />
    <!-- ${DBNAME} AND ${DATE:} VARIABLES ARE SUPPORTED -->
    <parameter name="target.fileName" value="${DBNAME}-${DATE:yyyyMMddHHmmss}.zip" />
    <!-- DEFAULT: NO ONE, THAT MEANS ALL DATABASES. 
	     USE COMMA TO SEPARATE MULTIPLE DATABASE NAMES -->
    <parameter name="db.include" value="" />
    <!-- DEFAULT: NO ONE, THAT MEANS ALL DATABASES. 
	     USE COMMA TO SEPARATE MULTIPLE DATABASE NAMES -->
    <parameter name="db.exclude" value="" />
    <parameter name="compressionLevel" value="9"/>
    <parameter name="bufferSize" value="1048576"/>
  </parameters>
</handler>
```


- **`enabled`** Defines whether it uses automatic backups.  Supported values are:
  - *`true`* Enables automatic backups.
  - *`false`* Disables automatic backups.  This is the default setting.
- **`mode/>`** Defines the backup mode.  Supported values are:
  - *`FULL_BACKUP`* Executes a full backup.  For versions prior to 2.2, this is the only option available.  This operation blocks the database.
  - *`INCREMENTAL_BACKUP`* Executes an incremental backup.  Uses one directory per database.  This operation doesn't block the database.
  - *`EXPORT` Executes an export of the database in gzipped JSON format, instead of a backup.  This operation doesn't block the database.
- **`exportOptions`** Defines export options to use with that mode.  This feature was introduced in version 2.2.
- **`delay`** Defines the delay time.  Supports the following suffixes:
  - *`ms`* Delay measured in milliseconds.
  - *`s`* Delay measured in seconds.
  - *`m`* Delay measured in minutes.
  - *`h`* Delay measured in hours.
  - *`d`* Delay measured in days.
- **`firstTime`** Defines when to initiate the first backup in the schedule.  It uses the format of `HH:mm:ss` in the GMT time zone, on the current day.
- **`target.directory`** Defines the target directory to write backups.  By default, it is set to the `backup/` directory.
- **`target.fileName`** Defines the target file name.  The parameter supports the use of the following variables, (that is, `<parameter name="target.filename" value="${DBNAME}-backup.zip"/>` produces a `mydatabase-backup.zip` file).
  - *`${DBNAME}`* Renders the database name.
  - *`${DATE}`* Renders the current date, using the [Java DateTime syntax](http://download.oracle.com/javase/1,5.0/docs/api/java/text/SimpleDateFormat.html) format.
- **`db.include`** Defines in a list the databases to include in the automatic backups.  If left empty, it backs up all databases.
- **`db.exclude`** Defines in a list the databases to exclude from automatic backups.
- **`bufferSize`** Defines the in-memory buffer sizes to use in compression.  By default it is set to `1MB`.  Larger buffers mean faster backups, but use more RAM.  This feature was introduced in version 1.7.
- **`compressionLevel`** Defines the compression level for the resulting ZIP file.  By default, it is set to the maximum level of `9`.  Set it to a lower value if you find that the backup takes too much time.


