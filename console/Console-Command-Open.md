---
search:
   keywords: ['console', 'command', 'connection', 'CONNECT']
---


# Console - `OPEN`

Opens a database.

**Syntax**

```
OPEN <database-name> <user> <password>
```

- **`<database-name>`** Defines the name of the database you want to connect to.  The console has to be connected to a server/environment (see [CONNECT ENV](Console-Command-Connect-Env.md) ) and the database has to be present in that environment
- **`<user>`** Defines the user you want to connect to the database with.
- **`<password>`** Defines the password needed to connect to the database, with the defined user.


**Examples:**

- Connect to a local database as the user `admin`, loading it directly into the console:

  <pre>
  
  orientdb> <code class="userinput lang-sql">connect env plocal:../databases/</code>
    
  orientdb> <code class="userinput lang-sql">open demodb admin my_admin_password</code>

  Connecting to database [plocal:../databases/demodb]...OK
  </pre>

- Connect to a remote database:

  <pre>
  orientdb> <code class="lang-sql userinput">connect env remote:192.168.1.1</code>

  orientdb> <code class="userinput lang-sql">open demodb admin my_admin_password</code>
  
  Connecting to database [remote:192.168.1.1/demodb]...OK
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).
