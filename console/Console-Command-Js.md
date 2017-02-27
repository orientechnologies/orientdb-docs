---
search:
   keywords: ['console', 'command', 'javascript', 'js', 'JS']
---

# Console - `JS`

Executes commands in the Javascript language from the Console. Look also [Javascript Command](../js/Javascript-Command.md).

**Syntax**

```sql
JS <commands>
```

- **`<commands>`** Defines the commands you want to execute.

**Interactive Mode**
You can execute a command in just one line (`JS print('Hello World!')`) or enable the interactive input by just executing `JS` and then typing the Javascript expression as multi-line inputs.  It does not execute the command until you type `end`.  Bear in mind, the `end` here is case-sensitive.

**Examples**

- Execute a query and display the result:

  <pre>
  orientdb> <code class="lang-javascript userinput">js</code>
  [Started multi-line command.  Type just 'end' to finish and execute.]
  orientdb> <code class="lang-javascript userinput">var r = db.query('select from ouser');</code>
  orientdb> <code class="lang-javascript userinput">for(var i=0;i<r.length;++i){</code>
  orientdb> <code class="lang-javascript userinput">print( r[i] );</code>
  orientdb> <code class="lang-javascript userinput">}</code>
  orientdb> <code class="lang-javascript userinput">end</code>
 
  OUser#5:0{roles:[1],status:ACTIVE,password:{PBKDF2WithHmacSHA256}C08CE0F5160EA4050B8F10EDBB86F06EB0A2EE82DF73A340:BC1B6040727C1E11E3A961A1B2A49615C96938710AF17ADD:65536,name:admin} v1
  OUser#5:1{name:reader,password:{PBKDF2WithHmacSHA256}41EF9B675430D215E0970AFDEB735899B6665DF44A29FE98:5BC48B2D20752B12B5E32BE1F22C6C85FF7CCBEFB318B826:65536,status:ACTIVE,roles:[1]} v1
  OUser#5:2{name:writer,password:{PBKDF2WithHmacSHA256}FA0AD7301EA2DB371355EB2855D63F4802F13858116AB82E:18B8077E1E63A45DB0A3347F91E03E4D2218EA16E5100105:65536,status:ACTIVE,roles:[1]} v1

  Client side script executed in 0.142000 sec(s). Value returned is: null
  </pre>

>For more information on the Javascript execution, see [Javascript Command](../js/Javascript-Command.md).  For more information on other commands, see [Console Commands](Console-Commands.md).
