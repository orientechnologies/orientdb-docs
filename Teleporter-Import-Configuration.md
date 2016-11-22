---
search:
   keywords: ['teleporter', 'inheritance', 'configuration']
---

# Import Configuration

It's possible to specify an import configuration by writing down a **configuration file in JSON format** and passing its location to Teleporter through the argument `-conf`:


```
./oteleporter.sh -jdriver <jdbc-driver> -jurl <jdbc-url> -juser <username> 
                -jpasswd <password> -ourl <orientdb-url> [-s <strategy>]
                [-nr <name-resolver>] [-v <verbose-level>] 
                ([-include <table-names>] | [-exclude <table-names>]) 
                [-inheritance <orm-technology>:<ORM-file-url>] 
                [-conf <configuration-file-location>]


```

For example if you want enrich your migration from Postgresql with a configuration file `migration-config.json` located in the `/tmp` folder you can type:

```
./oteleporter.sh -jdriver postgresql -jurl jdbc:postgresql://localhost:5432/testdb 
                -juser username -jpasswd password -ourl plocal:$ORIENTDB_HOME/databases/testdb 
                -conf /tmp/migration-config.json

```

After the first migration, the graph database will be built and the configuration you passed as argument to Teleporter **will be copied into the database** folder in a path like that:

```
ORIENDB_HOME/testdb/teleporter-config/migration-config.json
```

In the following executions the new configuration in your database will be processed automatically, making coherent and simpler the synchronization procedure. If you want change any setting you can modify directly that file.  
In fact Teleporter, at execution time, **sequentially looks for**:

