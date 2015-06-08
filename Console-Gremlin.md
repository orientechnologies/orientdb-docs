# Console Gremlin
OrientDB supports the [Gremlin](Gremlin.md) language from API and console. To execute a Gremlin script, create or open a database, then use the `gremlin` command passing the script. Note that `gremlin`, as `js` command, takes a multi-line input. Once types the gremlin script type `end` in a new line to complete the script and execute it.

Example:

```
OrientDB console v.2.1-SNAPSHOT www.orientechnologies.com
Type 'help' to display all the supported commands.
Installing extensions for GREMLIN language v.2.6.0

orientdb> create database plocal:/temp/gremlin

Connecting to database [plocal:/temp/gremlin] with user 'admin'...OK
orientdb {db=gremlin}> 

orientdb {db=gremlin}> gremlin g.V[0]
[Started multi-line command. Type just 'end' to finish and execute]
end

v[#9:0]

Script executed in 0,100000 sec(s).
```
