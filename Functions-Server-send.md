---
search:
   keywords: ['functions', 'server', 'response', 'send']
---

# Functions - send()

This method is called from the `response` object.  It sends the HTTP response to your application.

## Sending HTTP Responses

When developing an application that interacts with OrientDB through functions and the HTTP protocol, eventually you'll need to send the response back to the requesting application.  Using this method, you can trigger OrientDB to issue the response.

### Syntax

```
var request = response.send(<code>, <reason>, 
	<content-type>, <content>)
var request = response.send(<code>, <reason>, 
	<content-type>, <content>, <headers>)
var request = response.send(<code>, <reason>, 
	<content-type>, <content>, <headers>, 
	<keep-alive>)
```

- **`<code>`** Defines the HTTP response status code, as an integer.
- **`<reason>`** Defines the HTTP response status reason, as a string.
- **`<content-type>`** Defines the HTTP response content type, as a string.
- **`<content>`** Defines the HTTP response content, as a string.
- **`<headers>`** Defines the HTTP response headers, as a string.
- **`<keep-alive>`** Defines whether you want to use a keep alive with the response, as a boolean.

#### Return Value

This method returns the HTTP request object.
