---
search:
   keywords: ['Studio', 'etl', 'enterprise']
---

# ETL

In Studio 2.2 you can configure the execution of the ETL plugin, which provides support for moving data to and from OrientDB databases using ETL processes.  
If you are interested in a detailed description of the tool, of its inner workings, modules and features you can view the [ETL Documentation](ETL-Introduction.md). 

**NOTE**: This feature is available both for the [OrientDB Enterprise Edition](http://orientdb.com/orientdb-enterprise) and the [OrientDB Community Edition](http://orientdb.com/download/). 

In this documentation page we will see how exploit this visual tool in order to make the ETL configuring very easy. 

You can find the ETL module in the Server Management Area, in the connectors tab.  
By choosing the ETL you will be redirected to the tool's home, where you can: 

- **define a new import configuration** from scratch
- **load a configuration** starting from an **external JSON file**
- **search for existing configurations** in your databases in the OrientDB server 

![ETL Home](images/studio-etl/studio-etl-home.png)

The visual tool consists in a wizard composed of 3 configuration steps, let's have a look at each of them then. 

### Step 1

In the first step you have to specify all the parameters required in the configuration and source sections, then some additional settings about the process running. 

![1step-01](images/studio-etl/1-step/studio-etl-1step-01-sources.png)

#### Configuration

In this section you have to specify: 

- **configuration name**
- **target OrientDB database name**

Source data will be migrated in the specified database (it will be automatically created if not present yet) and the current configuration will be saved in there. In this way you can fetch it again in the Home page by clicking the "Exisiting DB Configurations" button in order to modify it and quickly perform a new import. 

#### Source

When OrientDB executes the ETL module, source components define the source of the data you want to extract. 
You can migrate data from different sources: 

- **JDBC**

This choice does not require additional parameters, in fact the JDBC Extractor works without source. Necessary info for the connection to the source relational database will be specified in the next step through the extractor configuration. 

![1step-02](images/studio-etl/1-step/studio-etl-1step-02-sources-jdbc.png)

- **file**

When you choose a file source, you just have to specify the path to that source. 

![1step-03](images/studio-etl/1-step/studio-etl-1step-03-sources-file.png)

- **HTTP**

By choosing a HTTP source, you have to type the source file URL and the HTTP method. Then you can also add a HTTP header, it's up to you as that is no mandatory. 

![1step-04](images/studio-etl/1-step/studio-etl-1step-04-sources-http.png)

![1step-05](images/studio-etl/1-step/studio-etl-1step-05-sources-http.png)

#### Advanced Settings

Here you can manage all settings and context variables used by any component of the process: 

- **Max Retries**: defines the maximum number of retries allowed, in the event that the loader raises an ONeedRetryException, for concurrent modification of the same record.
- **Log**: defines the global logging level. The accepted levels are: **NONE**, **ERROR**, **INFO**, and **DEBUG**.
- **Parallel**: defines whether the ETL module executes pipelines in parallel, using all available cores.
- **haltOnError**: defines whether the ETL module halts the process when it encounters unmanageable errors. When set to false, the process continues in the event of errors. It reports the number of errors it encounters at the end of the import.

![](images/studio-etl/1-step/studio-etl-1step-06-sources-advanced.png)

![](images/studio-etl/1-step/studio-etl-1step-07-sources-advanced.png)

### Step 2

Once configured all the necessary info in the first step, you can jump to the second one.  
Here you can configure the **extractor**, the **transformers** and the **loader** through the two panels shown in the image below: in the **left panel** you can choose which blocks to add to your process pipeline, in the **right panel** you can specify all the parameters for the current selected block in the left one. 

Moreover in the transformers area you can change the transformers order in the pipeline simply by dragging them in the desired position. 

![2-step-00](images/studio-etl/2-step/studio-etl-2step-00.png)

For more details about specific behavior of each configuration block you can refer to the ETL official documentation: 

- [Extractors](Extractor.md)
- [Transformers](Transformer.md)
- [Loaders](Loader.md)

#### Extractor

You can choose among two kinds of extractors: 

- **JDBC Extractor**: when you are migrating data from a relational database.  

![2-step-01](images/studio-etl/2-step/studio-etl-2step-01-extractor-jdbc.png)

The JDBC Extractor does not need a declared source in the first step, but you have to specify some important info in the extractor configuration, as the JDBC driver, the URL and the credentials for the connection to the source database. 

![2-step-02](images/studio-etl/2-step/studio-etl-2step-02-extractor-jdbc.png)

- **File Extractor**: you can choose different extractors according to your specific source file. 

![2-step-03](images/studio-etl/2-step/studio-etl-2step-03-extractor-file.png)

#### Transformers

Here you can add all the transformers you need in your process pipeline.  

![2-step-04](images/studio-etl/2-step/studio-etl-2step-04-transformers.png)

You just have to click on the desired transformer, e.g. a **LET** transformer, and it will appear in the designated area at the first position of your pipeline. 

![2-step-05](images/studio-etl/2-step/studio-etl-2step-05-transformers-added.png)

You can perform this operation more times and build your custom transformation pipeline. By **moving the blocks** you can also **change the applying order** of each transformer during the transformation process. 

![2-step-06](images/studio-etl/2-step/studio-etl-2step-06-transformers-multiple.png)

#### Loader

![2-step-07](images/studio-etl/2-step/studio-etl-2step-07-loader.png)

In the loader area you can add: 

- **Log Loader**: the ETL process will be performed but data will not be written in OrientDB. But information about the process will be printed out, so you can consider this option if you want simulate a migration to prevent errors during the real data importing.

- **OrientDB Loader**: data will be imported in the target database specified in the loader; this value is automatically initialized with the name typed in the first step. 

![2-step-08](images/studio-etl/2-step/studio-etl-2step-08-loader-added.png)

Classes and indexes are the most important parameters you have to configure in the OrientDB loader. 

- **Classes**: defines what classes you want to create, if they are not already defined in the database.

For each class the name is mandatory, then you can also specify the class to extend. 

<p align="center">
<img src="images/studio-etl/2-step/studio-etl-2step-09-loader-classes.png" width="456" height="468" />
</p>

Now you can click "Add to classes" button, in this way you are actually adding the new class definition to the target database schema. 

<p align="center">
<img src="images/studio-etl/2-step/studio-etl-2step-10-loader-classes.png" width="456" height="452" />
</p>

- **Indexes**: defines indexes to use during the ETL process. Before starting, any declared index, not present in the database, will be created. For each index you have to specify the type, the class and the involved fields. 

<p align="center">
<img src="images/studio-etl/2-step/studio-etl-2step-11-loader-indexes.png" width="456" height="614" />
</p>

Then click "Add to indexes" button to make your index definition effective. 

<p align="center">
<img src="images/studio-etl/2-step/studio-etl-2step-12-loader-indexes2.png" width="457" height="620" />
</p>

#### Configuration saving

You can save the current status of your configuration whenever you want by clicking the "Save Config" button. Configuration will be saved in the specified target database and you can retrieve it in the tool Home page by clicking the "Existing DB Configurations" button. 

![2-step-13](images/studio-etl/2-step/studio-etl-2step-13-saveconfig.png)

By the way, when you run the ETL process, the configuration will be **automatically saved in the target database**. 

### Step 3

Once you configured all the blocks in the second step, you can **start the migration** by clicking "Run ETL" button.  
The ETL process logging step will be visualized: here you can monitor the migration status and inspect some information about the importing process. 

When the process is completed you can start a new migration by clicking the "New Migration" button. 

![3-step-01](images/studio-etl/3-step/studio-etl-3step-01-log.png)

### Importing OpenBeer

In this section we will see how to import the OpenBeer database: we are going to exploit the simple ETL GUI in order to specify the same configurations provided in this [migration tutorial](Import-the-Database-of-Beers.md). 

Here are the source **ER Model** and the **target Graph Model**. 

![](images/etl/openbeerdb/Beer_Data_Model-Relational.png)

![](images/etl/openbeerdb/Beer_Data_Model-Graph.png)

#### Preliminary Steps: Download the Open Beer Database in CSV format

Download the Open Beer Database in CSV format and extract the archive: 

```
$ curl http://openbeerdb.com/files/openbeerdb_csv.zip > openbeerdb_csv.zip
$ unzip openbeerdb_csv.zip
```

The archive consists of the following files: 

- `beers.csv:` contains the beer records
- `breweries.csv:` contains the breweries records
- `breweries_geocode.csv`: contains the geocodes of the breweries. This file is not used in this Tutorial
- `categories.csv`: contains the beer categories
- `styles.csv`: contains the beer styles


#### Import Beer Categories

Here is the JSON file we should write down if we migrate the ``categories.csv`` file through the ETL script. 

```json
{
  "source": { "file": { "path": "/Users/openbeer/categories.csv" } },
  "extractor": { "csv": {} },
  "transformers": [
    { "vertex": { "class": "Category" } }
  ],
  "loader": {
    "orientdb": {
       "dbURL": "plocal:../databases/OpenBeer",
       "dbType": "graph",
       "classes": [
         {"name": "Category", "extends": "V"}
       ], "indexes": [
         {"class":"Category", "fields":["id:integer"], "type":"UNIQUE" }
       ]
    }
  }
}
```

Let's see how to adopt the same configuration starting from the logic present in the JSON file but enjoying the ETL visual tool. 

We have to set parameters at the first step as follows: 

![](images/studio-etl/openbeer/categories/1step-01.png)

Then we can go to the second step. To migrate data from our CSV file we need a CSV Extractor of course, so let's choose it and configure the required parameters.  
You can specify different settings as the column separator character, date format and so on, but the most important are the columns we want to extract and import in OrientDB as properties.  
If you need more details about the parameters and their usage, please refer to the [Extractors doc page](Extractor.md). 

In the source file we have got just 3 columns: ``id``, ``cat_name`` and ``last_mod``.  
Let's include them all in our migration by adding them one by one in the specific area.  

![](images/studio-etl/openbeer/categories/2step-01-extractor.png)

Then, referring to the JSON configuration, we just have to set a Vertex transformer. 

![](images/studio-etl/openbeer/categories/2step-02-transformer.png)

Finally we choose the OrientDB loader: here you can see that the target database name is already set according to the value specified in the first step. 

![](images/studio-etl/openbeer/categories/2step-03-loader.png)

Then we have to define classes and indexes according to the JSON configuration: 

<p align="center">
<img src="images/studio-etl/openbeer/categories/2step-04-loader-classes.png" width="418" height="406" />
<img src="images/studio-etl/openbeer/categories/2step-05-loader-indexes.png" width="418" height="578" />
</p>

Now we can run the job, as result we should obtain something like the following picture. 

![](images/studio-etl/openbeer/categories/3step-01-log.png)

#### Import Beer Styles

Here is the reference JSON configuration. 

```json
{
  "source": { "file": { "path": "/Users/openbeer/styles.csv" } },
  "extractor": { "csv": {} },
  "transformers": [
    { "vertex": { "class": "Style" } },
    { "edge": { "class": "HasCategory",  "joinFieldName": "cat_id", "lookup": "Category.id" } }
  ],
  "loader": {
    "orientdb": {
       "dbURL": "plocal:../databases/OpenBeer",
       "dbType": "graph",
       "classes": [
         {"name": "Style", "extends": "V"},
         {"name": "HasCategory", "extends": "E"}
       ], "indexes": [
         {"class":"Style", "fields":["id:integer"], "type":"UNIQUE" }
       ]
    }
  }
}
```

Let's configure the first step as follows. 

![](images/studio-etl/openbeer/styles/1step-01.png)

At the second step, we specify in the CSV extractor all the columns we want to extract. 

![](images/studio-etl/openbeer/styles/2step-01-extractor.png)

Then we define a Vertex transformer to import the Style vertices 

![](images/studio-etl/openbeer/styles/2step-02-transformer.png)

and an Edge extractor in order to add edges between each Style and Category vertices. Please fill all the parameters as shown in the picture below.

![](images/studio-etl/openbeer/styles/2step-03-transformer.png)

In the OrientDB loader we coherently specify a Style class, extending the V class, and a HasCategory class, extending the E class. 

<p align="center">
<img src="images/studio-etl/openbeer/styles/2step-04-loader-classes.png" width="456" height="445" />
</p>

Following the same approach reported in the JSON configuration, we can create an index on the ``id`` property of the Category class in order to speed up lookups during the migration. 

<p align="center">
<img src="images/studio-etl/openbeer/styles/2step-05-loader-indexes.png" width="460" height="635" />
</p>

In the end we can click the "Run ETL" button to start the migration process. 

![](images/studio-etl/openbeer/styles/3step-01-log.png)

#### Import Breweries

The reference JSON configuration is reported below. 

```json
{
  "source": { "file": { "path": "/Users/openbeer/breweries.csv" } },
  "extractor": { "csv": {} },
  "transformers": [
    { "vertex": { "class": "Brewery" } }
  ],
  "loader": {
    "orientdb": {
       "dbURL": "plocal:../databases/OpenBeer",
       "dbType": "graph",
       "classes": [
         {"name": "Brewery", "extends": "V"}
       ], "indexes": [
         {"class":"Brewery", "fields":["id:integer"], "type":"UNIQUE" }
       ]
    }
  }
}
```

To import the Breweries, first of all we have to configure the first step as already shown in the previous examples. 

![](images/studio-etl/openbeer/breweries/1step-01.png)

At the second step in the CSV Extractor, we have to specify, as usual, the columns we want to extract. 

![](images/studio-etl/openbeer/breweries/2step-01-extractor.png)

Looking at the JSON configuration, you can see we have to configure just a Vertex transformer as follows. 

![](images/studio-etl/openbeer/breweries/2step-02-transformer.png)

In the loader we just define a Brewery class 

<p align="center">
<img src="images/studio-etl/openbeer/breweries/2step-03-loader-classes.png" width="455" height="442"/>
</p>

and a UNIQUE index on the ``id`` field. 

<p align="center">
<img src="images/studio-etl/openbeer/breweries/2step-04-loader-indexes.png" width="456" height="628"/>
</p>

Let's run the ETL job, we should obtain a log like that: 

![](images/studio-etl/openbeer/breweries/3step-01-log.png)

#### Import Beers

Let's have a look at the JSON configuration. 

```json
{
  "config" : { "haltOnError": false },
  "source": { "file": { "path": "/Users/openbeer/beers.csv" } },
  "extractor": { "csv": { "columns": ["id","brewery_id","name","cat_id","style_id","abv","ibu","srm","upc","filepath","descript","last_mod"],
                                "columnsOnFirstLine": true } },
  "transformers": [
    { "vertex": { "class": "Beer" } },
    { "edge": { "class": "HasCategory",  "joinFieldName": "cat_id", "lookup": "Category.id" } },
    { "edge": { "class": "HasBrewery",  "joinFieldName": "brewery_id", "lookup": "Brewery.id" } },
    { "edge": { "class": "HasStyle",  "joinFieldName": "style_id", "lookup": "Style.id" } }
  ],
  "loader": {
    "orientdb": {
       "dbURL": "plocal:../databases/OpenBeer",
       "dbType": "graph",
       "classes": [
         {"name": "Beer", "extends": "V"},
         {"name": "HasCategory", "extends": "E"},
         {"name": "HasStyle", "extends": "E"},
         {"name": "HasBrewery", "extends": "E"}
       ], "indexes": [
         {"class":"Beer", "fields":["id:integer"], "type":"UNIQUE" }
       ]
    }
  }
}
```

Here is the first step configuration we need in order to import the Beers. 

![](images/studio-etl/openbeer/beers/1step-01.png)

Let's jump to the second step and add a CSV extractor. Don't forget to list all the columns you want to migrate. 

![](images/studio-etl/openbeer/beers/2step-01-extractor.png)

About the transformers, we have to configure a Vertex transformer and three Edge transformers as follows. 

![](images/studio-etl/openbeer/beers/2step-02-transformer.png)

![](images/studio-etl/openbeer/beers/2step-03-transformer.png)

![](images/studio-etl/openbeer/beers/2step-04-transformer.png)

![](images/studio-etl/openbeer/beers/2step-05-transformer.png)

In the OrientDB loader we define the correspondent Vertex and Edge classes 

<p align="center">
<img src="images/studio-etl/openbeer/beers/2step-06-loader-classes.png" width="456" height="466"/>
</p>

and an index on the ``id`` field in the Beer class. 

<p align="center">
<img src="images/studio-etl/openbeer/beers/2step-07-loader-indexes.png" width="458" height="636"/>
</p>

Finally we can start the last migration and check the result. 

![](images/studio-etl/openbeer/beers/3step-01-log.png)

That's all, we have migrated the OpenBeer database and all the configurations we have defined to import each single csv source have been saved in the OpenBeer target database.  
You can find and use them again by clicking the "Existing DB Configurations" button in the Home page. 

![](images/studio-etl/openbeer/existing-databases.png)

