

<!-- proofread 2015-11-26 SAM -->
# Supported Data Types

OrientDB supports several data types natively. Below is the complete table.

|#id|Type|SQL type|Description|Java type|Minimum<br>Maximum|Auto-conversion from/to|
|---|----|--------|-----------|------|------------------|-----------------------|
|0|Boolean|BOOLEAN|Handles only the values *True* or *False*|<code>java.lang.Boolean</code> or <code>boolean</code>|0<br>1|String|
|1|Integer|INTEGER|32-bit signed Integers|<code>java.lang.Integer</code> or <code>int</code>|-2,147,483,648<br>+2,147,483,647|Any Number, String|
|2|Short|SHORT|Small 16-bit signed integers|<code>java.lang.Short</code> or <code>short</code>|-32,768<br>32,767|Any Number, String|
|3|Long|LONG|Big 64-bit signed integers|<code>java.lang.Long</code> or <code>long</code>|-2<sup>63</sup><br>+2<sup>63</sup>-1|Any Number, String|
|4|Float|FLOAT|Decimal numbers|<code>java.lang.Float</code> or <code>float</code>|2<sup>-149</sup><br>(2-2<sup>-23</sup>)*2<sup>127</sup>|Any Number, String|
|5|Double|DOUBLE|Decimal numbers with high precision|<code>java.lang.Double</code> or <code>double</code>|2<sup>-1074</sup><br>(2-2<sup>-52</sup>)*2<sup>1023</sup>|Any Number, String|
|6|Datetime|DATETIME|Any date with the precision up to milliseconds. To know more about it, look at [Managing Dates](Managing-Dates.md)|<code>java.util.Date</code>|-<br>1002020303|Date, Long, String|
|7|String|STRING|Any string as alphanumeric sequence of chars|<code>java.lang.String</code>|-<br>-|-|
|8|Binary|BINARY|Can contain any value as byte array|<code>byte[]</code>|0<br>2,147,483,647|String|
|9|Embedded|EMBEDDED|The Record is contained inside the owner. The contained Record has no [Record ID](../datamodeling/Concepts.md#record-id)|<code>ORecord</code>|-<br>-|ORecord|
|10|Embedded list|EMBEDDEDLIST|The Records are contained inside the owner. The contained records have no [Record ID's](../datamodeling/Concepts.md#record-id) and are reachable only by navigating the owner record|<code>List&lt;Object&gt;</code>|0<br>41,000,000 items|String|
|11|Embedded set|EMBEDDEDSET|The Records are contained inside the owner. The contained Records have no [Record ID](../datamodeling/Concepts.md#record-id) and are reachable only by navigating the owner record|<code>Set&lt;Object&gt;</code>|0<br>41,000,000 items|String|
|12|Embedded map|EMBEDDEDMAP|The Records are contained inside the owner as values of the entries, while the keys can only be Strings. The contained ords e no [Record ID](../datamodeling/Concepts.md#record-id)s and are reachable only by navigating the owner Record|<code>Map&lt;String, ORecord&gt;</code>|0<br>41,000,000 items|<code>Collection&lt;? extends ORecord&lt;?&gt;&gt;</code>, <code>String</code>|
|13|Link|LINK|Link to another Record. It's a common [one-to-one relationship](../datamodeling/Concepts.md#11-and-1n-referenced-relationships)|<code>ORID</code>, <code>&lt;? extends ORecord&gt;</code>|1:-1<br>32767:2^63-1|String|
|14|Link list|LINKLIST|Links to other Records. It's a common [one-to-many relationship](../datamodeling/Concepts.md#1n-and-nn-embedded-relationships) where only the [Record ID](../datamodeling/Concepts.md#record-id)s are stored|<code>List&lt;? extends ORecord</code>|0<br>41,000,000 items|String|
|15|Link set|LINKSET|Links to other Records. It's a common [one-to-many relationship](../datamodeling/Concepts.md#1n-and-nn-embedded-relationships)|<code>Set&lt;? extends ORecord&gt;</code>|0<br>41,000,000 items|<code>Collection&lt;? extends ORecord&gt;</code>, <code>String</code>|
|16|Link map|LINKMAP|Links to other Records as value of the entries, while keys can only be Strings. It's a common [One-to-Many Relationship](../datamodeling/Concepts.md#1n-and-nn-embedded-relationships). Only the [Record ID](../datamodeling/Concepts.md#record-id)s are stored|<code>Map&lt;String,<br>&nbsp;&nbsp;&nbsp;&nbsp;? extends Record&gt;</code>|0<br>41,000,000 items|String|
|17|Byte|BYTE|Single byte. Useful to store small 8-bit signed integers|<code>java.lang.Byte</code> or <code>byte</code>|-128<br>+127|Any Number, String|
|18|Transient|TRANSIENT|Any value not stored on database||||
|19|Date|DATE|Any date as year, month and day. To know more about it, look at [Managing Dates](Managing-Dates.md)|<code>java.util.Date</code>|-<bonetomanyr>-|Date, Long, String|
|20|Custom|CUSTOM|used to store a custom type providing the marshall and unmarshall methods|<code>OSerializableStream</code>|0<br>X|-|
|21|Decimal|DECIMAL|Decimal numbers without rounding|<code>java.math.BigDecimal</code>|?<br>?|Any Number, String|
|22|LinkBag|LINKBAG| List of [Record ID](../datamodeling/Concepts.md#record-id)s as spec [RidBag](../internals/RidBag.md) | <code>ORidBag</code> | ?<br>? | - |
|23|Any|ANY|Not determinated type, used to specify Collections of mixed type, and null | - | - | - |
