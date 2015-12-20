# Console - `DICTIONARY KEYS`

Displays all the keys stored in the database dictionary.

**Syntax**

```
DICTIONARY KEYS
```

**Example**

- Display all the keys stored in the database dictionary:

  <pre>
  orientdb> <code class='lang-sql userinput'>DICTIONARY KEYS</code>

  Found 4 keys:
  #0: key-148
  #1: key-147
  #2: key-146
  #3: key-145
  </pre>

>To load the records associated with these keys, use the [`DICTIONARY GET`](Console-Command-Dictionary-Get.md) command.  For more information on indexes, see [Indexes](Indexes.md).
>
>For more information on other commands, see [Console Commands](Console-Commands.md).
