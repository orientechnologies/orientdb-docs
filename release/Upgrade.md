

# Upgrading

OrientDB uses the Semantic Versioning System (http://semver.org), where the version numbers follow this format MAJOR.MINOR.PATCH,
Here are the meanings of the increments:

- MAJOR version entails incompatible API changes,
- MINOR version entails functionality in a backward-compatible manner
- PATCH version entails backward-compatible bug fixes.

So between PATCH versions, the compatibility is assured (example 2.1.0 -> 2.1.8). Between MINOR and MAJOR versions, you may need to export and re-import the database. To find out if your upgrade must be done over exporting and importing the database, see below in the column "Database":

## Compatibility Matrix

| FROM |TO | Guide | Blueprints | Database |Binary Protocol|HTTP Protocol|
|-----|----|------------|----------|--------|-----------|-----------|----------|----------|---|
| 2.2.x | 3.0.x | [Docs](3.0/Upgrading-to-OrientDB-3.0.md) |              |  |   | |
| 2.1.x | 2.2.x | REFACTOR-TODO | Final v2.6.0 |[Automatic](../misc/Backward-compatibility.md) | 34 |10|
| 2.0.x | 2.1.x | REFACTOR-TODO | Final v2.6.0 |[Automatic](../misc/Backward-compatibility.md) | 30 |10|


## Instructions

The easiest way to upgrade a database from one version of OrientDB to the next is to plan ahead for future upgrades from the beginning.

The recommended strategy is to store databases separately from the OrientDB installation, often on a separate data volume.

As an example, you might have a data volume, called `/data`, with a `databases` directory under that where all of your database directories will be stored. 

```
/data/databases:
MyDB
WebAppDB
```

### New Databases
If you're just starting with OrientDB or just creating new databases, from the OrientDB installation directory, you can remove the `databases` directory and then create a symbolic link to the `/data/databases` directory previously created.

Make sure OrientDB is not running.

On a Linux system, you could call `rm -rf databases` to remove the *databases* directory and recursively remove all sub-directories.

**DO NOT issue that command if you have any live databases that have not been moved!**     

Once the `databases` directory is removed, create a symbolic link to the `/data/databases` directory.

On a Linux system, you could call `ln -s /data/databases ./databases`.

On a Windows system, you can use `mklink /d .\databases d:\data\databases`, assuming your data volume resides as the `d:` drive in Windows.  The `/d` switch creates a directory symbolic link.  You can use `/j` instead to create a directory junction.

You should now be able to start OrientDB and create new databases that will reside under `/data/databases`.

### Upgrading Symbolic-Linked Databases
If you used a similar symbolic link scheme as suggested in the prior section, upgrading OrientDB is very easy.  Simply follow the same instructions to remove the `databases` directory from the **NEW** OrientDB installation directory and then create a symbolic link to `/data/databases`.

### Upgrading Existing Databases
If you've been running OrientDB in the standard way, with the `databases` directory stored directly under the OrientDB installation directory, then you have two options when upgrading to a newer version of OrientDB.

1. You can move your database directories to the `databases` directory under the new installation.
2. You can move your database directories to an external location and then set-up a symbolic link from the new installation. 

#### Moving Databases to a New Installation
Make sure OrientDB is not running.  From the old OrientDB installation location, move each database directory under `databases` to the `databases` directory in the new OrientDB installation.

#### Moving Databases to an External Location
Make sure OrientDB is not running.  Using the earlier example of `/data/databases`, from the old OrientDB installation location, move each database directory under `databases` to the `/data/databases` location. 

Now, follow the instructions under [New Databases](#new-databases) to create a symbolic link from within the new OrientDB installation to the `/data/databases` directory.

### External Storage Advantages
If you store your databases separately from the OrientDB installation, not only will you be able to upgrade more easily in the future, but you may even be able to improve performance by using a data volume that is mounted on a disk that's faster than the volume where the main installation resides.

Also, many cloud-based providers support creating snapshots of data volumes, which can be a useful way of backing up all of your databases.


