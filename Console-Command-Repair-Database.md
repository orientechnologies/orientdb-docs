# Console - `REPAIR DATABASE`

Repairs the database.

**Syntax**

```sql
REPAIR DATABASE [--fix-graph [-skipVertices=<vertices>] [-skipEdges=<edges>]]
                [--fix-links] [-v]]
                [--fix-ridbags]
                [--fix-bonsai]
```

- **`[--fix-graph]`** Fixes the database as graph. All broken edges are removed and all corrupted vertices repaired. This mode takes the following optional parameters:
 - **`-skipVertices=<vertices>`**, where `<vertices>` are the number of vertices to skip on repair.
 - **`-skipEdges=<edges>`**, where `<edges>` are the number of edges to skip on repair.
- **`[--fix-links]`** Fixes links. It removes any reference to not existent records. The optional `[-v]` tells to print more information.
- **`[--fix-ridbags]`** Fixes the ridbag structures only (collection of references). 
- **`[--fix-bonsai]`** Fixes the bonsai structures only (internal representation of trees)

**Examples**

- Repair a graph database:

```
  orientdb> REPAIR DATABASE --fix-graph

  Repair of graph 'plocal:/temp/demo' is started ...
  Scanning 26632523 edges (skipEdges=0)...
  ...
  + edges: scanned 100000, removed 0 (estimated remaining time 10 secs)
  + edges: scanned 200000, removed 0 (estimated remaining time 9 secs)
  + deleting corrupted edge friend#40:22044{out:#25:1429,in:#66:1,enabled:true} v7 because missing incoming vertex (#66:1)
  ...
  Scanning edges completed
  Scanning 32151775 vertices...
  + vertices: scanned 100000, repaired 0 (estimated remaining time 892 secs)
  + vertices: scanned 200000, repaired 0 (estimated remaining time 874 secs)
  + vertices: scanned 300000, repaired 0 (estimated remaining time 835 secs)
  + repaired corrupted vertex Account#25:961{out_friend:[],dateUpdated:Wed Aug 12 19:00:00 CDT 2015,createdOn:Wed Aug 12 19:00:00 CDT 2015} v4
  ...
  + vertices: scanned 32100000, repaired 47 (estimated remaining time 2 secs)
  ...
  Scanning vertices completed
  Repair of graph 'plocal:/temp/demo' completed in 2106 secs
   scannedEdges.....: 1632523
   removedEdges.....: 129
   scannedVertices..: 32151775
   scannedLinks.....: 53264852
   removedLinks.....: 64
   repairedVertices.: 47
```

>For more information on other commands, see [Console Commands](Console-Commands.md).
