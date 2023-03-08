
# OTransaction - hasRecordCreation()

Determines whether the transaction has created records.

## Checking Records

Using this method you can check whether any records have been created as part of the transaction.

### Syntax

```
boolean OTransaction().hasRecordCreation()
```

#### Return Value

This method returns a `boolean` value.  A value of `true` indicates that the transaction includes record creation.  `false` indicates that no records are created in the transaction.
