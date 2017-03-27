
## Console Modes

There are two modes available to you, while executing commands through the OrientDB Console: interactive mode and batch mode.


### Interactive Mode

By default, the Console starts in interactive mode.  In this mode, the Console loads to an `orientdb>` prompt.  From there you can execute commands and SQL statements as you might expect in any other database console.

You can launch the console in interactive mode by executing the `console.sh` for Linux OS systems or `console.bat` for Windows systems in the `bin` directory of your OrientDB installation. Note that running this file requires execution permissions.

<pre>
$ <code class="lang-sh userinput">cd $ORIENTDB_HOME/bin</code>
$ <code class="lang-sh userinput">./console.sh</code>

OrientDB console v.X.X.X (build 0) www.orientdb.com
Type 'HELP' to display all the commands supported.
Installing extensions for GREMLIN language v.X.X.X

orientdb>
</pre>

From here, you can begin running SQL statements or commands.  For a list of these commands, see [commands](Console-Commands.md#console-commands).


### Batch mode

When the Console runs in batch mode, it takes commands as arguments on the command-line or as a text file and executes the commands in that file in order.  Use the same `console.sh` or `console.bat` file found in `bin` at the OrientDB installation directory.

- **Command-line**: To execute commands in batch mode from the command line, pass the commands you want to run in a string, separated by a semicolon.
  <pre>
  $ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/console.sh "CONNECT REMOTE:localhost/demo;SELECT FROM Profile"</code>
  </pre>

- **Script Commands**: In addition to entering the commands as a string on the command-line, you can also save the commands to a text file as a semicolon-separated list.

  <pre>
  $ <code class="lang-sh userinput">vim commands.txt</code>
  <code class="lang-sql userinput">
    CONNECT REMOTE:localhost/demo;SELECT FROM Profile
  </code>
  $ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/console.sh commands.txt</code>
  </pre>


#### Ignoring Errors

When running commands in batch mode, you can tell the console to ignore errors, allowing the script to continue the execution, with the `ignoreErrors` setting.

<pre>
$ <code class="lang-sh userinput">vim commands.txt</code>
<code class="lang-sql userinput">
  SET ignoreErrors TRUE
</code>
</pre>


#### Enabling Echo

Regardless of whether you call the commands as an argument or through a file, when you run console commands in batch mode, you may also need to display them as they execute.  You can enable this feature using the `echo` setting, near the start of your commands list.

<pre>
$ <code class='lang-sh userinput'>vim commands.txt</code>
<code class="lang-sql userinput">
  SET echo TRUE
</code>
</pre>


### Enabling Date in prompt

Starting from v2.2.9, to enable the date in the prompt, set the variable `promptDateFormat` with the date format following the [SimpleDateFormat specs](https://docs.oracle.com/javase/8/docs/api/java/text/SimpleDateFormat.html).

<pre>
<code class='lang-sh userinput'>
orientdb {db=test1}> set promptDateFormat "yyy-MM-dd hh:mm:ss.sss"

orientdb {db=test1 (2016-08-26 09:34:12.012)}> 
</code>
</pre>
