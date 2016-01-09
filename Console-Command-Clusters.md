<!-- proofread 2015-01-07 SAM -->

# Console - `LIST CLUSTERS`

Displays all configured clusters in the current database.

**Syntax:**

- Long Syntax:

  ```
  LIST CLUSTERS
  ```

- Short Syntax:

  ```
  CLUSTERS
  ```

**Example:**

- List current clusters on database:

  <pre>
  orientdb> <code class="lang-sql userinput">LIST CLUSTERS</code>

  CLUSTERS
  -------------+------+-----------+-----------
   NAME        |  ID  | TYPE      | ELEMENTS  
  -------------+------+-----------+-----------
   metadata    |    0 | Physical  |        11 
   index       |    1 | Physical  |         0 
   default     |    2 | Physical  |       779 
   csv         |    3 | Physical  |      1000 
   binary      |    4 | Physical  |      1001 
   person      |    5 | Physical  |         7 
   animal      |    6 | Physical  |         5 
   animalrace  |   -2 | Logical   |         0 
   animaltype  |   -3 | Logical   |         1 
   orderitem   |   -4 | Logical   |         0 
   order       |   -5 | Logical   |         0 
   city        |   -6 | Logical   |         3 
  -------------+------+-----------+-----------
   TOTAL                                 2807 
  --------------------------------------------
  </pre>

>For information on creating new clusters in the current database, see the [`CREATE CLUSTER`](Console-Command-Create-Cluster.md) command.  For more information on other commands, see [Console Commands](Console-Commands.md).
