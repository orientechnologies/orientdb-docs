# Entry Points Since OrientDB v 1.7

The entry points for creating a new Index Engine are two:

* OIndexFactory
* OIndexEngine

## Implementing OIndexFactory

Create your own facory that implements OIndexFactory.

In your factory you have to declare:

1. Which types of index you support
1. Which types of algorithms you support

and you have to implements the createIndex method

Example of custom factory for Lucene Indexing

```
package com.orientechnologies.lucene;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.orientechnologies.lucene.index.OLuceneFullTextIndex;
import com.orientechnologies.lucene.index.OLuceneSpatialIndex;
import com.orientechnologies.lucene.manager.*;
import com.orientechnologies.lucene.shape.OShapeFactoryImpl;
import com.orientechnologies.orient.core.db.record.ODatabaseRecord;
import com.orientechnologies.orient.core.db.record.OIdentifiable;
import com.orientechnologies.orient.core.exception.OConfigurationException;
import com.orientechnologies.orient.core.index.OIndexFactory;
import com.orientechnologies.orient.core.index.OIndexInternal;
import com.orientechnologies.orient.core.metadata.schema.OClass;
import com.orientechnologies.orient.core.record.impl.ODocument;

/**
 * Created by enricorisa on 21/03/14.
 */
public class OLuceneIndexFactory implements OIndexFactory {

  private static final Set<String> TYPES;
  private static final Set<String> ALGORITHMS;
  public static final String       LUCENE_ALGORITHM = "LUCENE";

  static {
    final Set<String> types = new HashSet<String>();
    types.add(OClass.INDEX_TYPE.UNIQUE.toString());
    types.add(OClass.INDEX_TYPE.NOTUNIQUE.toString());
    types.add(OClass.INDEX_TYPE.FULLTEXT.toString());
    types.add(OClass.INDEX_TYPE.DICTIONARY.toString());
    types.add(OClass.INDEX_TYPE.SPATIAL.toString());
    TYPES = Collections.unmodifiableSet(types);
  }

  static {
    final Set<String> algorithms = new HashSet<String>();
    algorithms.add(LUCENE_ALGORITHM);
    ALGORITHMS = Collections.unmodifiableSet(algorithms);
  }

  public OLuceneIndexFactory() {
  }

  @Override
  public Set<String> getTypes() {
    return TYPES;
  }

  @Override
  public Set<String> getAlgorithms() {
    return ALGORITHMS;
  }

  @Override
  public OIndexInternal<?> createIndex(ODatabaseRecord oDatabaseRecord, String indexType, String algorithm,
      String valueContainerAlgorithm, ODocument metadata) throws OConfigurationException {
    return createLuceneIndex(oDatabaseRecord, indexType, valueContainerAlgorithm, metadata);
  }

  private OIndexInternal<?> createLuceneIndex(ODatabaseRecord oDatabaseRecord, String indexType, String valueContainerAlgorithm,
      ODocument metadata) {
    if (OClass.INDEX_TYPE.FULLTEXT.toString().equals(indexType)) {
      return new OLuceneFullTextIndex(indexType, LUCENE_ALGORITHM, new OLuceneIndexEngine<Set<OIdentifiable>>(
          new OLuceneFullTextIndexManager(), indexType), valueContainerAlgorithm, metadata);
    } else if (OClass.INDEX_TYPE.SPATIAL.toString().equals(indexType)) {
      return new OLuceneSpatialIndex(indexType, LUCENE_ALGORITHM, new OLuceneIndexEngine<Set<OIdentifiable>>(
          new OLuceneSpatialIndexManager(new OShapeFactoryImpl()), indexType), valueContainerAlgorithm);
    }
    throw new OConfigurationException("Unsupported type : " + indexType);
  }
}
```

To plug your factory create in your project under META-INF/services a text file called `com.orientechnologies.orient.core.index.OIndexFactory` and write inside your factory

Example
```
com.orientechnologies.lucene.OLuceneIndexFactory
```


## Implementing OIndexEngine

To write a new Index Engine implements the OIndexEngine interface.

The main methods are:

* get
* put


### get `V get(Object key);`
You have to return a Set of OIdentifiable or OIdentifiable if your index is unique, associated with the key.
The key could be:
- The value if you are indexing a single field (Integer,String,Double..etc).
- OCompositeKey if you are indexing two or more fields


### put `void put(Object key, V value);`


* The key is the value to be indexed. Could be as written before
* The value is a Set of OIdentifiable or OIdentifiable associated with the key

## Create Index from SQL

You can create an index with your Index Engine with sql with this syntax
```sql
CREATE INDEX Foo.bar ON Foo (bar) NOTUNIQUE ENGINE CUSTOM
```
where CUSTOM is the name of your index engine


