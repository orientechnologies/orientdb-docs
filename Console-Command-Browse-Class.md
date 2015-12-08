# Console - `BROWSE CLASS`

Displays all records associated with the given class.

**Syntax:**

```
BROWSE CLASS <class-name>
```

- **`<class-name>`** Defines the class for the records you want to display.

**Example:**

- Browse records associated with the class `City`:

  <pre>
  orientdb> <code class="lang-sql userinput">BROWSE CLASS City</code>

  ----+------+-------------------
    # | RID  | NAME
  ----+------+-------------------
    0 | -6:0 | Rome
    1 | -6:1 | London
    2 | -6:2 | Honolulu
  ----+------+-------------------
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).

