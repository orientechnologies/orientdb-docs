
# MarcoPolo - `RID`

This struct defines a Record ID for your Elixir application.  It renders as an `ORID` instance in OrientDB.

## Working with Record ID's

```
%MarcoPolo.RIDr{
	:cluster_id <cluster>,
	:position <position>}
```

- **`<cluster>`** Defines the cluster the record occurs in.
- **`<position>`** Defines the position of the record in the cluster.
