# Getting Started

In the last few years, there's been an explosion of many NoSQL solutions and products. The meaning of the word "NoSQL" is not a campaign against the SQL language. In fact, OrientDB allows for SQL syntax! NoSQL is
probably best described by the following:

>NoSQL, meaning "not only SQL", is a movement encouraging developers and business people to open their
>minds and consider new possibilities beyond the classic relational approach to data persistence.

Alternatives to relational database management systems have existed for many years, but they have been
relegated primarily to niche use cases such as telecommunications, medicine, CAD and others. Interest in NoSQL alternatives like OrientDB is increasing dramatically. Not surprisingly many of the largest web companies like Google, Amazon, Facebook, Foursquare, and Twitter are using NoSQL based solutions in
production environments.

What motivates companies to leave the comfort of a well established relational database world? It all
surrounds the fact that you can better solve today's data problems with a modern database. Specifically, there are a few key areas:
- Performance
- Scalability (often extreme)
- Smaller footprint
- Developer productivity
- Schema flexibility

Most of these areas also happen to be requirements of modern web applications. A few years ago, developers designed systems that could handle hundreds of concurrent users. Today it is not uncommon to have a potential target of thousands or millions of users connected and served at the same time.

Changing technology requirements have been taken into account on the application front by creating frameworks, introducing standards and leveraging best practices. However, in the database world, the situation has remained more or less the same for over 30 years. From the 1970s until recently, relational DBMSs have played the dominant role. Programming languages and methodologies have evolved, but the concept of data persistence and DBMS have remained unchanged for the most part: tables, records and joins.

## NoSQL Models

NoSQL-based solutions in general provide a powerful, scalable, and flexible way to solve data needs and use cases which have previously been managed by relational databases. To summarize the NoSQL options, we'll examine the most common models or categories:
- **Key / Value databases**: data model is reduced to a simple hash table which consists of key / value pairs. It is often easily distributed across multiple servers. The most recognized products of this group include Redis, Dynamo, and Riak.
- **Column-oriented databases**: data is stored in sections of columns offering more flexibility and easy aggregation. Facebook's Cassandra, Google's BigTable, and Amazon's SimpleDB are some examples of column-oriented databases.
- **Document databases**: data model consists of document collections where individual documents can have multiple fields without necessarily defining a schema. The best known products of this group are MongoDB and CouchDB.  
- **Graph databases**: domain model consists of vertices interconnected by edges creating a rich graph structure. The best known products of this group are OrientDB and Neo4j.

>OrientDB is a document-graph database, meaning it has full native graph capabilities coupled with
>features normally only found in document databases.

Each of these categories or models has its own peculiarities, strengths and limitations. There is not a single category or model which is better than all the others, however certain types of databases are better at solving specific problems. This leads to the motto of NoSQL: choose the best tool for your specific use case.

The goal of Orient Technologies in building OrientDB was to create a robust, highly performant database that can perform optimally in the widest possible set of use cases. Our product is designed to be the best "go to" solution for data persistence. In the following parts of this tutorial, we will look closely at **OrientDB**, the original open-source, multi-model, next generation NoSQL product.