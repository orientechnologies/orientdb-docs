---
search:
   keywords: ['console', 'command', 'connection', 'CONNECT']
---


# Console - `CONNECT ENV`

(since v 3.2)

Opens a database.

**Syntax**

```
CONNECT ENV <env-url> [<user> <password>]
```

- **`<env-url>`** defines the URL of an OrientDB server/environment. It uses the format `<mode>:<path>`
  - *`<mode>`* Defines the mode you want to use in connecting to the database.  It can be `plocal` or `remote`.
  - *`<path>`* Defines the path to the database.  
- **`<user>`** Defines the user you want to connect with.
- **`<password>`** Defines the password needed to connect, with the defined user. User and password are needed to execute authenticated operations on the environment (eg. create a database on a remote server); they are not needed for operations that do not require an authentication or that require different credentials (eg. to open a database you can pass the database user and password, see [OPEN](Console-Command-Open.md))

After the console is connected to an environment, it allows to execute opeartions and [Server-Level](../serverlevel/README.md) commands on it.

**Examples:**

- Connect the console to a local (embedded) environment as the user `root`, loading it directly into the console:

  <pre>
  
  orientdb> <code class="userinput lang-sql">connect env plocal:../databases/</code>
    
  </pre>

- Connect to a remote server:

  <pre>
  orientdb> <code class="lang-sql userinput">connect env remote:192.168.1.1 root root</code>
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).
