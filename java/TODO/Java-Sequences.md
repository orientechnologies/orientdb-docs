### Create a sequence with Java API
```java
OSequenceLibrary sequenceLibrary = database.getMetadata().getSequenceLibrary();
OSequence seq = sequenceLibrary.createSequence("idseq", SEQUENCE_TYPE.ORDERED, new OSequence.CreateParams().setStart(0).setIncrement(1));
```


### Using a sequence with Java API
```java
OSequence seq = graph.getRawGraph().getMetadata().getSequenceLibrary().getSequence("idseq");
graph.addVertex("class:Account", "id", seq.next());
```


## Alter a sequence with Java API

```java
graph.getRawGraph().getMetadata().getSequenceLibrary().getSequence("idseq").updateParams( new OSequence.CreateParams().setStart(1000) );
```


### Drop a sequence with Java API
```java
graph.getRawGraph().getMetadata().getSequenceLibrary().dropSequence("idseq");
```
