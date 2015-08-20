# Web Applications

The database instances are not thread-safe, so each thread needs a own instance. All the database instances will share the same connection to the storage for the same URL. For more information look at [Java Multi threads and databases](Java-Multi-Threading.md).

Java WebApp runs inside a Servlet container with a pool of threads that work the requests.

There are mainly 2 solutions:
- Manual control of the database instances from **Servlets** (or any other server-side technology like Apache Struts Actions, Spring MVC, etc.)
- Automatic control using **Servlet Filters**

## Manual control

### Graph API

```java
package com.orientechnologies.test;
import javax.servlet.*;

public class Example extends HttpServlet {
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
        throws IOException, ServletException
  {
    OrientBaseGraph graph = new OrientGraph("plocal:/temp/db", "admin", "admin");

    try {
     // USER CODE

    } finally {
      graph.shutdown();
    }
  }
}
```

### Document API

```java
package com.orientechnologies.test;
import javax.servlet.*;

public class Example extends HttpServlet {
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
        throws IOException, ServletException
  {
    ODatabaseDocumentTx database = new ODatabaseDocumentTx("plocal:/temp/db").open("admin", "admin");

    try {
     // USER CODE

    } finally {
      database.close();
    }
  }
}
```

## Automatic control using Servlet Filters

Servlets are the best way to automatise database control inside WebApps. The trick is to create a Filter that get a reference of the graph and binds it in the current ThreadLocal before to execute the Servlet code. Once returned the ThreadLocal is cleared and graph instance released.

[JaveEE Servlets](http://www.oracle.com/technetwork/java/javaee/servlet/index.html)
## Create a Filter class

### Filter with Graph API 

In this example a new graph instance is created per request, opened and at the end closed.
```java
package com.orientechnologies.test;
import javax.servlet.*;

public class OrientDBFilter implements Filter {

  public void doFilter(ServletRequest request, ServletResponse response,
          FilterChain chain) {
      OrientBaseGraph graph = new OrientGraph("plocal:/temp/db", "admin", "admin");
      try{
        chain.doFilter(request, response);
      } finally {
        graph.shutdown();
      }
  }
}
```

### Filter with Document API 

In this example a new graph instance is created per request, opened and at the end closed.
```java
package com.orientechnologies.test;
import javax.servlet.*;

public class OrientDBFilter implements Filter {

  public void doFilter(ServletRequest request, ServletResponse response,
          FilterChain chain) {
      ODatabaseDocumentTx database = new ODatabaseDocumentTx("plocal:/temp/db").open("admin", "admin");
      try{
        chain.doFilter(request, response);
      } finally {
        database.close();
      }
  }
}
```

### Register the filter

Now we've create the filter class it needs to be registered in the **web.xml** file:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://java.sun.com/xml/ns/j2ee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee
         http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd"
         version="2.4">
  <filter>
    <filter-name>OrientDB</filter-name>
    <filter-class>com.orientechnologies.test.OrientDBFilter</filter-class>
  </filter>
    <filter-mapping>
      <filter-name>OrientDB</filter-name>
      <url-pattern>/*</url-pattern>
    </filter-mapping>
    <session-config>
      <session-timeout>30</session-timeout>
    </session-config>
</web-app>
```
