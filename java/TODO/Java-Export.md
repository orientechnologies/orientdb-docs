## Export API

In addition to the Console, you can also trigger exports through Java and any other language that runs on the JVM, by using the [ODatabaseExport](https://github.com/orientechnologies/orientdb/blob/master/core/src/main/java/com/orientechnologies/orient/core/db/tool/ODatabaseExport.java) class. 

For example: 

```java
ODatabaseDocumentTx db = new ODatabaseDocumentTx("plocal:/temp/mydb");
db.open("admin", "admin");
try{
  OCommandOutputListener listener = new OCommandOutputListener() {
    @Override
    public void onMessage(String iText) {
      System.out.print(iText);
    }
  };

  ODatabaseExport export = new ODatabaseExport(db, "/temp/export", listener);
  export.exportDatabase();
  export.close();
} finally {
  db.close();
}
```