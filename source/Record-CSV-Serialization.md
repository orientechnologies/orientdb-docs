# CSV Serialization

The CSV serialzation is the format how record are serialized in the orientdb 0.*  and 1.* version.

Documents are serialized in a proprietary format (as a string) derived from JSON, but more compact. The string retrieved from the storage could be filled with spaces. This is due to the oversize feature if it is set. Just ignore the tailing spaces.

To know more about types look at [Supported types](Types.md).

These are the rules:
- Any string content must escape some characters:
- <code>" -&gt; \"</code>
- <code>\ -&gt; \\</code>
- The **class**, if present, is at the begin and must end with <code>@</code>. E.g. <code>Customer@</code>
- Each **Field** must be present with its name and value separated by <code>:</code>. E.g.<code>name:"Barack"</code>
- **Fields** must be separated by <code>,</code>. E.g. <code>name:"Barack",surname:"Obama"</code>
- All **Strings** must be enclosed by <code>"</code> character. E.g. <code>city:"Rome"</code>
- All **Binary** content (like byte[must be encoded in Base64 and enclosed by underscore <code>_</code> character. E.g. <code>buffer:_AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGx_</code>. Since v1.0rc7
- *Numbers* (integer, long, short, byte, floats, double) are formatted as strings as ouput by the Java toString() method. No thousands separator must be used. The decimal separator is always <code>.</code> Starting from version 0.9.25, if the type is not integer, a suffix is used to distinguish the right type when unmarshalled: b=byte, s=short, l=long, f=float, d=double, c=BigDecimal (since 1.0rc8). E.g. <code>salary:120.3f</code> or <code>code:124b</code>.
- Output of [Floats](http://docs.oracle.com/javase/6/docs/api/java/lang/Float.html#toString%28float%29)
- Output of [Doubles](http://docs.oracle.com/javase/6/docs/api/java/lang/Double.html#toString%28double%29)
- Output of [BigDecimal](http://docs.oracle.com/javase/6/docs/api/java/math/BigDecimal.html#toPlainString%28%29)
- **Booleans** are expressed as <code>true</code> and <code>false</code> always in lower-case. They are recognized as boolean since the text has no double quote as is the case with strings
- **Dates** must be in the POSIX format (also called UNIX format: http://en.wikipedia.org/wiki/Unix_time). Are always stored as longs but end with:
- the 't' character when it's DATETIME type (default in schema-less mode when a Date object is used). Datetime handles the maximum precision up to milliseconds. E.g. <code>lastUpdate:1296279468000t</code> is read as 2011-01-29 05:37:48
- the 'a' character when it's DATE type. Date handles up to day as precision. E.g. <code>lastUpdate:1306281600000a</code> is read as 2011-05-25 00:00:00 (Available since 1.0rc2)
- **[RecordID](Concepts.md#wiki-RecordID)** (link) must be prefixed by <code>#</code>. A Record Id always has the format <code>&lt;cluster-id&gt;:&lt;cluster-position&gt;</code>. E.g. <code>location:#3:2</code>
- **Embedded** documents are enclosed by parenthesis <code>(</code> and <code>)</code> characters. E.g. <code>(name:"rules")</code>. *Note: before SVN revision 2007 (0.9.24-snapshot) only <code>*</code> characters were used to begin and end the embedded document.*
- **Lists** (array and list) must be enclosed by `[` and `]` characters. E.g. `[1,2,3]`, `[#10:3,#10:4]` and `[(name:"Luca")]`. Before rel.15 SET type was stored as a list, but now it uses own format (see below)
- **Sets** (collections without duplicates) must be enclosed by `<` and `>` characters. E.g. `<1,2,3>`, `<#10:3,#10:4>` and `<(name:"Luca")>`. There is a special case when use LINKSET type reported in detail in [Special use of LINKSET types](#Special_use_of_LINKSET_types) section. Before rel.15 SET type was stored as a list (see upon).
- **Maps** (as a collection of entries with key/value) must be enclosed in `{` and `}` characters. E.g. `rules:{"database":2,"database.cluster.internal":2</code>}` (NB. to set a value part of a key/value pair, set it to the text "null", without quotation marks. Eg. `rules:{"database_name":"fred","database_alias":null}`)
- **RidBags** a special collection for link management. Represented as `%(content:binary);` where the content is binary data encoded in base64. Take a look at [the main page](RidBag.md) for more details.
- **Null** fields have an empty value part of the field. E.g. `salary_cloned:,salary:`

```
[<class>@][,][<field-name>:<field-value>]*
```

Simple example (line breaks introduced so it's visible on this page):
```
Profile@nick:"ThePresident",follows:[],followers:[#10:5,#10:6],name:"Barack",surname:"Obama",
location:#3:2,invitedBy:,salary_cloned:,salary:120.3f
```

Complex example used in schema (line breaks introduced so it's visible on this page):
```
name:"ORole",id:0,defaultClusterId:3,clusterIds:[3],properties:[(name:"mode",type:17,offset:0,
mandatory:false,notNull:false,min:,max:,linkedClass:,
linkedType:,index:),(name:"rules",type:12,offset:1,mandatory:false,notNull:false,min:,
max:,linkedClass:,linkedType:17,index:)]
```

Other example of ORole that uses a map (line breaks introduced so it's visible on this page):
```
ORole@name:"reader",inheritedRole:,mode:0,rules:{"database":2,"database.cluster.internal":2,"database.cluster.orole":2,"database.cluster.ouser":2,
"database.class.*":2,"database.cluster.*":2,"database.query":2,"database.command":2,
"database.hook.record":2}
```


# Serialization

Below the serialization of types in JSON and Binary format (always refers to latest version of the protocol).

|Type|JSON format|Binary descriptor |
|----|-----------|------------------|
|String|0|Value ends with 'b'. Example: 23b|
|Short|10000|Value ends with 's'. Example: 23s|
|Integer|1000000|Just the value. Example: 234392|
|Long|1000000000|Value ends with 'l'. Example: 23439223l|
|Float|100000.33333|Value ends with 'f'. Example: 234392.23f|
|Double|100.33|Value ends with 'd'. Example: 10020.2302d|
|Decimal|1000.3333|Value ends with 'c'. Example: 234.923c|
|Boolean|true|'true' or 'false'. Example: true|
|Date|1436983328000|Value in milliseconds ends with 'a'. Example: 1436983328000a|
|Datetime|1436983328000|Value in milliseconds ends with 't'. Example: 1436983328000t|
|Binary|base64 encoded binary, like: "A3ERjRFdc0023Kc"|Bytes surrounded with `_` characters. Example: `_`2332322`_`|
|Link|#10:3|Just the RID. Example: #10:232|
|Link list|<code>[#10:3, #10:4]</code>|Collections values separated by commas and surrounded by brackets "[ ]". Example: [#10:3, #10:6]|
|Link set|Example: <code>[#10:3, #10:6]</code>|Example: <code><#10:3, #10:4></code>|
|Link map|Example: <code>{ "name" : "#10:3" }</code>|Map entries separated by commas and surrounded by curly braces "{ }". Example: <code>{"Jay":#10:3,"Mike":#10:6}</code>|
|Embedded|<code>{"Jay":"#10:3","Mike":"#10:6"}</code>|Embedded document serialized surrounded by parenthesis "( )". Example: <code>({"Jay":#10:3,"Mike":#10:6})</code>|
|Embedded list|Example: <code>[20, 30]</code>|Collections of values separated by commas and surrounded by brackets "[ ]". Example: <code>[20, 30]</code>|
|Embedded set|<code>['is', 'a', 'test']</code>|Collections of values separated by commas and surrounded by minor and major "<>". Example: <code><20, 30></code>|
|Embedded map|<code>{ "name" : "Luca" }</code>|Map of values separated by commas and surrounded by curly braces "{ }". Example: <code>{"key1":23,"key2":2332}</code>|
|Custom|base64 encoded binary, like: "A3ERjRFdc0023Kc"|-|
