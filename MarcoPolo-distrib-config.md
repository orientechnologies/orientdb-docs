---
search:
   keywords: ['Elixir', 'MarcoPolo', 'distrib-config', 'distributed configuration']
---

# MarcoPolo - `distrib_config()`

This function returns the distributed configuration of the OrientDB Server.

## Working with Distributed Deployments

In deployments where high availability is a concern, OrientDB can run distributed across several servers, allowing you to achieve the maximum in performance, scalability and robustness possible.

When using this deployment architecture, the OrientDB Server pushes data to clients whenever changes occur in the distributed configuration.  In the event that you would like to review or operate on this configuration from within your Elixir application, this function allows you to retrieve it as a [`Document`](MarcoPolo-Document.md) instance.

>For more information on managing these deployments, see [Distributed Architecture](Distributed-Architecture.md).

### Syntax

```
distrib_config(<conn>, <opts>)
```

- **`<conn>`** Defines the database connection.
- **`<opts>`** Defines any additional options you would like to pass to the function.

### Example


