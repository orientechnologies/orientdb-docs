# Migration from 1.6.x to 1.7.x
____

Databases created with release 1.6.x are compatible with 1.7, so you don't have to export/import the database like in the previous releases.

## Engine

OrientDB 1.7 comes with the PLOCAL engine as default one. For compatibility purpose we still support "local" database, but this will be removed soon. So get the chance to migrate your old "local" database to the new "plocal" follow the steps in: [Migrate from local storage engine to plocal](Upgrade.md#migrate-from-local-storage-engine-to-plocal).
