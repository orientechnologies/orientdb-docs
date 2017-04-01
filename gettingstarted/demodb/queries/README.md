
## Queries

This Section includes several query examples that you can execute from the [Studio](../../../studio/README.md)'s _Browse Tab_, or from its _Graph Editor_. You may also execute these queries directly from the [Console](../../../console/README.md), or your application through an [API or Driver](../../../apis-and-drivers/README.md).  

{% include "../include-demodb-version-warning.md" %}

The following table can help you navigate through all examples:

|Category                    | Question                                                                                                                | Link
|----------------------------|-------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| **Profiles**               | Find the 'year of birth' of the Profiles, and how many Profiles were born in the same year                              | [Link](DemoDB-Queries-Profiles.md#example-1)                 |
|                            | Find the top 3 Profiles that have the highest number of Friends                                                         | [Link](DemoDB-Queries-Profiles.md#example-2)                 |
| **Friendship**             | Find Santo's Friends                                                                                                    | [Link](DemoDB-Queries-Friendship.md#example-1)               |
|                            | Find Santo's Friends who are also Customers                                                                             | [Link](DemoDB-Queries-Friendship.md#example-2)               |
|                            | Find Santo's Friends who are also Customers, and the Countries they are from                                            | [Link](DemoDB-Queries-Friendship.md#example-3)               |
|                            | Find Santo's Friends who are also Customers, and the Orders they have placed                                            | [Link](DemoDB-Queries-Friendship.md#example-4)               |
|                            | Among Santo's Friends, find the top 3 Customers that placed the highest number of Orders                                | [Link](DemoDB-Queries-Friendship.md#example-5)               |
|                            | Among Santo's Friends, find the top 3 Customers that visited the highest number of Places                               | [Link](DemoDB-Queries-Friendship.md#example-6)               |
|                            | Find all the Friends of Customer identified with OrderedId 1 that are not Customers (so that a product can be proposed) | [Link](DemoDB-Queries-Friendship.md#example-7)               |
| **Customers**              | {{book.demodb_query_24_text}} | [Link](DemoDB-Queries-Customers.md#example-1)                |
|                            | {{book.demodb_query_25_text}} | [Link](DemoDB-Queries-Customers.md#example-1)                |
|                            | {{book.demodb_query_26_text}} | [Link](DemoDB-Queries-Customers.md#example-2)                |
|                            | {{book.demodb_query_27_text}} | [Link](DemoDB-Queries-Customers.md#example-3)                |
|                            | {{book.demodb_query_28_text}} | [Link](DemoDB-Queries-Customers.md#example-4)                |
|                            | {{book.demodb_query_29_text}} | [Link](DemoDB-Queries-Customers.md#example-5)                |
|                            | {{book.demodb_query_30_text}} | [Link](DemoDB-Queries-Customers.md#example-6)                |
|                            | {{book.demodb_query_31_text}} | [Link](DemoDB-Queries-Customers.md#example-7)                |
|                            | {{book.demodb_query_32_text}} | [Link](DemoDB-Queries-Customers.md#example-8)                |
|                            | {{book.demodb_query_33_text}} | [Link](DemoDB-Queries-Customers.md#example-9)                |
|                            | {{book.demodb_query_34_text}} | [Link](DemoDB-Queries-Customers.md#example-10)               |
| **Countries**              |   | [Link](DemoDB-Queries-Countries.md#example-1)                   |
| **Orders**                 | Calculate the total revenues from Orders  | [Link](DemoDB-Queries-Orders.md#example-1)                   |
|                            | Find the year of the Orders, and how many Orders have been placed in the same year | [Link](DemoDB-Queries-Orders.md#example-2)                   |
| **Attractions**            |                                                                        | [Link](DemoDB-Queries-Attractions.md#example-1)                 |
| **Services**               | Find the 3 Hotels that have been booked most times                                                                      | [Link](DemoDB-Queries-Services.md#example-1)                 |
|                            | Find the 3 Hotels that have most reviews                                                                                | [Link](DemoDB-Queries-Services.md#example-2)                 |
|                            | Find the top 3 nationality of the tourists that have eaten at Restaurant with Id 13                                     | [Link](DemoDB-Queries-Services.md#example-3)                 |
| **Locations**              | Find all Attractions connected with Customer with OrderedId 1                                                           | [Link](DemoDB-Queries-Locations.md#example-1)                |
|                            | Find all Services connected with Customer with OrderedId 1                                                              | [Link](DemoDB-Queries-Locations.md#example-2)                |
|                            | Find all Locations connected to Customer with Id 1                                                                      | [Link](DemoDB-Queries-Locations.md#example-3)                |
|                            | Find all Locations connected to Customer with Id 1, and their Reviews (if any)                                          | [Link](DemoDB-Queries-Locations.md#example-4)                |
|                            | Find all Locations visited by Customer with OrderedId 2                                                                 | [Link](DemoDB-Queries-Locations.md#example-5)                |
|                            | Find all Locations visited by Santo's friends                                                                           | [Link](DemoDB-Queries-Locations.md#example-6)                |
| **Reviews**                | Find number of Reviews per star                                                                                         | [Link](DemoDB-Queries-Reviews.md#example-1)                  |
|                            | Find all reviewed Services                                                                                              | [Link](DemoDB-Queries-Reviews.md#example-2)                  |
|                            | Find all reviewed Services and the Customer who made the review                                                         | [Link](DemoDB-Queries-Reviews.md#example-3)                  |
|                            | Find the numbers of reviews per Service                                                                                 | [Link](DemoDB-Queries-Reviews.md#example-4)                  | 
|                            | Find the 3 Hotels that have most reviews                                                                                | [Link](DemoDB-Queries-Reviews.md#example-5)                  |
|                            | Find the 3 Customers who made more reviews                                                                              | [Link](DemoDB-Queries-Reviews.md#example-6)                  |
| **Recommendations**        | Recommend some friends to Profile 'Isabella Gomez' (friends of friends) | [Link](DemoDB-Queries-Recommendations.md#example-1)          |
|                            | Recommend some Hotels to Customer with OrderedId 1 | [Link](DemoDB-Queries-Recommendations.md#example-2)          |
| **Business Opportunities** | Find all the Friends of Customer identified with OrderedId 1 that are not Customers (so that a product can be proposed) | [Link](DemoDB-Queries-Business-Opportunities.md#example-1)   |
|                            | {{book.demodb_query_14_text}}        | [Link](DemoDB-Queries-Business-Opportunities.md#example-2)   |
| **Polymorphism**           | Find all Locations (Services + Attractions) connected with Customer with OrderedId 1                                    | [Link](DemoDB-Queries-Polymorphism.md#example-1)             |
|                            | Find the 3 Services (Hotels + Restaurants) that have most reviews                                                       | [Link](DemoDB-Queries-Polymorphism.md#example-2)             |
| **Shortest Paths**         | Find the shortest path between the Profile 'Santo' and the Country 'United States'                                      | [Link](DemoDB-Queries-Shortest-Paths.md#example-1)           |
| **Traverses**              | Traverse everything from Profile 'Santo' up to depth three                                                              | [Link](DemoDB-Queries-Traverses.md#example-1)                |
|                            | Traverse everything from Country 'Italy' up to depth three                                                              | [Link](DemoDB-Queries-Traverses.md#example-2)                |