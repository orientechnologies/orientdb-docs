# Gephi Visual Tool

![image](https://gephi.github.io/images/screenshots/preview4.png)

# Introduction

[Gephi](http://gephi.org) is a visual tool to manipulate and analyze graphs. [Gephi](http://gephi.org) is an Open Source project. Take a look at the amazing [features](http://gephi.org/features/).

[Gephi](http://gephi.org) can be used to analyze graphs extracted from OrientDB. There are 2 level of integration:
- the [Streaming plugin](https://gephi.org/plugins/graph-streaming/) that calls OrientDB server via HTTP. OrientDB exposes the new "/gephi" command in HTTP GET method that executes a query and returns the result set in "gephi" format.
- [Gephi importer for Blueprints](https://github.com/datablend/gephi-blueprints-plugin/wiki)

In this mini guide we will take a look at the first one: the streaming plugin.

For more information:
- [Gephi Graph Streaming format](https://github.com/gephi/gephi/wiki)
- [Graph Streaming plugin](https://gephi.org/plugins/graph-streaming/)
- [Tutorial video](http://www.youtube.com/watch?v=7SW_FDiY0sg)

# Getting started

Before to start assure you've [OrientDB 1.1.0-SNAPSHOT](https://oss.sonatype.org/content/groups/public/com/orientechnologies/orientdb/1.1.0-SNAPSHOT/) or greater.

## Download and install

1. To download Gephi goto: http://gephi.org/users/download/
1. Install it, depends on your OS
1. Run Gephi
1. Click on the menu **Tools** -> **Plugins**
1. Click on the tab **Available Plugins**
1. Select the plugin **Graph Streaming**, click on the **Install** button and wait the plugin is installed

## Import a graph in Gephi

Before to import a graph assure a OrientDB server instance is running somewhere. For more information watch this [video](http://www.youtube.com/watch?v=7SW_FDiY0sg).

1. Go to the **Overview** view (click on **Overview** top left button)
1. Click on the **Streaming** tab on the left
1. Click on the big **+** green button
1. Insert as **Source URL** the query you want to execute. Example:  <code>http://localhost:2480/gephi/demo/sql/select%20from%20v/100</code> (below more information about the syntax of query)
1. Select as **Stream type** the **JSON** format (OrientDB talks in JSON)
1. Enable the **Use Basic Authentication** and insert the user and password of OrientDB database you want to access. The default user is "admin" as user and password
1. Click on **OK** button

# Executing a query

The OrientDB's "/gephi" HTTP command allow to execute any query. The format is:

```
http://<host>:<port>/gephi/<database>/<language>/<query>[/<limit>]
```

Where:
- **<code>host</code>** is the host name or the ip address where the OrientDB server is running. If you're executing OrientDB on the same machine where Gephi is running use "localhost"
- **<code>port</code>** is the port number where the OrientDB server is running. By default is 2480.
- **<code>database</code>** is the database name
- **<code>language</code>**
- **<code>query</code>**, the query text following the [URL encoding rules](http://www.w3schools.com/tags/ref_urlencode.asp). For example to use the spaces use <code>%20</code>, so the query <code>select from v</code> becomes <code>select%20from%20v</code>
- **<code>limit</code>**, optional, set the limit of the result set. If not defined 20 is taken by default. <code>-1</code> means no limits

## SQL Graph language

To use the OrientDB's SQL language use **<code>sql</code>** as language. For more information look at the [SQL-Syntax](SQL-Query.md).

For example, to return the first 1,000 vertices (class V) with outgoing connections the query would be:
```sql
SELECT FROM V WHERE out.size() > 0
```

Executed on "localhost" against the "demo" database + encoding becomes:
```
http://localhost:2480/gephi/demo/sql/select%20from%20V%20where%20out.size()%20%3E%200/1000
```

## GREMLIN language

To use the powerful GREMLIN language to retrieve the graph or a portion of it use **<code>gremlin</code>** as language. For more information look at the [GREMLIN syntax](Gremlin.md).

For example, to return the first 100 vertices:
```
g.V[0..99]
```

Executed on "localhost" against the "demo" database + encoding becomes:
```
http://localhost:2480/gephi/demo/gremlin/g.V%5B0..99%5D/-1
```

For more information about using Gephi look at [Learn how to use Gephi](http://gephi.org/users/)
