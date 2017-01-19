# Memory Leak Detector

OrientDB uses off-heap memory pool for its file cache allocations. Leaks of such allocations can't be tracked using standard Java techniques like heap dumps, to overcome this problem we developed a specialized leak detector. For sure, OrientDB is designed to avoid any kind of leaks, but sometimes bad things happen.

> Use the leak detector for debugging and troubleshooting purposes only, since it significantly slowdowns OrientDB off-heap memory management infrastructure. Never leave the leak detector turned on in a production setup.

## Activating Leak Detector

To activate the leak detection provide the `memory.directMemory.trackMode=true` configuration option to the OrientDB instance in question. For example, you may provide following command line argument to the JVM:

    java ... -Dmemory.directMemory.trackMode=true ...

Leak detector may be turned on or off at startup time only, at runtime changing the `memory.directMemory.trackMode` setting will have no effect.

#### Activating Debugging Logger

Leak detector uses logging facilities to report detected problems. To be sure you see all produced log entries activate the OrientDB debugging logger. Provide following command line argument to the JVM to activate it:

    -Djava.util.logging.manager=com.orientechnologies.common.log.OLogManager$DebugLogManager

> Make sure `$DebugLogManager` part is not interpreted as a shell variable substitution. To avoid the substitution apply escaping specific to your shell environment.
> Read more about debugging logger [here](Logging.md#debugging-logger).

## Inspecting for Leaks

After activation of both the leak detector and the debugging logger, information about found problems will be written to the log. Related log entries are marked with the `DIRECT-TRACK` label. Leak detector is able to detect following problems:

1. Attempt to release an off-heap memory buffer more than once. Reported instantly.
2. Presence of suspicious memory buffers released due to the JVM object finalization procedure. Reported during OrientDB lifetime, but not instantly.
3. Presence of unreleased/leaked memory buffers. Reported at OrientDB runtime shutdown.

## Summary

The leak detection procedure looks as follows:

1. Shutdown the OrientDB instance in question, if it's running.
2. Activate the leak detector and the debugging logger as described above.
3. Start the OrientDB instance.
4. Start a workload cycle specific to your application.
5. Monitor for leaks using the log.
6. Wait for the workload cycle to finish.
7. Stop the OrientDB instance.
8. Inspect the OrientDB log for leaks detected at shutdown.
