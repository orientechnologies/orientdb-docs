# Console - `JSS`

Executes commands on OrientDB Server in the Javascript language from the Console. Look also [Javascript Command](Javascript-Command.md).

**Syntax**

```sql
JSS <commands>
```

- **`<commands>`** Defines the commands you want to execute.

**Interactive Mode**
You can execute a command in just one line (`JSS print('Hello World!')`) or enable the interactive input by just executing `JSS` and then typing the Javascript expression as multi-line inputs.  It does not execute the command until you type `end`.  Bear in mind, the `end` here is case-sensitive.

**Examples**

- Execute a query and display the result:

  <pre>
  orientdb> <code class="lang-javascript userinput">jss</code>
  [Started multi-line command.  Type just 'end' to finish and execute.]
  orientdb> <code class="lang-javascript userinput">var r = db.query('select from ouser');</code>
  orientdb> <code class="lang-javascript userinput">for(var i=0;i<r.length;++i){</code>
  orientdb> <code class="lang-javascript userinput">print( r[i] );</code>
  orientdb> <code class="lang-javascript userinput">}</code>
  orientdb> <code class="lang-javascript userinput">end</code>
 
  Server side script executed in 0.146000 sec(s). Value returned is: null
  </pre>

  In this case the output will be displayed on the server console.
  
>For more information on the Javascript execution, see [Javascript Command](Javascript-Command.md).  For more information on other commands, see [Console Commands](Console-Commands.md).
