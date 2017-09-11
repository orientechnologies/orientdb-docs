---
search: 
   keywords: ['console', 'command', 'BROWSE CLUSTER', 'browse', 'cluster']
---

<!-- proofread 2015-01-07 SAM -->

# Console - `BROWSE CLUSTER`

Displays all records associated with the given cluster.

**Syntax:**

```
BROWSE CLUSTER <cluster-name>
```

- **`<cluster-name>`** Defines the cluster for the records you want to display.

**Permissions:**

In order to enable a user to execute this command, you must add the permission of `read` for the resource `database.cluster.<class>` to the [database user](Database-Security.md#users).

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

