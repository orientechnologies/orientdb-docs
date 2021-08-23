
# Console - `DISPLAYS RAW RECORD`

Displays details on the given record from the last returned result-set in a binary format.

**Syntax**

```sql
DISPLAY RAW RECORD <record-number>
```

- **`<record-number>`** Defines the relative position of the record in the last result-set.

**Example**

- Query the database on the class `V` to generate a result-set:

  <pre>
  orientdb {db=GratefulDeadConcerts}> <code class="lang-sql userinput">SELECT song_type, name, performances FROM V LIMIT 6</code>

  -----+-------+--------+----------+-------------------------+--------------
   #   | @RID  | @CLASS | song_type | name                   | performances
  -----+-------+--------+----------+-------------------------+--------------
   0   | #9:1  | V      | cover     | HEY BO DIDDLEY         | 5                 
   1   | #9:2  | V      | cover     | IM A MAN               | 1                 
   2   | #9:3  | V      | cover     | NOT FADE AWAY          | 531               
   3   | #9:4  | V      | original  | BERTHA                 | 394               
   4   | #9:5  | V      | cover     | GOING DOWN THE ROAD... | 293               
   5   | #9:6  | V      | cover     | MONA                   | 1                
   6   | #9:7  | V      | null      | Bo_Diddley             | null       
  -----+-------+--------+-----------+------------------------+-------------
  LIMIT EXCEEDED: resultset contains more items not displayed (limit=6)
  6 item(s) found. Query executed in 0.136 sec(s).
  </pre>

- Display raw record on the song "Hey Bo Diddley" from the result-set:

  <pre>
  orientdb {db=GratefulDeadConcerts}> <code class="lang-sql userinput">DISPLAY RAW RECORD 0</code>

  Raw record content. The size is 292 bytes, while settings force to print first 150 bytes:

  ^@^BV^Rsong_type^@^@^@^G^Hname^@^@^@^G^Htype^@^@^@ ^G^Xperformances^@^@^@ ^A^^out_followed_by^@^@^@ ^V^\out_written)by^@^@^@ ^V^Vout_sung_by^@^@^@ ^V^\in_followed_by^@^@^@ ^V^@civer^\HEY Bo D
  </pre>


>For more information on other commands available, see [Console Commands](Console-Commands.md).
