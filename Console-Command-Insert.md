# Console -  `INSERT`

Inserts a new record into the current database.  Remember, OrientDB can work in schema-less mode, meaning that you can create any field on the fly.

**Syntax**

```sql
INSERT INTO <<class-name>|CLUSTER:<cluster-name>> (<field-names>) VALUES ( <field-values> )
```

- **`<class-name>`** Defines the class you want to create the record in.
- **`CLUSTER:<cluster-name>`** Defines the cluster you want to create the record in.
- **`<field-names>`** Defines the fields you want to add the records to, in a comma-separated list.
- **`<field-values>`** Defines the values you want to insert, in a comma-separated list.


**Examples**

- Insert a new record into the class `Profile`, using the name `Jay` and surname `Miner`:

  <pre>
  orientdb> <code class="lang-sql userinput">INSERT INTO Profile (name, surname) VALUES ('Jay', Miner')</code>

  Inserted record in 0,060000 sec(s).
  </pre>

- Insert a new record into the class `Employee`, while defining a relationship:

  <pre>
  orientdb> <code class="lang-sql userinput">INSERT INTO Employee (name, boss) VALUES ('Jack', 11:99)</code>
  </pre>

- Insert a new record, adding a collection of relationships:

  <pre>
  orientdb> <code class='lang-sql userinput'>INSERT INTO Profile (name, friends) VALUES ('Luca', [10:3, 10:4])</code>
  </pre>

>For more information on other commands, see [SQL](SQL.md) and [Console](Console-Commands.md) commands.
