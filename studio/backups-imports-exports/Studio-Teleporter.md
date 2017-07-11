---
search:
   keywords: ['Studio', 'teleporter', 'enterprise']
---

# Teleporter

In Studio 2.2 you can configure the execution of the new Teleporter plugin, which allows you to import your relational database into OrientDB in few simple steps.
If you are interested in a detailed description of the tool, of its inner workings and features you can view the [Teleporter Documentation](Teleporter-Home.md).

**NOTE**: This feature is available both for the [OrientDB Enterprise Edition](http://orientdb.com/orientdb-enterprise) and the [OrientDB Community Edition](http://orientdb.com/download/). **But beware**: in **community edition** you can migrate your source relational database but **you cannot enjoy the synchronize feature**, available only in the enterprise edition.


This visual tool consists in a wizard composed of 4 steps, where just **Step 1** and **Step 2** are strictly necessary.
Let's have a look at each configuration step.

### Step 1

In the first step you have to type the following required parameters:
- `Database Driver`, as the driver name of the DBMS from which you want to execute the import. You have to choose among:
  - Oracle
  - SQLServer
  - Mysql
  - PostgreSQL
  - HyperSQL
- `Database Host`, as the host where you DBMS instance is running on
- `Port`, as the port where your DBMS is listening on
- `Database Name`, as the name of the source database
- `User Name`, as the username to access the source database (it may be blank)
- `Password`, as the password to access the source database (it may be blank)
- `OrientDB URL`, as the URL for the destination OrientDB graph database

After you typed all the required parameters for the migration you can test the connection.

![Test Connection](images/studio-teleporter/studio-teleporter-step1-tryConnection.png)

### Step 2

In the second step you have to specify all the parameters about the OrientDB target database:
- `Connection protocol`, as the protocol adopted to write in OrientDB. You have to choose among:
  - plocal
  - memory
- `OrientDB Database Name`, as the name of the target database in OrientDB
- `Strategy`, as the strategy adopted during the migration ([More](https://orientdb.com/docs/last/Teleporter-Home.html) about strategies)
- `Name Resolver`, as the basic name resolver to adopt during names' resolution
- `Inheritance descriptor`, as the XML file containing all the info describing inheritance relationships present in the source database
- `Log Level`, as the log level adopted by Teleporter during the migration. You can choose among: 
  - NO
  - DEBUG
  - INFO
  - WARNING
  - ERROR
  
![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step2.png)

Now we have collected all the minimal info needed for the migration, so you can run your configured job through the `START MIGRATION` button, then the job progress monitor will be displayed:

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-job-running.png)

At the end of the migration, statistics and warnings about the process are reported as shown below:

![Teleporter Job Completed](images/studio-teleporter/studio-teleporter-job-completed.png)

Otherwise you can go on in your migrationg customisation jumping to the next step.

### Step 3

Here you can exploit Teleporter's filtering features: in the panel on the left all the tables present in the source database are reported. If you want migrate just a subset of these tables you just have to select and move them in the right panel through the specific buttons (you can also drag-and-drop the selected items).

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step3-filtering-1.png)

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step3-filtering-2.png)

You can perform the same operations also in the opposite direction, so reinclude some tables in the migratin just moving them from the right panel to the left one.

If the right panel is empty, no filters will be applied. Instead, if the right panel is not empty, just the selected tables in the left panel will be imported while all the others will be filtered out. 
Thus, for example, these two configurations are equivalent:

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step3-filtering-3.png)

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step3-filtering-4.png)

Here too you can start your migration or go to the 4th and last configuration step.


### Step 4

In the last step Teleporter will provide you a Graph Model coming from the translation of the ER-Model inferred from the source database schema. The correspondent Graph Model is built according to basic mapping rules and your choices as well (filters applied, chosen strategy, name resolver adopted etc.). 
This step has two aims:
- it gives you an idea of how your source database will appear once imported in OrientDB
- it allows you edit the graph model

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-only-graph.png)

You can see two panels, the Graph Panel on the left, containing the Graph Model built from Teleporter, and the Detail Panel on the right, reporting all the details about the current selected element in the left panel.

The details panel is divided into two sections:
1. in the top area you can enjoy a graph perspective of the element selected in the graph panel: you can inspect info about the OrientDB schema, like class name and properties.
2. in the bottom area you have a source-schema perspective, where we have got the source-schema items from which the information above comes from. 

This step is conceived to make very easy the graph model editing and to change the mapping with the source database schema. In fact you can modify the basic mapping 

  - Renaming classes (both for Vertex and Edge classes)
  - Excluding/re-including a property mapped with a column in the correspondent source table
  - Adding new properties
  - Dropping existent properties
  - Editing properties
  - Adding new Edge classes and/or instances 
  - Inspecting original schema data, both for tables and relationships
  
Let's have a deeper look at each of these operations.

#### Inspecting Classes and source correspondent elements

Thanks to the details panel you can inspect information about:

1. Vertex class

