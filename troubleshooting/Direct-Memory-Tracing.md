# Direct Memory Allocations Tracing

OrientDB uses off-heap memory pool for its file cache allocations. Direct memory allocations tracing allows to trace allocations done by this pool.

> Use direct memory allocations tracing for debugging and troubleshooting purposes only, since it significantly slowdowns OrientDB off-heap memory management infrastructure. Never leave the tracer turned on in a production setup.

## Activating Allocations Tracing

To activate allocations tracing provide the `memory.directMemory.trace=true` configuration option to the OrientDB instance in question. For example, you may provide following command line argument to the JVM:

    java ... -Dmemory.directMemory.trace=true ...

Alternatively, you may enable/disable the tracer at runtime by changing the value of `OGlobalConfiguration#DIRECT_MEMORY_TRACE` setting or by invoking `startTracing`/'stopTracing' operation on the `com.orientechnologies.common.directmemory:type=OByteBufferPoolMXBean` JMX bean.

## Inspecting the Log

After activation of the tracing, information about relevant events will be written to [regular OrientDB log](../admin/Logging.md). Related log entries are marked with the `DIRECT-TRACE` label. General format of the log entry looks like:

    DIRECT-TRACE $event: $name = $before + $delta = $after, buffer = $buffer_id

* `$event` – the event type.
* `$name` – the name of the value being changed.
* `$before` – the value before the event.
* `$delta` – the delta of the value.
* `$after` – the value after the event.
* `$buffer_id` – the identifier of the buffer related to the event, if any.

Tracer is able to report following event types:

* `AcquiredFromPool` – the buffer is acquired/reused from the pool; change in the pool size is reported.
* `OverflowBufferAllocated` – the overflow buffer allocated; changes in the overflow buffer count and in the total allocated memory are reported. Usually, overflow allocations indicate memory settings misconfiguration and/or low-memory conditions.
* `SlicedFromPreallocatedArea` – the buffer is allocated/sliced from a large preallocated chunk of the memory; the change in the chunk size is reported.
* `FallbackBufferAllocated` – the fallback overflow buffer allocated; changes in the overflow buffer count and in the total allocated memory are reported. Usually, fallback overflow allocations indicate severe memory settings misconfiguration and/or severe low-memory conditions.
* `AllocatedForPreallocatedArea` – the large preallocation buffer is allocated to slice smaller buffers from it later; change in the total allocated memory is reported.
* `ReturnedToPool` – the buffer is returned to the pool; change in the pool size is reported.
* `DirectBufferPoolSizeChanged` – JVM's allocated direct memory size is changed.

## Event Aggregation

You may change the "spamness" of the tracer by adjusting the value of `memory.directMemory.trace.aggregation` setting. Possible values:

* `none` – for no aggregation, events are traced one-by-one.
* `low` – for low aggregation which provides more details.
* `medium` (default) – provides medium level of details.
* `high` – provides low level of details.

Alternatively, you may adjust the aggregation level at runtime by changing the value of `OGlobalConfiguration#DIRECT_MEMORY_TRACE_AGGREGATION` setting or by changing the value of the `TraceAggregation` attribute on the `com.orientechnologies.common.directmemory:type=OByteBufferPoolMXBean` JMX bean.

## See Also

* [Memory Leak Detector](Leak-Detector.md)
* [Logging](../admin/Logging.md)
