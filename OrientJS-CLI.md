# OrientJS Command-line Interface

Under certain conditions, you may need to operate OrientJS from the command-line, such as when creating databases or handling migrations through the terminal.  OrientJS provides a minimalistic CLI application for interacting with the OrientDB Server.

## Configuring `orientjs`

Using the OrientJS CLI application requires that you pass some arguments and options to the interface.  All operations require that you use the `--password` option, except in cases where the user is configured with an empty password.  

For operations that involve a specific database, you need to pass `--dbname` with `--dbuser` and `--dbpassword` if they're set to something other than the defaults.

You can get a complete less of the supported options at any time, by passing it the `--help` flag.

<pre>
$ <code class="lang-sh userinput">orientjs --help</code>
Usage: orientjs [OPTIONS] [db|migrate]

Options:
  -d, --cwd         The working directory to use.
  -h, --host        The server hostname or IP address
  -p, --port        The server port.
  -u, --user        The server username.
  -s, --password    The server password.
  -n, --dbname      The name of the database to use.
  -U, --dbuser      The database username.
  -P, --dbpassword  The database user password.
  -?, --help        Show the help screen.
</pre>

### Using an Options File

In the event that you find yourself calling `orientjs` with the same options set every time, you can set these defaults in the `orientjs.opts` options file.  When the OrientJS CLI application launches, it looks for this file in the current working directory and applies any arguments it contains.

For instance,

<pre>
$ <code class="lang-sh userinput">cat orientjs.opts</code>

--host=localhost
--port=2424
--password=root_passwd
</pre>


## Working with `orientjs`

When you call the OrientJS CLI application, there are two commands available to you: 

- **`db`** command, for interacting with the database.
- **`migration`** command, for migrating databases.



