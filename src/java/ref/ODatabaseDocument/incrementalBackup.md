---
search:
   keywords: ['java', 'odatabasedocument', 'backups', 'incremental backup', 'incrementalbackup']
---

# ODatabaseDocument - incrementalBackup()

Performs an incremental backup to the given path.

## Incremental Backups

OrientDB can back up your database using full or incremental operations.  A full backup creates a complete copy of the database.  An incremental backup checks the backup in the target path and only writes to file the data that has changed since the last backup took place.  Using this method you can run an incremental backup on the current database instance.

This operation is thread safe and can be done in the normal operational mode.  When done the first time, OrientDB performs a full backup.  Otherwise it only writes the changes.

### Syntax

```
String ODatabaseDocument().incrementalBackup(String path)
```

| Argument | Type | Description |
|---|---|---|
| **`path`** | `String` | Path to backup |


#### Return Value

This method returns a `String` instance, which corresponds to the filename of the backup.
