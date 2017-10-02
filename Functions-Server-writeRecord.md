---
search:
   keywords: ['functions', 'server', 'response', 'write record', 'writeRecord']
---

# Functions - writeRecord()

This method is called from the `response` object.  It writes an OrientDB record to the HTTP response.

## Writing Records

When developing applications that interact with OrientDB through functions and the HTTP protocol, you may want to return database records to your application.  Using this method, you can add a an individual record identified by its Record ID's to the HTTP response.  The record is serialized into the HTTP response using the JSON format.

### Syntax

```
var response = response.writeRecord(<record>)

var response = response.writeRecord(<record>, <fetch-plan>)
```

- **`<records>`** Defines the Record ID's for the record you want to write.
- **`<fetch-plan>`** Defines a string to serve as a [fetching strategy](Fetching-Strategies.md) to determine how the method retrieves the record.

#### Return Value

This method returns the HTTP response object.
