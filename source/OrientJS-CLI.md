# CLI

An extremely minimalist command line interface is provided to allow
databases to created and migrations to be applied via the terminal.

To be useful, OrientJS requires some arguments to authenticate against the server. All operations require the `password` argument unless the user is configured with an empty password. For operations that involve a specific db, include the `dbname` argument (with `dbuser` and `dbpassword` if they are set to something other than the default).

You can get a list of the supported arguments using `orientjs --help`.

```sh
  -d, --cwd         The working directory to use.
  -h, --host        The server hostname or IP address.
  -p, --port        The server port.
  -u, --user        The server username.
  -s, --password    The server password.
  -n, --dbname      The name of the database to use.
  -U, --dbuser      The database username.
  -P, --dbpassword  The database password.
  -?, --help        Show the help screen.
```

If it's too tedious to type these options in every time, you can also create an `orientjs.opts` file containing them. OrientJS will search for this file in the working directory and apply any arguments it contains.
For an example of such a file, see [test/fixtures/orientjs.opts](./test/fixtures/orientjs.opts).


> Note: For brevity, all these examples assume you've installed OrientJS globally (`npm install -g orientjs`) and have set up an orientjs.opts file with your server and database credentials.

## Database CLI Commands.

### Listing all the databases on the server.

```sh
orientjs db list
```

### Creating a new database

```sh
orientjs db create mydb graph plocal
```

### Destroying an existing database

```sh
orientjs db drop mydb
```

## Migrations

OrientJS supports a simple database migration system. This makes it easy to keep track of changes to your orientdb database structure between multiple environments and distributed teams.

When you run a migration command, OrientJS first looks for an orient class called `Migration`. If this class doesn't exist it will be created.
This class is used to keep track of the migrations that have been applied.

OrientJS then looks for migrations that have not yet been applied in a folder called `migrations`. Each migration consists of a simple node.js module which exports two methods - `up()` and `down()`. Each method receives the currently selected database instance as an argument.

The `up()` method should perform the migration and the `down()` method should undo it.

> Note: Migrations can incur data loss! Make sure you back up your database before migrating up and down.

In addition to the command line options outlined below, it's also possible to use the migration API programatically:

```js
var db = server.use('mydb');

var manager = new OrientDB.Migration.Manager({
  db: db,
  dir: __dirname + '/migrations'
});

manager.up(1)
.then(function () {
  console.log('migrated up by one!')
});
```


### Listing the available migrations

To list all the unapplied migrations:

```sh
orientjs migrate list
```

### Creating a new migration

```sh
orientjs migrate create my new migration
```

creates a file called something like `m20140318_200948_my_new_migration` which you should edit to specify the migration up and down methods.


### Migrating up fully

To apply all the migrations:

```sh
orientjs migrate up
```

### Migrating up by 1

To apply only the first migration:

```sh
orientjs migrate up 1
```

### Migrating down fully

To revert all migrations:

```sh
orientjs migrate down
```

### Migrating down by 1

```sh
orientjs migrate down 1
```
