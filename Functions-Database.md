---
search:
   keywords: ['functions', 'database']
---

# Database Functions

In previous exmaples, such as `factorial()`, the function is relatively self-contained.  It takes an argument from the query, operates on it, and returns the result.  This is useful in cases where you need to perform some routine arithmetic operation or manipulate strings in a consistent way, but you can also use functions to perform more complex database operations.  That is, the function can receive arguments, interact with the database, then return the results of that interaction.

When you create a function, OrientDB always binds itself to the `orient` variable.  Using this variable you can call methods to access, query and operate on the database from the function.  The specific method called to access the database depends on the type of database you're using:

| Function | Description |
|---|---|
| `orient.getGraph()` | Retrieves 

