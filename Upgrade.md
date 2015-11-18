# Upgrading
_____

OrientDB uses the Semantic Versioning System (http://semver.org), where the version numbers follow this format MAJOR.MINOR.PATCH,
Here are the meanings of the increments:

- MAJOR version entails incompatible API changes,
- MINOR version entails functionality in a backward-compatible manner
- PATCH version entails backward-compatible bug fixes.

So between PATCH versions, the compatibility is assured (example 1.7.0 -> 1.7.8). Between MINOR and MAJOR versions, you may need to export and re-import the database. To find out if your upgrade must be done over exporting and importing the database, see below in the column "Database":


## Compatibility Matrix

| FROM |TO | Guide | Blueprints | Database |Binary Protocol|HTTP Protocol|
|-----|----|------------|----------|--------|-----------|-----------|----------|----------|---|
| 2.0.x | 2.1.x | [Release 2.1.x](Release-2.1.0.md) | Final v2.6.0 |[Automatic](Backward-compatibility.md) | 30 |10|
| 1.7.x | 2.0.x | [Migration-from-1.7.x-to-2.0.x](Migration-from-1.7.x-to-2.0.x.md) | Final v2.6.0 | [Automatic](Backward-compatibility.md) | 25 |10|
| 1.6.x | 1.7.x | [Migration-from-1.6.x-to-1.7.x](Migration-from-1.6.x-to-1.7.x.md) | Final v2.5.0 | [Automatic](Backward-compatibility.md) | 20, 21 |10|
| 1.5.x | 1.6.x | [Migration-from-1.5.x-to-1.6.x](Migration-from-1.5.x-to-1.6.x.md) | Changed v2.5.x | [Automatic](Backward-compatibility.md) | 18, 19|10|
| 1.4.x | 1.5.x | [Migration-from-1.4.x-to-1.5.x](Migration-from-1.4.x-to-1.5.x.md) | Changed v2.4.x | [Automatic](Backward-compatibility.md) | 16, 17|10|
| 1.3.x | 1.4.x | [Migration-from-1.3.x-to-1.4.x](Migration-from-1.3.x-to-1.4.x.md) | Changed v2.3.x | [Automatic](Backward-compatibility.md) | 14, 15|n.a.|
| 1.2.x | 1.3.x |n.a. | Changed v2.2.x | OK | OK|OK| Need export & Re-import | 12, 13| n.a. |

References:

- Binary Network Protocol: [Network Binary Protocol](Network-Binary-Protocol.md)
- HTTP Network Protocol: [OrientDB REST](OrientDB-REST.md)

## Migrate from LOCAL storage engine to PLOCAL
Starting from version 1.5.x OrientDB comes with a brand new storage engine: PLOCAL (Paginated LOCAL). It's persistent like the LOCAL, but stores information in a different way. Below are the main differences with LOCAL:
 - records are stored in cluster files, while with LOCAL was split between cluster and data-segments
 - more durable than LOCAL because the append-on-write mode
 - minor contention locks on writes: this means more concurrency
 - it doesn't use Memory Mapping techniques (MMap) so the behavior is more "predictable"

To migrate your LOCAL storage to the new PLOCAL, you need to export and reimport the database using PLOCAL as storage engine. Follow the steps below:

1) open a new shell (Linux/Mac) or a Command Prompt (Windows)

2) export the database using the console. Example by exporting the database under /temp/db:

```sql
$ bin/console.sh (or bin/console.bat under Windows)
orientdb> CONNECT DATABASE local:/temp/db admin admin
orientdb> EXPORT DATABASE /temp/db.json.gzip
orientdb> DISCONNECT
```

3) now always in the console create a new database using the "plocal" engine:

   a) on a local filesystem:

      orientdb> CREATE DATABASE plocal:/temp/newdb admin admin plocal graph

   b) on a remote server (use the server's credentials to access):

      orientdb> CREATE DATABASE remote:localhost/newdb root password plocal graph

4) now always in the console import the old database in the new one:

    orientdb> IMPORT DATABASE /temp/db.json.gzip -preserveClusterIDs=true
    orientdb> QUIT

5) If you access to the database in the same JVM remember to change the URL from "local:" to "plocal:"

## Migrate graph to RidBag
As of OrientDB 1.7 the RidBag is default collection that manages adjacency relations in graphs. While the older database managed by an MVRB-Tree are fully compatible, you can update your database to the more recent format.

You can upgrade your graph via console or using the ORidBagMigration class

### Using console
+ Connect to database `CONNECT plocal:databases/GratefulDeadConcerts`
+ Run `upgrade graph` command

### Using the API
+ Create OGraphMigration instance. Pass database connection to constructor.
+ Invoke method execute()

