
# MarcoPolo - `Document`

This struct defines a document for your Elixir application.  It renders as an `ODocument` class in OrientDB.

## Working with Documents

```
%MarcoPolo.Document{
	:rid <rid>,
	:class <class>,
	:version <version>,
	:fields <data>}
```

- **`<rid>`** Defines the Record ID.  It is an instance of [MarcoPolo.RID](MarcoPolo-RID.md).
- **`<class>`** Defines the record class.
- **`<version>`** Defines the record version.
- **`<data>`** Defines the record data.


### Example

In cases where your application generates a series of very similar documents, you might create a function that populates default values:

```elixir
@doc """ Generate Blog Document """
def gen_blogdoc(title, text) do

	%MarcoPolo.Document{
		:rid MarcoPolo.RID(:cluster 4),
		:class "BlogEntry",
		:version 1,
		:fields %{
			"title" => title
			"text" => text}}
end
```
