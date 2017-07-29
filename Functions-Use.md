---
search:
   keywords: ['function', 'use', 'javascript', 'sql']
---

# Using Functions

Once you have created a function, whether using [Studio](Studio-Functions.md) or the OrientDB SQL [`CREATE FUNCTION`](SQL-Create-Function.md) command, you can begin to use it to operate on the database.

## Calling Functions in SQL

Calling custom functions works the same as calling the standard SQL [functions](SQL-Functions.md) that OrientDB ships by default.  For instance, consider the earlier example of a `factorial()` function.

<pre>
orientdb> <code class="lang-sql userinput">SELECT factorial(5,3)</code>
</pre>

This works well if you want to pass specific values to the function.  You can also pass values from the database to the function.  For instance, using `sum()` you might want to combine salary fields with bonuses.

<pre>
orientdb> <code class="lang-sql userinput">SELECT sum(salary, bonus) AS total FROM Employee</code>
</pre>


## Calling Functions from Java

When working in Java you can use functions from OrientDB, both as general functions in your application and working with content from the database.  In order to use functions in your application, you first need to retrieve it from the database.

1. Get the reference to the Function Manager
1. Get the function you want to use.
1. Execute the function.

For instance, imagine you want to retrieve the `factorial()` function created in the example.  You would need to open a database and retrieve an `OFunction` instance from your database.

```java
// Open Database
ODatabaseDocument db = new ODatabaseDocumentTx("plocal:/tmp/db");
db.open("admin", "admin");

// Retrieve Function
OFunction factorial = db.getMetadata().getFunctionLibrary().getFunction("factorial");

// Use Factorial Function
Number result = factorial.execute(24);
```

Alternatively, you can retrieve the function using the Blueprints Graph API:

```java
// Retrieve Function
OFunction factorial = graph.getRawGraph().getMetadata().getFunctionLibrary().getFunction("factorial");

// Use Factorial Function
Number result = factorial.execute(24);
```

Whichever approach you use to retrieve a function from OrientDB, you can define the arguments passed to the function by their position or by mapping the argument names to values in a map.  You might find this latter method more useful to avoid confusion when working with complex functions that take several arguments, but it works just as well in cases where the function takes a single argument alone.

```java
// Report Factorials from List
public void reportFactorials(List<Number> inputValues) {

	// Retrieve Factorial Function
	ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/tmp/db");
	db.open("admin", "admin");
	OFunction factorial = db.getMetadata().getFunctionLibrary().getFunction("factorial");

	// Loop over Input Values
	for (int i = 0; i < inputValues.size(); i++) {
		
		// Fetch Number
		Number number = list.get(i);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("num", number);

		// Calculate Factorial
		Number result = factorial(number);

		// Report Results
		System.out.println(String.format("Factorial of %d: %d", number, result));

	}
}
```

## Calling Functions from the HTTP REST API

Functions in OrientDB are accessible to REST services.  They receive parameters by position through the URL.  Beginning in version 2.1, OrientDB also supports defining parameters in JSON through the request payload.

For instance, imagine you created the `factorial()` function used in the previous examples on the `OpenBeer` example database.  Using cURL, you can execute the function and retrieve the result of say the factorial of 10:

<pre>
$ <code class="lang-sh userinput">curl --user admin:admin \
      http://localhost:2480/function/OpenBeer/factorial/10</code>
{"result":[{"@type":"d","@version":0,"value":3628800.0,"@fieldTypes":"value=d"}]}
</pre>

Similarly, you can perform the same operation passing the arguments in a JSON payload:

<pre>
$ <code class="lang-sh userinput">curl --user admin:admin --data '{"num": 10}' \
      http://localhost:2480/function/OpenBeer/factorial</code>
{"result":[{"@type":"d","@version":0,"value":3628800.0,"@fieldTypes":"value=d"}]
</pre>

Whichever method you use, the OrientDB REST API returns an HTTP 202 OK with an envelope containing the results of the operation.

Note that you can only call idempotent functions using the HTTP GET method.  When the function is non-idempotent, you need to use the HTTP POST method.  When making requests using HTTP POST, encode the content and set the HTTP request header to `"Content-Typpe: application/json"`.


>For more information, see 
>- [HTTP REST Protocol](OrientDB-REST.md#function). 
>- [Server-side Functions](Functions-Server.md)

### HTTP Return Values 

When calling a function through a REST service, OrientDB returns the results as JSON to the client through HTTP.  There may be differences in the results, depending on the return value of function.

For instance,

- Function that returns a number:

  ```javascript
  return 31;
  ```

  Would return the result:

  ```json
  {"result":[{"@type":"d","@version":0,"value":31}]}
  ```

- Function that returns a JavaScript object:

  ```
  return {"a":1, "b":"foo"}
  ```

  Would return the result:

  ```json
  {"result":[{"@type":"d","@version":0,"value":{"a":1,"b":"foo"}}]}
  ```

- Function that returns an array:

  ```javascript
  return [1, 2, 3]
  ```

  Would return the result:

  ```json
  {"result":[{"@type":"d","@version":0,"value":[1,2,3]}]}
  ```

- Function that returns a query result:

  ```javascript
  return db.query("SELECT FROM OUser")
  ```

  Would return the result:

  ```json
  {
    "result": [
        {
            "@type": "d",
            "@rid": "#6:0",
            "@version": 1,
            "@class": "OUser",
            "name": "admin",
            "password": "...",
            "status": "ACTIVE",
            "roles": [
                "#4:0"
            ],
            "@fieldTypes": "roles=n"
        },
        {
            "@type": "d",
            "@rid": "#6:1",
            "@version": 1,
            "@class": "OUser",
            "name": "reader",
            "password": "...",
            "status": "ACTIVE",
            "roles": [
                "#4:1"
            ],
            "@fieldTypes": "roles=n"
        }
    ]
  }
  ```
