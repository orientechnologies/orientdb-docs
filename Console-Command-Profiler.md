# Console - `PROFILER`

Controls the [Profiler](Profiler.md).

**Syntax**

```sql
PROFILER ON|OFF|DUMP|RESET
```
- **`ON`** Turn on the Profiler and begin recording.
- **`OFF`** Turn off the Profiler and stop recording.
- **`DUMP`** Dump the Profiler data.
- **`RESET`** Reset the Profiler data.

**Example**

- Turn the Profiler on:

  <pre>
  orientdb> <code class='lang-sql userinput'>PROFILER ON</code>

  Profiler is ON now, use 'profiler off' to turn off.
  </pre>

- Dump Profiler data:

  <pre>
  orientdb> <code class='lang-sql userinput'>PROFILER DUMP</code>
  </pre>


>For more information on other commands, see [Console Commands](Console-Commands.md).
