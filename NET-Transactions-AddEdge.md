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
trx.AddEdge( OEdge <edge>,
             OVertex <fromVertex>,
             OVertex <toVerte/>)
```

- **`<edge>`** Defines the edge object you want to add.
- **`<fromVertex>`** Defines the vertex the edge connects from.
- **`<toVertex>`** Defines the vertex th eedge connects to.


### Example

For instance, say that you have a business application that records account information.  In the database for this application you have a vertex class for accounts and another for salespersons.  To assign an account to a salesperson, you create an edge.

```csharp
// ASSIGN ACCOUNT TO EMPLOYEE
public void assignAccount(account, employee)
{
   OEdge assignment = OLoadRecord(connection)
      .ORID(#13:24).Run<OEdge>();

   trx.AddEdge(assignment, account, employee);
}
```



