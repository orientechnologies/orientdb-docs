---
search:
   keywords: ['functions', 'open']
---

# Functions - open()

This method opens the database using the given credentials.

## Opening Databases

Using this method you can open a database and authenticate the connection to a particular user.  You might find it useful in cases where you want the function to open the database for you, or when you need to operate briefly on a different database.

### Syntax

```
db.open(<user>, <passwd>)
```

- **`<user>`** Defines the username.
- **`<passwd>`** Defines the user password.
