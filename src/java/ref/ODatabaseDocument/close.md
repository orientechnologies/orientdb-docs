
# ODatabaseDocument - close()

This method closes the database.

## Closing Databases

Using this method, you can close an opened database, freeing up resources for other uses.  In the event that the database is already closed, this method does nothing.  When you close a database, any open transactions are closed, their changed rolled back.

### Syntax

```
void ODatabaseDocument().close()
```


