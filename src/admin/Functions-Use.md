
# Using Functions

## Call Functions via SQL

All the database functions are automatically registered in the SQL Engine. 

**Examples**

- Calling the sum function from SQL with static parameters:

  ```sql
  SELECT SUM(3,4)
  ```
  
- Calling the sum function from SQL with parameters taken from database:

  ```sql
  SELECT SUM(salary,bonus) AS total FROM Employee
  ```

  In this case the function SUM is invoked for each record in the Employee class by passing the value of the fields `salary` and `bonus`.

## Functions using the Java API

Using OrientDB functions from the Java API is relatively straightforward:

1. Get the reference to the Function Manager
1. Get the function you want to use.
1. Execute the function.

**Examples**

- Passing the parameters by position:

  ```java
  ODatabaseDocumentTx db = new ODatabaseDocumentTx("local:/tmp/db");
  db.open("admin", "admin");
  OFunction sum = db.getMetadata().getFunctionLibrary().getFunction("sum");
  Number result = sum.execute(3, 5);
  ```

- Using the Blueprints Graph API:


  ```java
  OFunction sum = graph.getRawGraph().getMetadata().getFunctionLibrary().getFunction("sum");
  ```

- Execute the function by passing the parameters by name:

 ```java
  Map<String,Object> params = new  HashMap<String,Object>();
  params.put("a", 3);
  params.put("b", 5);
  Number result = sum.execute(params);
  ```

## Functions using the HTTP REST API

OrientDB exposes functions as a REST service, through which it can receive parameters.  Parameters are passed by position in the URL.  Beginning with OrientDB version 2.1, you can also pass parameters in the request payload as JSON.  In which case, the mapping is not positional, but by name.

**Examples**

- Execute the `sum` function, passing `3` and `5` as parameters in the URL:

  ```
  http://localhost:2480/function/demo/sum/3/5
  ```
  
- Execute the `sum` function, passing `3` and `5` in the request's payload:

  ```json
  {"a": 3, "b": 5}
  ```
  
Each example returns an HTTP 202 OK with an envelope containing the result of the calculation:

```json
{"result":[{"@type":"d","@version":0,"value":2}]}
```

You can only call functions with the HTTP GET method if you delcare it as `idempotent`.  You can call any functions using the HTTP POST method.

When executing functions with the HTTP POST method, encode the content and set the HTTP request header to: `"Content-Type: application/json"`.

>For more information, see 
>- [HTTP REST Protocol](../misc/OrientDB-REST.md#function). 
>- [Server-side Functions](Functions-Server.md)

### Function Return Values in HTTP

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



