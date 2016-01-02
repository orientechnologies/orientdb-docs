# Console - `SLEEP`

Pauses the console for the given amount a time.  You may find this command useful in working with batches or to simulate latency.

**Syntax**

```sql
SLEEP <time>
```

- **`<time>`** Defines the time the Console should pause in milliseconds.

**Example**

- Pause the console for three seconds:

  <pre>
  orientdb {server=remote:localhost/}> <code class='lang-sql userinput'>SLEEP 3000</code>
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).
