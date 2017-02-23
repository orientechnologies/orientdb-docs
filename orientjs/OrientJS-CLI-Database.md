# Database Interface in OrientJS CLI

When working with the OrientJS command-line interface, `orinetjs`, issuing the `db` command allows you to manipulate databases on OrientDB from the terminal.

For instance,

<pre>
$ <code class="lang-sh userinput">orientjs db list</code>
</pre>


## Working with Databases

OrientJS supports a handful of basic commands through the command-line interface.  You may find these useful when initializing OrientDB to work with your application.

### Listing Databases

Using the `list` operator, you can connect to the server and print to standard output a list of the current databases available in OrientDB.  For instance,

<pre>
$ <code class="lang-sh userinput">orientjs db list</code>
</pre>

### Creating Databases

Using the `create` operator, you can connect to the server and create a new database on OrientDB.  For instance,

<pre>
$ <code class="lang-sh userinput">orientjs db create BaseballStats plocal</code>
</pre>


### Removing Databases

Using the `drop` operator, you can connect to the server and remove a database from OrientDB.  For instance,

<pre>
$ <code class="lang-sh userinput">orientjs db drop BaseballStats</code>
</pre>
