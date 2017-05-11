# MarcoPolo - `BinaryRecord` 

This struct represents binary data in your Elixir application.  It rends as an `ORecordBytes` class in OrientDB.

## Working with Binary Records


```
%MarcoPolo.BinaryRecord{
	:rid <record-id>,
	:contents <record-data>,
	:version <record-version>}
```

- **`<record-id>`** Defines the Record ID, an instance of [MarcoPolo.RID](MarcoPolo-RID.md).
- **`<record-data>`** Defines record data.
- **`<record-version>`** Defines the record version, a non-negative integer.

### Example

In cases where you create binary records frequently with the same data, you might create a function to generate the struct from limited data.  For instance, say you have a web application where new blog entries are all created on the same cluster:

```elixir
@doc """ Create binary record of blog entry """
def gen_blog(blog_data) do
	
	# Create and Return Binary Record
	%MarcoPolo.BinaryRecord{
		:rid MarcoPolo.RID(:cluster 14),
		:contents blog_data,
		:version 1}

end
```

