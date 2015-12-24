# Console - `GREMLIN`

Executes commands in the Gremlin language from the Console.

Gremlin is a graph traversal language.  OrientDB supports it from the Console, API and through a Gremlin shell launched from `$ORIENTDB_HOME/bin/gremlin.sh`.

**Syntax**

```sql
GREMLIN <command>
```

- **`<command>`** Defines the commands you want to know.

>**NOTE**: OrientDB parses Gremlin commands as multi-line input.  It does not execute the command until you type `end`.  Bear in mind, the `end` here is case-sensitive.

**Examples**

- Create a vertex using Gremlin:

  <pre>
  orientdb> <code class="lang-javascript userinput">GREMLIN v1 = g.addVertex();</code>
  [Started multi-line command.  Type just 'end' to finish and execute.]

  orientdb> <code class="lang-javascript userinput">end</code>
 
  v[#9:0]

  Script executed in 0,100000 sec(s).
  </pre>


>For more information on the Gremlin language, see [Gremlin](Gremlin.md).  For more information on other commands, see [Console Commands](Console-Commands.md).