If you select a Vertex Class, you can inspect the correspondence between each column in the source table and the correspondent property in the translated Vertex class. Columns and proprties are strongly bound: you can exclude, include or rename a property, but the bindings with the correspondent column will remain.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-graph+selected-vertex.png)

2. Edge Class

When you select an edge in the graph, you can find out about the original relationhip  it comes from in the bottom section in the details panel. We can have 2 kinds of relationships, and coherently 2 kinds of edge rendering.


  - 1-N Relationship

    Edges coming from 1-N Relationhips are represented through a continous arrow.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-simple-edge-rendering.png)

   The rendered Relationship involves just two tables of course, the starting table (aka **foreign table**) and the arrival table (aka **parent table**). Clicking the question mark you can also see for each table all the columns involved in the relationhip.

<p align="center">
<img src="images/studio-teleporter/studio-teleporter-step4-simple-edge-rel-view.png" width="580" height="628" />
</p>

  - N-N Relationship

    Let's suppose we have got the following graph, obtained performing join tables aggregation through the naive-aggregate strategy.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-aggregated-graph+legend.png)

   Edges coming from N-N Relationhips are represented through a dashed arrow and in the bottom you can see the 2 relationhips involving two external tables and the join table between them.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-aggr-edge-rendering.png)

   Here too, clicking the question mark you can inspect the involved columns for both the relationhips.
   
<p align="center">
<img src="images/studio-teleporter/studio-teleporter-step4-aggr-edge-rel-view-1.png" width="430" height="465" /> <img src="images/studio-teleporter/studio-teleporter-step4-aggr-edge-rel-view-2.png" width="430" height="465" />
</p>

#### Search Bar

In the graph model panel a useful search bar is provided to allow you fast vertex selection according to the vertex class name or the source table name.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-search-bar.png)

In the example above you can see that for each class we have two items, the vertex class name and the source table name. In this case each couple of items are equal because no classes were renamed nor a name resolver was adoted during the basic graph model building.

#### Class Renaming

You can rename a class just selecting an element in the graph (vertex or edge) and clicking the "Rename Class" button under the "Edit Class" dropdown menu.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-rename-class-button.png)

Then you just have to choose the new name for the specific class.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-rename-class-modal.png)

The class name will be updated in the graph, in the search bar and in the detail panel of course.

#### Property Excluding

We have two ways to exclude a property mapped with a column in the source table:

1. Unflagging the correspondent column name in the source table perspective.

2. Dropping the property from the class perspective.

<p align="center">
<img src="images/studio-teleporter/studio-teleporter-step4-excluded-props.png" width="580" height="628" />
</p>

#### Property Dropping

You can also drop a property through the specific button.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-drop-prop-modal.png)

You can have 2 depending on wether the property is bound with a column in the source table or not. 

- If the property is bound with a source column, when you drop it you will get the same result as when you exclude it, so it will not be migrated in OrientDB but you can always include it again, as the binding is not deleted at all.
 
- If the property is not bound with a source column, then when you drop it thep property will be definitively deleted.

#### Property Adding

You can add new properties just clicking the "Add property" button under the "Edit Class" dropdown menu.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-add-prop-button.png)

In the just opened window you can choose if add a new property never defined before, selecting the "Add new property" radio button, 

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-add-prop-modal1.png)

or re-include some excluded properties if any, selecting the "Include Property" radio button.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-add-prop-modal2.png)

#### Property Editing

You can also edit an existing property: you can choose a different name, type, or just add/remove some constraints.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-edit-prop-modal.png)

#### Property Including

We have two ways to include a property mapped with a column in the source table:

1. Flagging the correspondent column name in the source table perspective.

2. Including the property from the OrientDB class perspective through the "Add property" button shown above.

<p align="center">
<img src="images/studio-teleporter/studio-teleporter-step4-reincluded-props.png" width="580" height="628" />
</p>

#### Edge Adding

Often you need to add an edge in your graph model, because missing for some reason.
For example, if you didn't defined some foreign keys between the tables on which you usually perform join operations, you will lose this kind of info during the importing process and you will not have any edges in your final Graph Database.
Sometimes you just want to enrich the model adding new edges. 
In both the cases you have to select a vertex in the graph and then click the "Add Edge" button under the "Action" dropdown menu. 

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-add-edge-button.png)

Then you have to drag the edge till the target vertex and click over it.

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-add-edge-drag.png)

A new window will open where you have to specifiy the name of the Edge class for the new edge instance and some mapping info:

- fromTable: the foreign entity that imports the primary key of the parent table.
- fromColumns: the attributes involved in the foreign key.
- toTable: the parent entity whose primary key is imported by the foreign table.
- toColumns: the attributes involved in the primary key imported.

As said above, when we want to create a new edge instance, we can create a new Edge class

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-add-edge-modal1.png)

or just choose an already present Edge class 

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-add-edge-modal2.png)

#### Edge Dropping

When you select an edge in the graph model, you have 2 choices:

1. Delete the Edge class with all its instances

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-drop-edge-class.png)

2. Delete only the selected instance of the specific Edge Class

![Teleporter Job Running](images/studio-teleporter/studio-teleporter-step4-drop-edge-instance.png)













