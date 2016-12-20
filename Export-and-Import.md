---
search: 
   keywords: ['export', 'import']
---

# Export and Import

OrientDB supports export and import operations, like any database management system.

The [`EXPORT DATABASE`](Console-Command-Export.md) command exports the current opened database into a file.  The exported file is in the [Export JSON](Export-Format.md) format.  By default, it compresses the file using the GZIP algorithm.

Using exports with the [`IMPORT DATABASE`](Console-Command-Import.md) command, you can migrate the database between different releases of OrientDB without losing data.  When doing this, if you receive an error relating to the database version, export the database using the same version of OrientDB on which you created the database.


<pre>
orientdb> <code class='lang-sql userinput'>EXPORT DATABASE /temp/petshop.export</code>

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
</pre>


## Exports versus Backups

Exports don't lock the database.  Instead, they browse the contents.  This means that OrientDB can execute concurrent operations during the export, but the exported database may not be an exact replica from the time when you issued the command.  If you need a database snapshot, use backups.

The [`BACKUP DATABASE`](Console-Command-Backup.md) command does create a consistent copy of the database, but it locks the database.  During the backup, the database remains in read-only mode, all concurrent write operations are blocked until the backup finishes.  In the event that you need a database snapshot *and* the ability to perform read/write operations during the backup, set up a distributed cluster of nodes.

>**NOTE**: Even though the export file is 100% JSON, there are some constraints in the JSON format, where the field order must be kept.  Modifying the file to adjust the indentation may make the file unusable in database imports.

## Importing Databases

Once you have exported your database, you can import it using the [`IMPORT DATABASE`](Console-Command-Import.md) command.

<pre>
orientdb> <code class='lang-sql userinput'>IMPORT DATABASE /temp/petshop.export.gz -preserveClusterIDs=true</code>

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
</pre>


>For more information, see
>
>- [JSON Export Format](Export-Format.md)
>- [`RESTORE DATABASE`](Console-Command-Restore.md)
>- [`EXPORT DATABASE`](Console-Command-Export.md)
>- [`IMPORT DATABASE`](Console-Command-Import.md)
>- [Console Commands](Console-Commands.md)
