---
search:
   keywords: ['PHP', 'PhpOrient', 'record']
---

# PhpOrient - `Record()`

On occasion, you may want to operate a record or build one from scratch within your application, before adding it to or syncing it with OrientDB.  In PhpOrient, these operations are controlled by the `Record()` class.

## Working with Records

Record objects require no arguments to instantiate.  Once created, you can call various methods on the object to define its class, Record ID, data and so on.

```php
$record = new Record()
   ->setOClass('V')
   ->setRid(new ID(0))
   ->setOData(
      ['accommodation' => 'bungalow']);
```

| Method | Description |
|---|---|
| [**`getOClass()`**](PHP-Record-getOClass.md) | Retrieve the class name |
| [**`getOData()`**](PHP-Record-getOData.md) | Retrieves record data |
| [**`getRid()`**](PHP-Record-getRid.md) | Returns the Record ID |
| [**`jsonSerialize()`**](PHP-Record-jsonSerialize.md) | Returns record in serialized JSON format |
| [**`recordSerialize()`**](PHP-Record-serializeRecord.md) | Returns record in serialized format |
| [**`setOClass()`**](PHP-Record-setOClass.md) | Sets the class |
| [**`setOData()`**](PHP-Record-setOData.md) | Sets record data |
| [**`setRid()`**](PHP-Record-setRidmd) | Sets the Record ID |
