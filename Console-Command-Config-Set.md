<!-- proofread 2015-01-07 SAM -->

# Console - `CONFIG SET`

Updates a configuration variable to the given value.

**Syntax**

```sql
CONFIG SET <config-variable> <config-value>
```
- **`<config-variable>`** Defines the configuration variable you want to change.
- **`<config-value>`** Defines the value you want to set.

**Example**

- Display the current value for `tx.autoRetry`:

  <pre>
  orientdb> <code class="lang-sql userinput">CONFIG GET tx.autoRetry</code>

  Remote configuration: tx.autoRetry = 1
  </pre>

  Change the `tx.autoRetry` value to `5`:

  <pre>
  orientdb> <code class="lang-sql userinput">CONFIG SET tx.autoRetry 5</code>

  Remote configuration value changed correctly.
  </pre>

  Display new value:

  <pre>
  orientdb> <code class="lang-sql userinput">CONFIG GET tx.autoRetry</code>

  Remote configuration: tx.autoRetry = 5
  </pre>

>You can display all configuration variables with the [`CONFIG`](Console-Command-Config.md) command.  You can view the current value on a configuration variable using the [`CONFIG GET`](Console-Command-Config-Get.md) command.
>
>For more information on other commands, see [Console Commands](Console-Commands.md)
