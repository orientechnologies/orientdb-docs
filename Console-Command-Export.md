# Console - `EXPORT`

Exports the current database to a file.  OrientDB uses a JSON-based [Export Format](Export-Format.md).  By default, it compresses the file using the GZIP algorithm.  

With the [`IMPORT`](Console-Command-Import.md) command, this allows you to migrate the database between different versions of OrientDB without losing data.  

>If you receive an error about the database version, export the database using the same version of OrientDB that has generated the database.

Bear in mind, exporting a database browses it, rather than locking it.  While this does mean that concurrent operations can execute during the export, it also means that you cannot create an exact replica of the database at the point when the command is issued.  In the event that you need to create a snapshot, use the [`BACKUP`](Console-Command-Backup.md) command.

You can restore a database from an export using the [`IMPORT`](Console-Command-Import.md).

>**NOTE**: While the export format is JSON, there are some constraints in the field order.  Editing this file or adjusting its indentation may cause imports to fail.

**Syntax**

By default, this command exports the full database.  Use its options to disable the parts you don't need to export.

```sql
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

- **`<output-file>`** Defines the path to the output file.
- **`-excludeAll`** Sets the export to exclude everything not otherwise included through command options
- **`-includeClass`** Export includes certain classes, specifically those defined by a space-separated list.
- **`-excludeClass`** Export excludes certain classes, specifically those defined by a space-separated list.
- **`-includeCluster`** Export includes certain clusters, specifically those defined by a space-separated list.
- **`-excludeCluster`** Export excludes certain clusters, specifically those defined by a space-separated list.
- **`-includeInfo`** Defines whether the export includes database information.
- **`-includeClusterDefinitions`** Defines whether the export includes cluster definitions.
- **`-includeSchmea`** Defines whether the export includes the database schema.
- **`-includeSecurity`** Defines whether the export includes database security parameters.
- **`-includeRecords`** Defines whether the export includes record contents.
- **`-includeIndexDefinitions`** Defines whether the export includes the database index definitions.
- **`-includeManualIndexes`** Defines whether the export includes manual index contents.
- **`-compressionLevel`** Defines the compression level to use on the export, in a range between `0` (no compression) and `9` (maximum compression).  The default is `1`.  (Feature introduced in version 1.7.6.)
- **`-compressionBuffer`** Defines the compression buffer size in bytes to use in compression.  The default is 16kb.  (Feature introduced in version 1.7.6.)

**Examples**

- Export the current database, including everything:

  <pre>
  orientdb> <code class='lang-sql userinput'>EXPORT DATABASE C:\temp\petshop.export</code>

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
  </pre>

- Export the current database, including only its functions:

  <pre>
  orientdb> <code class='lang-sql userinput'>EXPORT DATABASE functions.gz -includeClass=OFunction -includeInfo=FALSE 
            -includeClusterDefinitions=FALSE -includeSchema=FALSE 
            -includeIndexDefinitions=FALSE -includeManualIndexes=FALSE</code>
  </pre>

- Alternatively, you can simplify the above by excluding all, then including only those features that you need.  For instance, export the current database, including only the schema:

  <pre>
  orientdb> <code class='lang-sql userinput'>EXPORT DATABASE schema.gz -excludeALL -includeSchmea=TRUE</code>
  </pre>


## Export API

In addition to the Console, you can also trigger exports through Java and any other language that runs on the JVM, by using the [ODatabaseExport](https://github.com/orientechnologies/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/db/tool/ODatabaseExport.java) class. 

For example: 

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

>For more information on backups and restores, imports and exports, see the following commands:
>- [IMPORT DATABASE](Console-Command-Import.md)
>- [BACKUP DATABASE](Console-Command-Backup.md)
>- [RESTORE DATABASE](Console-Command-Restore.md)
>
>as well as the following pages:
>- [Export File Format](Export-Format.md)
>- [`ODatabaseExport`](https://github.com/orientechnologies/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/db/tool/ODatabaseExport.java)
 Java Class
>
>For more information on other commands, see [Console Commands](Console-Commands.md).