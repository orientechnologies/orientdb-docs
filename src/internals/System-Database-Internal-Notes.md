# System Database (Internal Notes)
As discussed in the main [system database](System-Database.md) documentation, introduced in 2.2, OrientDB now has a "system database" which will be used to implement some additional capabilities.

Currently, the system database, called *OSystem*, is like a blank canvas.  It's only used today to implement the new *system users*, which use OUser and ORole only.  There aren't even any custom schemas created, though this will change as new features are added.

## Implementation
Creation and access to the system database reside in the OServer module.  When OServer starts up, it checks for the existence of the *OSystem* database in the `checkSystemDatabase()` method.  If not found, it is created.

## Access
At the moment, there are three methods defined in OServer related to the system database:
- String getSystemDatabaseName();
- String getSystemDatabasePath();
- Object executeSystemDatabaseCommand(final OCallable<Object, Object> callback, final String serverUser, final String sql, final Object... args);

`getSystemDatabaseName()` just returns the defined name *OSystem*.

`getSystemDatabasePath()` returns the full path to the location of the system database on the server.

`executeSystemDatabaseCommand()` executes the specified OrientDB SQL and uses the OCallable parameter to handle the returned results. 

## Starting Point
The current system database implementation is just a starting point.  Hopefully, we'll all be adding new features to it as the need arises. 