
# ODatabaseDocument - getRecordType()

This method returns the default record type for the database.

## Retrieving Record Types

The [`ODatabaseDocument`](../ODatabaseDocument.md) class serves as a generic interface for operating on both Document and Grap databases.  Records are stored using different classes depending on which database-type you chose to use.  This method tells you which class is being used as the default on your database.

### Syntax

```
public byte ODatabaseDocument().getRecordType()
```

