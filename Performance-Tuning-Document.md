# Tuning the Document API

This guide is specific for the Document Database. Please be sure to read the generic guide to the [Performance-Tuning](Performance-Tuning.md).

## Massive Insertion

See [Generic improvement on massive insertion](Performance-Tuning.md#massive_insertion).

### Avoid document creation

You can avoid the creation of a new ODocument for each insertion by using the ODocument.reset() method that clears the instance making it ready for a new insert operation. Bear in mind that you will need to assign the document with the proper class after resetting as it is done in the code below.

*NOTE: This trick works ONLY IN NON-TRANSACTIONAL contexts, because during transactions the documents could be kept in memory until commit.*

Example:
```java
import com.orientechnologies.orient.core.intent.OIntentMassiveInsert;

db.declareIntent( new OIntentMassiveInsert() );

ODocument doc = new ODocument();
for( int i = 0; i < 1000000; ++i ){
  doc.reset();
  doc.setClassName("Customer");
  doc.field("id", i);
  doc.field("name", "Jason");
  doc.save();
}

db.declareIntent( null );
```
