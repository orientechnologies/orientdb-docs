# Export & Import

OrientDB supports export and import operations like any RDBMS.

The Export command exports the current opened database to a file. The exported file is in [JSON](http://en.wikipedia.org/wiki/JSON) format using the [Export-Format](Export-Format.md). By default the file is compressed using the GZIP algorithm. The EXPORT/[IMPORT](Console-Command-Import.md) commands allow to migrate the database between different releases of OrientDB without loosing data. If you receive an error about the database version, export the database using the same version of OrientDB that has generated the database.

Export doesn't lock your database, but browses it. This means that concurrent operation can be executed during the export, but the exported database couldn't be the exact replica when you issued the command because concurrent updates could occurs. If you need a snapshot of database at a point in a time, please use [BACKUP](Console-Command-Backup.md).

Once exported, use the [IMPORT](Console-Command-Import.md) to restore it. The database will be imported and will be ready to be used. Look also to [BACKUP DATABASE](Console-Command-Backup.md) and [RESTORE DATABASE](Console-Command-Restore.md) commands.

## When to use backup and when export?
Backup does a consistent copy of database, all further write operations are locked waiting to finish it. The database is in read-only mode during backup operation. If you need an read/write database during backup setup a distributed cluster of nodes.

Export, instead, doesn't lock the database and allow concurrent writes during the export process. This means the exported database could have changes executed during the export.

_NOTE: Even if the file is 100% JSON, there are some constraints in the JSON format, where the field order must be kept. If you prettify the file, the import couldn't work anymore._

## Export Example

```
orientdb> EXPORT DATABASE /temp/petshop.export

Exporting current database to: /temp/petshop.export...

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


## Import Example

```
> IMPORT DATABASE /temp/petshop.export -preserveClusterIDs=true
Importing records...
- Imported records into the cluster 'internal': 5 records
- Imported records into the cluster 'index': 4 records
- Imported records into the cluster 'default': 1022 records
- Imported records into the cluster 'orole': 3 records
- Imported records into the cluster 'ouser': 3 records
- Imported records into the cluster 'csv': 100 records
- Imported records into the cluster 'binary': 101 records
- Imported records into the cluster 'account': 1005 records
- Imported records into the cluster 'company': 9 records
- Imported records into the cluster 'profile': 9 records
- Imported records into the cluster 'whiz': 1000 records
- Imported records into the cluster 'address': 164 records
- Imported records into the cluster 'city': 55 records
- Imported records into the cluster 'country': 55 records
- Imported records into the cluster 'animalrace': 3 records
- Imported records into the cluster 'ographvertex': 102 records
- Imported records into the cluster 'ographedge': 101 records
- Imported records into the cluster 'graphcar': 1 records
```


## See also
- [Export-Format](Export-Format.md)
- [RESTORE DATABASE](Console-Command-Restore.md)
- [EXPORT DATABASE](Console-Command-Export.md)
- [IMPORT DATABASE](Console-Command-Import.md)
- [Console-Commands](Console-Commands.md)
