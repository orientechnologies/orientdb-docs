# Migration Interface in OrientJS CLI

When working with the OrientJS command-line interface, `orientjs`, using the `migration` interface provides you with a simple migration system, allowing you to track changes to the structure of OrientDB across multiple environments and distribution teams.


## Understanding Migration





## Working with Migrations

OrientJS supports several commands in working with the migration process from the command-line interface.

### Listing Migrations

Using the `list` operation, you can view the migrations available to you.  These can then be applied or rolled back, depending on your needs.

<pre>
$ <code class="lang-sh userinput">orientjs migrate list</code>
</pre>

### Creating Migrations

Using the `create` operation with a name argument, you can create a new migration in OrientJS.  For instance,

<pre>
$ <code class="lang-sh userinput">orientjs migrate create baseball stats migration</code>
</pre>

Running this command creates a file in your `migrations/` folder with a name like `m20160603_baseball_stats_migration`, which you can then edit to define the `up()` and `down()` methods for the migration.

### Applying Migrations

There are two methods available to you in handling pending migrations.  You can either apply them all together, or you can partially apply them.

To apply the migrations full, use the following command

<pre>
$ <code class="lang-sh userinput">orientjs migration up</code>
</pre>

This applies all pending migrations.  By passing a number argument to `up`, you can limit the process to only apply the first or first few migrations available.

<pre>
$ <code class="lang-sh userinput">orientjs migration up 1</code>
</pre>

This would only apply the first migration.
 

### Downgrading Migrations

There are two methods available to you in downgrading applied migrations.  You can either downgrade all migrations or only downgrade some of them.

To downgrade all migrations, use the following command:

<pre>
$ <code class="lang-sh userinput">orientjs migrate down</code>
</pre>

By passing a number argument to `down`, you can limit the process to only donwgrade the first or first few migrations applied. 

<pre>
$ <code class="lang-sh userinput">orientjs migrate down 1</code>
</pre>

This would only downgrade from the last migration.


