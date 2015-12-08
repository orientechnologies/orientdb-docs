# Console - `BROWSE CLUSTER`

Displays all records associated with the given cluster.

**Syntax:**

```
BROWSE CLUSTER <cluster-name>
```

- **`<cluster-name>`** Defines the cluster for the records you want to display.

**Example:**

- Browse records associated with the cluster `City`:

  <pre>
  orientdb> <code class="lang-sql userinput">BROWSE CLUSTER City</code>

  ----+------+-------------------
    # | RID  | NAME
  ----+------+-------------------
    0 | -6:0 | Rome
    1 | -6:1 | London
    2 | -6:2 | Honolulu
  ----+------+-------------------
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).

