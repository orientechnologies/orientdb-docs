
# OSecurityUser - getAcccountStatus()

Retrieves the status of the user account.

## User Account Status

OrientDB supports the use of a general status, which is either `ACTIVE` or `SUSPENDED` to determine whether the user can access resources.  This makes it relatively straightforward to quickly disable account should the need arise.  Using this method, you can retrieve the current account status.  To set the account status, see the [`setAccountStatus()`](setAccountStatus.md) method.


### Syntax

```
OSecurityUser.STATUSES OSecurityUser().getAccountStatus()
```

#### Return Value

This method returns `OSecurityUser.STATUSES` instance, which is either `ACTIVE` or `SUSPENDED`.
