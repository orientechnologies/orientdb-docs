# Console - `LIST CLASSES`

Displays all configured classes in the current database. 

**Syntax:**

- Long Syntax:

  ```
  LIST CLASSES
  ```

- Short Syntax:

  ```
  CLASSES
  ```

**Example**

- List current classes on the database:

  <pre>
  orientdb> <code class="lang-sql userinput">LIST CLASSES</code>

  CLASSES
  -------------+------+-------------+-----------
   NAME        |  ID  | CLUSTERS    | ELEMENTS  
  -------------+------+-------------+-----------
   Person      |    0 | person      |         7 
   Animal      |    1 | animal      |         5 
   AnimalRace  |    2 | AnimalRace  |         0 
   AnimalType  |    3 | AnimalType  |         1 
   OrderItem   |    4 | OrderItem   |         0 
   Order       |    5 | Order       |         0 
   City        |    6 | City        |         3 
  -------------+------+-------------+-----------
   TOTAL                                     16 
  -----------------------------------------------
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).
