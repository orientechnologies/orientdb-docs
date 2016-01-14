<!-- proofread 2015-01-07 SAM -->

# Console - `DECLARE INTENT`

Declares an intent for the current database. Intents allow you to tell the database what you want to do.

**Syntax**

```sql
DECLARE INTENT <intent-name>
```

- **`<intent-name>`** Defines the name of the intent. OrientDB supports three intents:
  - *`NULL`* Removes the current intent.
  - *`MASSIVEINSERT`*
  - *`MASSIVEREAD`*

**Examples**

- Declare an intent for a massive insert:

  <pre>
  orientdb> <code class="lang-sql userinput">DECLARE INTENT MASSIVEINSERT</code>
  </pre>

- After the insert, clear the intent:

  <pre>
  orientdb> <code class="lang-sql userinput">DECLARE INTENT NULL</code>
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).
