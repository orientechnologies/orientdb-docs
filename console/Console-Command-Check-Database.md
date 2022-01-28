---
search:
   keywords: ['console', 'command', 'check', 'check database']
---

# Console - `CHECK DATABASE`

Checks the integrity of a database. In the case the database contains graphs, their consistency is checked. To repair a database, use [Repair Database Command](Console-Command-Repair-Database.md).

**Syntax**

```sql
CHECK DATABASE [--skip-graph] [-v]
```

- **`[--skip-graph]`** Skips the check of the graph
- **`[-v]`** Verbose mode

**Examples**

- Check a graph database:

```
  orientdb> CHECK DATABASE

  Check of graph 'plocal:/temp/testdb' is started ...
  Scanning 1 edges (skipEdges=0)...
  + found corrupted edge E#17:0{out:#9:0,in:#11:0,test:true} v2 because incoming vertex (#11:0) does not contain the edge
  Scanning edges completed
  Scanning 710 vertices...
  + found corrupted vertex V#10:0{in_:[#17:0],name:Marko} v2 the edge should be removed from property in_ (ridbag)
  Scanning vertices completed
  Check of graph 'plocal:/temp/testdb' completed in 0 secs
   scannedEdges.....: 1
   edgesToRemove....: 1
   scannedVertices..: 710
   scannedLinks.....: 2
   linksToRemove....: 1
   verticesToRepair.: 0
  Check of storage completed in 296ms.  without errors.
```

>For more information on other commands, see [Console Commands](Console-Commands.md).
