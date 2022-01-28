---
search:
   keywords: ['console', 'command', 'load', 'record', 'LOAD SCRIPT']
---

# Console - `LOAD SCRIPT` (from 2.2.18)

Loads a sql script from the given path and executes it.

**Syntax**

```sql
LOAD SCRIPT <script path>
```

**Example**

- Load a script from an absolute path:

  <pre>
  orientdb> <code class="lang-sql userinput">LOAD SCRIPT /path/to/scripts/data.osql</code>

  </pre>


- Launch the console in batch mode and load script to a remote database:

  <pre>
  $ <code class="lang-sh userinput">$ORIENTDB_HOME/bin/console.sh "CONNECT REMOTE:localhost/demo;LOAD SCRIPT /path/to/scripts/data.osql"</code>
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).
