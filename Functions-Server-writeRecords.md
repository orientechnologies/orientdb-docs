---
search:
   keywords: ['functions', 'server', 'response', 'write records', 'writeRecords']
---

# Functions - writeRecords()

This method is called from the `response` object.  It writes a list of OrientDB records to the HTTP response.

## Writing Records

When developing applications that interact with OrientDB through functions and the HTTP protocol, you may want to return database records to your application.  Using this method, you can add a series of records identified by their Record ID's to the HTTP response.  The records are serialized into the HTTP response using the JSON format.

### Syntax

```
var response = response.writeRecords(<records>)

var response = response.writeRecords(<records>, <fetch-plan>)
```

- **`<records>`** Defines an array of Record ID's for the records you want to write.
- **`<fetch-plan>`** Defines a string to serve as a [fetching strategy](Fetching-Strategies.md) to determine how the method retrieves the records.

#### Return Value

This method returns the HTTP response object.
