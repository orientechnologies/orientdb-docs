<!-- proofread 2015-01-07 SAM -->

# Console - `CONFIG GET`

Displays the value of the requested configuration variable.

**Syntax**

```
CONFIG GET <config-variable>
```

- **`<config-variable>`**  Defines the configuration variable you want to query.


**Examples**

- Display the value to the `tx.log.fileType` configuration variable:

  <pre>
  orientdb> <code class="lang-sql userinput">CONFIG GET tx.log.fileType</code>

  Remote configuration: tx.log.fileType = classic
  </pre>

>You can display all configuration variables using the [`CONFIG`](Console-Command-Config.md) command. To change the values, use the [`CONFIG SET`](Console-Command-Config-Set.md) command.
>
>For more information on other commands, see [Config Commands](Console-Commands.md).
