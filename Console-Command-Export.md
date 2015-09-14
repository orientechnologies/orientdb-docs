# Console - EXPORT

Exports the current opened database to a file. The exported file is in [JSON](http://en.wikipedia.org/wiki/JSON) format using the [Export-Format](Export-Format.md). By default the file is compressed using the GZIP algorithm. The EXPORT/[IMPORT](Console-Command-Import.md) commands allow to migrate the database between different releases of OrientDB without loosing data. If you receive an error about the database version, export the database using the same version of OrientDB that has generated the database.

Export doesn't lock your database, but browses it. This means that concurrent operation can be executed during the export, but the exported database couldn't be the exact replica when you issued the command because concurrent updates could occurs. If you need a snapshot of database at a point in a time, please use [BACKUP](Console-Command-Backup.md).

Once exported, use the [IMPORT](Console-Command-Import.md) to restore it. The database will be imported and will be ready to be used. Look also to [BACKUP DATABASE](Console-Command-Backup.md) and [RESTORE DATABASE](Console-Command-Restore.md) commands.

>NOTE: Even if the file is 100% JSON, there are some constraints in the JSON format, where the field order must be kept. If you prettify the file, the import couldn't work anymore.

## Syntax
By default the export command exports the full database, but there are some flags to disable some parts.

```
EXPORT DATABASE <output-file>
      [-excludeAll]
      [-includeClass=<class-name>*]
      [-excludeClass=<class-name>*]
      [-includeCluster=<cluster-name>*]
      [-excludeCluster=<cluster-name>*]
      [-includeInfo=<true|false>]
      [-includeClusterDefinitions=<true|false>]
      [-includeSchema=<true|false>]
      [-includeSecurity=<true|false>]
      [-includeRecords=<true|false>]
      [-includeIndexDefinitions=<true|false>]
      [-includeManualIndexes=<true|false>]
      [-compressionLevel=<0-9>]
      [-compressionBuffer=<bufferSize>]
```

Where:
- **output-file** is the output file path
- **-excludeAll** exclude everything. This is useful to export only few things. Instead of exclude all the feature it's much easier exclude all, and include what you're interested. Example: ```"-excludeAll -includeSchema=true"``` to export the schema only. Available since v1.7.
- **-includeClass** includes few classes to export. Class names must be separated by spaces
- **-excludeClass** excludes few classes to export. Class names must be separated by spaces
- **-includeCluster** includes few clusters to export. Cluster names must be separated by spaces
- **-excludeCluster** excludes few clusters to export. Cluster names must be separated by spaces
- **-includeInfo** includes or not database's information
- **-includeClusterDefinitions** includes or not definitions of clusters
- **-includeSchema** includes or not the database's schema
- **-includeSecurity** includes or not database's security
- **-includeRecords** includes or not record contents
- **-includeIndexDefinitions** includes or not database's index definition
- **-includeManualIndexes** includes or not manual index contents
- **-compressionLevel** set the compression level between 0 (=no compression) and 9 (maximum compression). Default is 1 (since 1.7.6)
- **-compressionBuffer** Set the buffer size in bytes used by compression. By default is 16Kb (since 1.7.6)

## Examples ##

### Export the entire database ###
```
orientdb> EXPORT DATABASE C:\temp\petshop.export

Exporting current database to: C:\temp\petshop.export...

Exporting database info...OK
Exporting dictionary...OK
Exporting schema...OK
Exporting clusters...
- Exporting cluster 'metadata' (records=11) -> ...........OK
- Exporting cluster 'index' (records=0) -> OK
- Exporting cluster 'default' (records=779) -> OK
- Exporting cluster 'csv' (records=1000) -> OK
- Exporting cluster 'binary' (records=1001) -> OK
- Exporting cluster 'person' (records=7) -> OK
- Exporting cluster 'animal' (records=5) -> OK
- Exporting cluster 'animalrace' (records=0) -> OK
- Exporting cluster 'animaltype' (records=1) -> OK
- Exporting cluster 'orderitem' (records=0) -> OK
- Exporting cluster 'order' (records=0) -> OK
- Exporting cluster 'city' (records=3) -> OK
Export of database completed.
```
### Export the database's functions only ###
```
orientdb> EXPORT DATABASE functions.gz -includeClass=OFunction
                 -includeInfo=false
                 -includeClusterDefinitions=false
                 -includeSchema=false
                 -includeIndexDefinitions=false
                 -includeManualIndexes=false
```

## Export API
Export command can be used in Java and any language on top of the JVM by using the class [ODatabaseExport](https://github.com/orientechnologies/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/db/tool/ODatabaseExport.java). Example:

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/temp/mydb");
db.open("admin", "admin");
try{
  OCommandOutputListener listener = new OCommandOutputListener() {
    @Override
    public void onMessage(String iText) {
      System.out.print(iText);
    }
  };

  ODatabaseExport export = new ODatabaseExport(db, "/temp/export", listener);
  export.exportDatabase();
  export.close();
} finally {
  db.close();
}
```

## See also
- [Export File Format](Export-Format.md)
- [IMPORT DATABASE](Console-Command-Import.md)
- [BACKUP DATABASE](Console-Command-Backup.md)
- [RESTORE DATABASE](Console-Command-Restore.md)
- [Console Commands](Console-Commands.md)
- [ODatabaseExport Java class](https://github.com/orientechnologies/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/db/tool/ODatabaseExport.java)
