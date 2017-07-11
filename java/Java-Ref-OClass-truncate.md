---
search:
   keywords: ['Java API', 'OClass', 'class', 'truncate']
---

# OClass - truncate()

This method removes all data from all clusters the class uses.

## Truncating Class

Classes have one or more clusters that they use to store records on the database.  When your application has been running for a while, you may encounter issues that require basic or drastic housekeeping on the database.  Using this method you can truncate all clusters associated with the class, removing all data from each cluster.

### Syntax

```
void OClass().truncate()
```
