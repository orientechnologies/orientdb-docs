---
search:
   keywords: ['C#', 'c sharp', 'NET', 'transaction', 'add', 'edge', 'AddEdge']
---

# OrientDB-NET - `AddEdge()`

This method is used to add an edge to the database.  The new edge remains a part of the transaction until you commit the change and can be moved by rolling back to an earlier state.

## Adding Edges

In order to add an edge to the database, you need to create an `OEdge` object, then call the `AddEdge()` method, passing to it the connecting vertices as arguments.

### Syntax

```
OTransaction.AddEdge( OEdge edge,
             OVertex fromVertex,
             OVertex toVertex)
```

- **`edge`** Defines the edge object you want to add.
- **`fromVertex`** Defines the vertex the edge connects from.
- **`toVertex`** Defines the vertex th eedge connects to.


### Example

In cases where you have a class that connects to multiple edges, you may find it more convenient to use a helper function to quickly define and add edges to records.


```csharp
using Orient.Client;
using System;
...

// CONNECT EDGES
public void TrxConnectEdges(OTransaction trx, Dictionary<OEdge, Dictionary<string, OVertex>> edges)
{
   // LOG OPERATION
   Console.WriteLine("Adding Edges");

   // LOOP OVER EACH EDGE
   foreach(KeyValuePair<OEdge, Dictionary<string, OVertex>> edge in edges)
   {
      // DEFINE VERTICES
      OVertex from = edge.Value['from'];
      OVertex to = edge.Value['to'];

      // ADD VERTICES
      trx.AddEdge(edge.Key, from, to);
   }
}
```
