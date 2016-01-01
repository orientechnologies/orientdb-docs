# Console - `LIST DATABASES`

Displays all databases hosted on the current server.  Note that this command requires you connect to the OrientDB Server.

**Syntax**

```sql
LIST DATABASES
```

**Example**

- Connect to the server:
 
  <pre>
  orientdb> <code class="lang-sql userinput">CONNECT REMOTE:localhost admin admin_password</code>
  </pre>

- List the databases hosted on the server:

  <pre>
  orientdb {server=remote:localhost/}> <code class="lang-sql userinput">LIST DATABASES</code>

  Found 4 databases:

  * ESA (plocal)
  * Napster (plocal)
  * Homeland (plocal)
  * GratefulDeadConcerts (plocal)
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).