1. the configuration file `migration-config.json` in the database directory **ORIENDB_HOME/<you-target-db>/teleporter-config/**
2. if no config file will be found, then a **potential input config** will be considered 
3. if no config file was passed as argument the **migration will be performed without any configuration**


## Relationship configuration

The configuration allows you to **manage the relationships of your database domain**.  
To comprehend the importance of this feature we have to consider that Teleporter builds the schema in OrientDB and carries out the migration starting from the source DB schema: **Vertices and Edges are built starting from Entities (tables) and Relationships (foreign keys)** which are inferred from your database metadata.  
Therefore if you didn't defined some constraints, such as foreign keys between the tables on which you usually perform join operations, you will lose this kind of info during the importing process.  
To be clear **if no foreign keys are declared in the schema, you will not have any edges in your final Graph Database**.

So if some constraints are not defined in your schema for performance reasons, submitting a configuration file is essential in order to obtain a complete graph model and perform a good and effective migration to OrientDB.

You can do that by **enriching the basic mapping** of Teleporter between the **E-R model and the Graph Model** to customize your importing. You can add new relationships or modify info about relationships already defined in your database schema, interacting directly on the domains-mapping carried out by Teleporter.  
Each Relationship expressed in your schema through a foreign key will be transformed into an Edge class in the graph model according to automatic choices that implicate:

- the **name** of the Edge
- the **direction** of the Edge
- the **properties** of the Edge
- the **type** of each property and potential constraints (mandatory, readOnly, notNull)

So you can intervene in this mapping and make your personal choices.

Let's start to analyse the syntax in order to examine the two main actions you can manage during the migration:

- **adding relationships** not declared in your schema
- **modifying relationships** present in your schema


###Adding Relationships

The JSON syntax of the **configuration file** will appear very intuitive if you bear in mind that it **reflects the mapping between the E-R model and the Graph Model**.  
Let's consider the configuration below:

```
{
	"edges": [{
		"WorksAtProject": {
			"mapping": {
				"fromTable": "EMPLOYEE",
				"fromColumns": ["PROJECT"],
				"toTable": "PROJECT",
				"toColumns": ["ID"],
				"direction": "direct"
			},
			"properties": {
				"updatedOn": {
					"type": "DATE",
					"mandatory": true,
					"readOnly": false,
					"notNull": false
				}
			}
		}
	}]
}
```

We are defining all the edges we want to map through the key `edges` which contains an array of elements. Each element in the array is an **Edge class definition containing the mapping with a Relationship** in the relational model.  
Let's suppose we have two entities "Employee" and "Project" in our database with a logical Relationship between them: starting from an Employee you can navigate the Projects he's working at.


```
		  EMPLOYEE                                                     PROJECT
	      (Foreign Table)                                              (Parent Table)
 ________________________________________________                _____________________________________
|       |              |             |           |              |       |         |                   |
|  ID   |  FIRST_NAME  |  LAST_NAME  |  PROJECT  |              |  ID   |  TITLE  |  PROJECT_MANAGER  |
|_______|______________|_____________|___________|              |_______|_________|___________________|
|       |              |             |           |              |       |         |                   |
|       |              |             |           |              |       |         |                   |
|_______|______________|_____________|___________|              |_______|_________|___________________|


```

Without a foreign key definition we lose this Relationship and we obtain a graph model without the correspondent Edge class; consequently no edges between vertices of class "Employee" and vertices of class "Project" will be present.

<img: tables without FK --> graph model wihtout edge class --> graph without edges>

Through this mapping we can **overcome the lack of a foreign key** and recover the lost info.  
Let's take a look closer to the **edge mapping**:

```
{
	"WorksAtProject": {
		"mapping": {
			"fromTable": "EMPLOYEE",
			"fromColumns": ["PROJECT"],
			"toTable": "PROJECT",
			"toColumns": ["ID"],
			"direction": "direct"
		},
		"properties": {
			"updatedOn": {
				"type": "DATE",
				"mandatory": true,
				"readOnly": false,
				"notNull": false
			}
		}
	}
}
```

We are mapping the Edge class "WorksAtProject" with a Relationship with cardinality 1-N between "Employee" and "Project" on the basis of 4 essential values:

- **fromTable**: the foreign entity that import the primary key of the parent table. In the example is the table "EMPLOYEE".        
- **fromColumns**: the attributes involved in the foreign key. In the example it's the field "PROJECT" in the table "EMPLOYEE".
- **toTable**: the parent entity whose primary key is imported by the foreign table. In the example is the table "PROJECT". - **toColumns**: the attributes involved in the primary key imported. In the example it's the field "ID" in the table "PROJECT".

As this Relationship is not declared in your database, it will be added and the correspondent Edge will be built according to the other info you can set.

With the key `direction` you can express the direction of the edges between the vertices. You can set this argument with two different values:

- **direct**: the edge will reflect the direction of the relationship.
- **inverse**: the edge will have opposite direction respect to the relationship.

So if we define in the configuration file a relationship as follows:

```
"WorksAtProject": {
		"mapping": {
			"fromTable": "EMPLOYEE",
			"fromColumns": ["PROJECT"],
			"toTable": "PROJECT",
			"toColumns": ["ID"],
			"direction": "direct"
		},
 		...
}
```
a new Relationship will be added

```
EMPLOYEE -----------------------------> PROJECT
	   fromTable    =  EMPOYEE
	   toTable      =  PROJECT
	   fromColumns  =  [PROJECT]
	   TOColumns    =  [ID]
```

and choosing "direct" direction, or don't declaring anything about that, we will obtain an Edge like that:

```
Employee ----[WorksAtProject]----> Project
```

Suppose we want have the **inverse logical navigation** in the graph database that we could not express in the relational model.  
Here is the configuration we must use:

```
		"HasCommittedEmployee": {
			"mapping": {
				"fromTable": "EMPLOYEE",
				"fromColumns": ["PROJECT"],
				"toTable": "PROJECT",
				"toColumns": ["ID"],
				"direction": "inverse"
			},
			...
		}
```

In this case the **same relationship** of the previous example will be built

```
EMPLOYEE -----------------------------> PROJECT
	   fromTable    =  EMPOYEE
	   toTable      =  PROJECT
	   fromColumns  =  [PROJECT]
	   TOColumns    =  [ID]
```

but the correspondent **Edge will have inverse direction**

```
Employee <----[???]----- Project
```

and for this reason we have changed the name of the Edge in "HasCommittedEmployee" so that the name of the class makes sense:

```
Employee <----[HasCommittedEmployee]----- Project
```

**Remember: direction refers to edges in the graph, not to relationships in your database.** Relationships must be always coherent with the structure of the tables.

As you can see it's possible to **define additional properties** for the final edge:

```
{
	"WorksAtProject": {
		"mapping": {
			"fromTable": "EMPLOYEE",
			"fromColumns": ["PROJECT"],
			"toTable": "PROJECT",
			"toColumns": ["ID"],
			"direction": "direct"
		},
		"properties": {
			"updatedOn": {
				"type": "DATE",
				"mandatory": true,
				"readOnly": false,
				"notNull": false
			}
		}
	}
}

```

In the example above we added a property named `updatedOn` of type OType.DATE to our Edge class.  
For each new defined property you can declare the following values:

- **type**: it's the OrientDB type. This value is mandatory, if not declared the property is not added to the Edge.
- **mandatory**: adds the mandatory constraint to the property and applies to it the specified value (true or false).
- **readOnly**: adds the readOnly constraint to the property and applies to it the specified value (true or false). 
- **notNull**: adds the notNull constraint to the property and applies to it the specified value (true or false). 

By omitting a constraint or setting it to false you will have the same result: the constraint is not considered for the specific property.


###Modifying existent Relationships

If the relationship you are mapping is already present in your database, it will be overridden with the parameters you defined in the configuration.  
In this way you can **change the name and the direction of the Edge class correspondent to a relationship already present** in the database schema.  
Let's suppose we have a foreign key between "Employee" and "Project":


```
		  EMPLOYEE                                                          PROJECT
	      (Foreign Table)                                                   (Parent Table)
 ________________________________________________                    _____________________________________
|       |              |             |           |        R         |       |         |                   |
|  ID   |  FIRST_NAME  |  LAST_NAME  |  PROJECT  |   ----------->   |  ID   |  TITLE  |  PROJECT_MANAGER  |
|_______|______________|_____________|___________|                  |_______|_________|___________________|
|       |              |             |           |                  |       |         |                   |
|       |              |             |           |                  |       |         |                   |
|_______|______________|_____________|___________|                  |_______|_________|___________________|


```

In this case through the automated mapping of Teleporter we will obtain the following graph model:

<graph-model with edge hasProject + graph>

```
Employee ----[HasProject]----> Project
```

In case we want reach a different result from the migration we can **change the attributes of the relationship** declaring them in the mapping.  
Teleporter will **recognize the relationship** you want override on the basis of the values:

- **fromTable**        
- **fromColumns**
- **toTable**
- **toColumns**

**These values must to be coherent with the direction of the relationship defined in the db schema, otherwise Teleporter will interpret the relationship as a new one**.  
So if for example we want override the Edge built starting from the relationship

```
EMPLOYEE -----------------------------> PROJECT
	   fromTable    =  EMPOYEE
	   toTable      =  PROJECT
	   fromColumns  =  [PROJECT]
	   TOColumns    =  [ID]
```

but we define the mapping as follows:

```
	"WorksAtProject": {
		"mapping": {
			"fromTable": "PROJECT",
			"fromColumns": ["ID"],
			"toTable": "EMPLOYEE",
			"toColumns": ["PROJECT"],
			"direction": "direct"
		},
		...
	}
```

as result we will obtain the adding of a second relationship with inverted direction between the two tables:

```
PROJECT -----------------------------> EMPLOYEE
	   fromTable    =  PROJECT
	   toTable      =  EMPLOYEE
	   fromColumns  =  [ID]
	   TOColumns    =  [PROJECT]
```

So in the graph model we will have two Edge classes (the second one is totally wrong):

```
Employee ----[HasProject]-------> Project
Employee <---[WorksAtProject]---- Project
```

So remember to **be coherent with the underlying schema** during the mapping definition:

Mapping:
```
	"WorksAtProject": {
		"mapping": {
			"fromTable": "EMPLOYEE",
			"fromColumns": ["PROJECT"],
			"toTable": "PROJECT",
			"toColumns": ["ID"],
			"direction": "direct"
		},
		...
	}
```

Relationship in the E-R model:
```
EMPLOYEE -----------------------------> PROJECT
	   fromTable    =  EMPOYEE
	   toTable      =  PROJECT
	   fromColumns  =  [PROJECT]
	   TOColumns    =  [ID]
```

Resulting Graph Model:
```
Employee ----[WorksAtProject]-------> Project
```

If you want **change the direction of the Edge** you can exploit the option `direction` as described in the previous paragraph:

```
	"HasCommittedEmployee": {
		"mapping": {
			"fromTable": "EMPLOYEE",
			"fromColumns": ["PROJECT"],
			"toTable": "PROJECT",
			"toColumns": ["ID"],
			"direction": "inverse"
		}
	}
```

Relationship in the E-R model:

```
EMPLOYEE -----------------------------> PROJECT
	   fromTable    =  EMPOYEE
	   toTable      =  PROJECT
	   fromColumns  =  [PROJECT]
	   TOColumns    =  [ID]
```

Resulting Graph Model:

```
Project ----[HasCommittedEmployee]-------> Employee
```

You can also **add properties** to the Edge class using the syntax already defined in the previous paragraph:

```
{
	"WorksAtProject": {
		"mapping": {
			"fromTable": "EMPLOYEE",
			"fromColumns": ["PROJECT"],
			"toTable": "PROJECT",
			"toColumns": ["ID"],
			"direction": "direct"
		},
		"properties": {
			"updatedOn": {
				"type": "DATE",
				"mandatory": true,
				"readOnly": false,
				"notNull": false
			}
		}
	}
}
```

In the example above we added a properties with name "updatedOn" of type OType.DATE to our Edge class and we set only the constraint mandatory.


###Configuring aggregation strategy

Teleporter offers two importing strategies as described in the [Execution strategies](Teleporter-Execution-Strategies.md) page:

- **naive** strategy: no aggregations are executed
- **naive-aggregate** strategy: aggregations can be executed

The aggregation is performed on join tables of dimension equals to 2 (other join tables are ignored), that is to say those tables which allow joins only between two tables.  
Each candidate join table is converted into an appropriate Edge class, and each field not involved in any relationship with other tables (hence not involved in any foreign key in the source database schema) is aggregated in the properties of the new built Edge.

If no foreign keys are defined for a specific join table the aggregation will not be performed and no edges will represent the N-N relationship.  
Through the configuration you can overcome this limit and kill two birds with one stone: in fact you can **declare the two relationships with the external tables and define the mapping with an Aggregator-Edge in one shot**.

Let's suppose we have a N-N relationship between two tables "Film" and "Actor" without foreign keys defined in the schema.

```
                 ACTOR                                    ACTOR_FILM                                FILM
                                                         (Join Table)
 ____________________________________        ____________________________________        ______________________________
|       |              |             |      |            |           |           |      |       |         |            |
|  ID   |  FIRST_NAME  |  LAST_NAME  |      |  ACTOR_ID  |  FILM_ID  |  PAYMENT  |      |  ID   |  TITLE  |  CATEGORY  |   
|_______|______________|_____________|      |____________|___________|___________|      |_______|_________|____________|
|       |              |             |      |            |           |           |      |       |         |            |
|       |              |             |      |            |           |           |      |       |         |            |
|_______|______________|_____________|      |____________|___________|___________|      |_______|_________|____________|


```

We want obtain an aggregated structure as follows:

```
Actor ----[Performs]-------> Film
```

In this case we have to use this syntax:

```
{
	"Performs": {
		"mapping": {
			"fromTable": "ACTOR",
			"fromColumns": ["ID"],
			"toTable": "FILM",
			"toColumns": ["ID"],
			"joinTable": {
				"tableName": "ACTOR_FILM",
				"fromColumns": ["ACTOR_ID"],
				"toColumns": ["FILM_ID"]
			},
			"direction": "direct"
		},
		"properties": {
		 ...
		}
	}
}
```

We can implicitly define the **direction** of the Edge by choosing:

- the **from-table**
- the **to-table**

In our example we decided to express the relationship between Actors and Films through a "Performs" Edge starting from Actor vertices and ending into Film vertices. 

Once again we can exploit the semantic of the `direction` key to reverse the final edge:

``` 
{
	"HasActor": {
		"mapping": {
			"fromTable": "ACTOR",
			"fromColumns": ["ID"],
			"toTable": "FILM",
			"toColumns": ["ID"],
			"joinTable": {
				"tableName": "ACTOR_FILM",
				"fromColumns": ["ACTOR_ID"],
				"toColumns": ["FILM_ID"]
			},
			"direction": "inverse"
		},
		"properties": {

		}
	}
}
```

In this way we can have the following schema:


```
Film ------[HasActor]------> Actor
```	

When you are taking advantage of this aggregating feature you have to define an **additional field** `join table` as shown in the example.

```
	"joinTable": {
		"tableName": "ACTOR_FILM",
		"fromColumns": ["ACTOR_ID"],
		"toColumns": ["FILM_ID"]
	}
```

In this field you have to specify:

- **tableName**: the name of the join table which will be aggregated into the declared Edge.
- **fromColumns**: the columns of the join table involved in the relationship with the "from-table".
- **toColumns**: the columns of the join table involved in the relationship with the "to-table".

**This info are essential** for Teleporter to infer all the single relationships between the records of the two external tables "ACTOR" and "FILM" and to build all the edges coherently, so if you don't declare any of these fields an **exception** will be thrown.

Remember that this syntax offers a shortcut to configure relationships and aggregation choices, thus **you can use it only when you are executing the aggregation strategy**.  
Performing your migration with a naive strategy using this syntax makes no sense, and here again an exception will be thrown.







