---
search:
   keywords: ['java', 'ointent']
---

# OIntent

Declaring an Intent allows you to optimize OrientDB in one call for a specific class of operations.  While these declaration won't offer you much benefit under general usage, they can dramatically speed up performance for a specific task, such as a large insert or complex read.

Currently, OrientDB supports the following intents:

| Intent  | Description |
|---|---|
| **`OIntentMassiveInsert`** | Optimizes OrientDB for a large write operation |
| **`OIntentMassiveRead`** | Optimizes OrientDB for a large read operation |
| **`OIntentNoCache`** | Optimizes OrientDB to operate without a cache |

Each of these classes is a subclass of `OIntent`.




