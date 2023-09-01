
# OSecurityUser - setAccountStatus()

Sets the user account status.

## Account Status

OrientDB supports the use of a general status, which is either `ACTIVE` or `SUSPENDED` to determine whether the user can access resources.  This makes it relatively straightforward to quickly disable account should the need arise.  Using this method, you can set the status account.  To retrieve the current status, see the [`getAccountStatus()`](getAccountStatus.md) method.

### Syntax

```
void OSecurityUser().setAccountStatus(OSecurityUser.STATUSES status)
```

| Argument | Type | Description |
|---|---|---|
| **`status`** | `OSecurityUser.STATUSES` | Indicates the status that you want to set, which is either `ACTIVE` or `SUSPENDED` |


