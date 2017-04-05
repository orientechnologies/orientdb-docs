
# Querying Metadata

OrientDB provides the `metadata:` target to retrieve information about OrientDB's metadata:
- `schema`, to get classes and properties
- `indexmanager`, to get information about indexes

## Querying the Schema

Get all the configured classes:
```
select expand(classes) from metadata:schema

----+-----------+---------+----------------+----------+--------+--------+----------+----------+------------+----------
#   |name       |shortName|defaultClusterId|strictMode|abstract|overSize|clusterIds|properties|customFields|superClass
----+-----------+---------+----------------+----------+--------+--------+----------+----------+------------+----------
0   |UserGroup  |null     |13              |false     |false   |0.0     |[1]       |[2]       |null        |V
1   |WallPost   |null     |15              |false     |false   |0.0     |[1]       |[4]       |null        |V
2   |Owner      |null     |12              |false     |false   |0.0     |[1]       |[1]       |null        |E
3   |OTriggered |null     |-1              |false     |true    |0.0     |[1]       |[0]       |null        |null
4   |E          |E        |10              |false     |false   |0.0     |[1]       |[0]       |null        |null
5   |OUser      |null     |5               |false     |false   |0.0     |[1]       |[4]       |null        |OIdentity
6   |OSchedule  |null     |7               |false     |false   |0.0     |[1]       |[7]       |null        |null
7   |ORestricted|null     |-1              |false     |true    |0.0     |[1]       |[4]       |null        |null
8   |AssignedTo |null     |11              |false     |false   |0.0     |[1]       |[1]       |null        |E
9   |V          |null     |9               |false     |false   |2.0     |[1]       |[0]       |null        |null
10  |OFunction  |null     |6               |false     |false   |0.0     |[1]       |[5]       |null        |null
11  |ORole      |null     |4               |false     |false   |0.0     |[1]       |[4]       |null        |OIdentity
12  |ORIDs      |null     |8               |false     |false   |0.0     |[1]       |[0]       |null        |null
13  |OIdentity  |null     |-1              |false     |true    |0.0     |[1]       |[0]       |null        |null
14  |User       |null     |14              |false     |false   |0.0     |[1]       |[2]       |null        |V
----+-----------+---------+----------------+----------+--------+--------+----------+----------+------------+----------
```

Get all the configured properties for the class OUser:

```

select expand(properties) from (
   select expand(classes) from metadata:schema
) where name = 'OUser'

----+--------+----+---------+--------+-------+----+----+------+------------+-----------
#   |name    |type|mandatory|readonly|notNull|min |max |regexp|customFields|linkedClass
----+--------+----+---------+--------+-------+----+----+------+------------+-----------
0   |status  |7   |true     |false   |true   |null|null|null  |null        |null
1   |roles   |15  |false    |false   |false  |null|null|null  |null        |ORole
2   |password|7   |true     |false   |true   |null|null|null  |null        |null
3   |name    |7   |true     |false   |true   |null|null|null  |null        |null
----+--------+----+---------+--------+-------+----+----+------+------------+-----------

```

Get only the configured `customFields` properties for OUser (assuming you added CUSTOM metadata like foo=bar):

```
select customFields from (
    select expand(classes) from metadata:schema 
) where name="OUser"


----+------+------------
#   |@CLASS|customFields
----+------+------------
0   |null  |{foo=bar}
----+------+------------

```

Or, if you wish to get only the configured `customFields`  of an attribute, like if you had a comment for the password attribute for the OUser class. 

```
select customFields from (
  select expand(properties) from (
     select expand(classes) from metadata:schema 
  ) where name="OUser"
) where name="password"


----+------+----------------------------------------------------
#   |@CLASS|customFields
----+------+----------------------------------------------------
0   |null  |{comment=Foo Bar your password to keep it secure!}
----+------+----------------------------------------------------

```

## Querying the available Indexes

Get all the configured indexes:

```
select expand(indexes) from metadata:indexmanager

----+------+------+--------+---------+---------+------------------------------------+------------------------------------------------------
#   |@RID  |mapRid|clusters|type     |name     |indexDefinition                     |indexDefinitionClass
----+------+------+--------+---------+---------+------------------------------------+------------------------------------------------------
0   |#-1:-1|#2:0  |[0]     |DICTIO...|dictio...|{keyTypes:[1]}                      |com.orientechnologies.orient.core.index.OSimpleKeyI...
1   |#-1:-1|#1:1  |[1]     |UNIQUE   |OUser....|{className:OUser,field:name,keyTy...|com.orientechnologies.orient.core.index.OPropertyIn...
2   |#-1:-1|#1:0  |[1]     |UNIQUE   |ORole....|{className:ORole,field:name,keyTy...|com.orientechnologies.orient.core.index.OPropertyIn...
----+------+------+--------+---------+---------+------------------------------------+-----------------------------------------
```
