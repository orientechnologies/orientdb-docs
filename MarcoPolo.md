---
search:
   keywords: ['MarcoPolo', 'Elixir', 'API']
---

# MarcoPolo: Elixir with OrientDB

OrientDB supports a number of application programming interfaces, natively through the JVM and externally through Java wrappers and the Binary Protocol.  In the event that you need or would prefer to develop your OrientDB application Erlang VM language Elixir, you can do so through the driver [MarcoPolo](https://github.com/MyMedsAndMe/marco_polo).

>**NOTE**: OrientDB Documentation for MarcoPolo is currently in development.  If you have a question that is not currently addressed here, please consult the [project documentation](http://hexdocs.pm/marco_polo).

## Getting MarcoPolo

In order to use MarcoPolo in your Elixir application, you first need to register it as a dependency for the Mix build tool.  To do so, edit the `mix.exs` file in the project root directory and add MarcoPolo as a dependency to the `deps` function.

```elixir
# Project Dependencies
def deps do
	[{:marco_polo, "~> 0.1"}]
end
```

With this line added, Mix now knows that your application requires MarcoPolo.  To retrieve and compile the package, use Mix:

<pre>
$ <code class="userinput lang-sh">mix deps.get</code>
$ <code class="userinput lang-sh">mix deps.compile</code>
</pre>

When you run the `deps.get` command, Mix calls the [Hex](https://hex.pm) package manager to fetch the MarcoPolo package and its dependencies.  The second command then compiles these packages for use with your application.  You can see that the dependencies were installed without error by calling Mix again with the `deps` argument:

<pre>
$ <code class="userinput lang-sh">mix deps</code>
...
* marco_polo 0.2.2 (Hex package) (mix)
  locked at 0.2.2 (marco_polo) 40x47150
  ok
</pre>


## Using MarcoPolo

Once you have registered MarcoPolo as a dependency with Mix you can begin to use it in developing your Elixir application.

```elixir
@doc """ Connects to OrientDB Server """
@spec connect_orientdb_server(String.t, String.t) :: {:ok, conn} | {:error, term}
def connect_orientdb_server(String user, String passwd) do 
	{:ok, conn} = MarcoPolo.start_link(
		user: user, password: passwd, connection: :server)
end
```
