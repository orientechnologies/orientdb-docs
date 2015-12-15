<!-- proofread 2015-12-11 SAM -->
# Import a tree structure

If you have a tree structure in an RDBMS or CSV file and you want to import it in OrientDB, the ETL can come to your rescue. In this example, we use CSV for the sake of simplicity, but it's the same with JDBC input and a SQL query against an RDBMS.

## source.csv
```
ID,PARENT_ID,LAST_YEAR_INCOME,DATE_OF_BIRTH,STATE
0,-1,10000,1990-08-11,Arizona
1,0,12234,1976-11-07,Missouri
2,0,21322,1978-01-01,Minnesota
3,0,33333,1960-05-05,Iowa
```

## etl.json
```json
{
  "source": { "file": { "path": "source.csv" } },
  "extractor": { "row": {} },
  "transformers": [
    { "csv": {} },
    { "vertex": { "class": "User" } },
	{ "edge": {
		"class": "ParentOf",
		"joinFieldName": "PARENT_ID",
		"direction": "in",
		"lookup": "User.ID",
                "unresolvedLinkAction": "SKIP"
		}
	}
  ],
  "loader": {
    "orientdb": {
       "dbURL": "plocal:/temp/mydb",
       "dbType": "graph",
       "classes": [
         {"name": "User", "extends": "V"},
		 {"name": "ParentOf", "extends": "E"}
       ], "indexes": [
         {"class":"User", "fields":["ID:Long"], "type":"UNIQUE" }
       ]
    }
  }
}
```