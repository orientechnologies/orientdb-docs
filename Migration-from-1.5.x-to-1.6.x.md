# Migration from 1.5.x to 1.6.x
____

Databases created with release 1.5.x need to be exported and reimported in OrientDB 1.6.x.

From OrientDB 1.5.x:
- Open the console under "bin/" directory calling:
 - > ./console.sh (or .bat on Windows)
- Connect to the database and export it, example:
 - orientdb> connect plocal:/temp/db admin admin
 - orientdb> export database /temp/db.zip
- Run OrientDB 1.6.x console
 - > ./console.sh (or .bat on Windows)
- Create a new database and import it, example:
 - orientdb> create database plocal:/temp/db admin admin plocal
 - orientdb> import database /temp/db.zip

For any problem on import, look at [Import Troubleshooting](Console-Command-Import.md#troubleshooting).

## Engine

OrientDB 1.6.x comes with the new PLOCAL engine. To migrate a database create with the old "local" to such engine follow the steps in: [Migrate from local storage engine to plocal](Upgrade.md#migrate-from-local-storage-engine-to-plocal).
