
# Profiler

[OrientDB Enterprise Edition](../ee/Enterprise-Edition.md) comes with a profiler that collects all the metrics about the engine and the system where is running. Studio uses the profiler API as source for the [Dashboard](./Dashboard.md) and can be configured in the [Settings](./Settings.md) section.

Profiler is available through Studio or HTTP APIs  
to server user that has those permissions

- `server.metrics` (Read)  
- `server.metrics.edit` (Write)

## Configuration

The profiler is configured via `JSON` file, located  `${ORIENTDB_HOME}/config/profiler.json` the  Enterprise distribution

Example of configuration

```JSON
{
  "enabled": true,
  "server": {
    "enabled": true
  },
  "database": {
    "enabled": true
  },
  "cluster": {
    "enabled": false
  },
  "reporters": {
    "jmx": {
      "enabled": false,
      "domain": "Test"
    },
    "console": {
      "enabled": false,
      "interval": 5000
    },
    "csv": {
      "enabled": false,
      "directory": "/tmp/orientdb-server-metrics.csv",
      "interval": 5000
    },
    "prometheus": {
      "enabled": false
    }
  }
}
```

The profiler is divided in 3 sections which can be enabled/disabled 

- Database metrics
- Server metrics
- Cluster metrics

### Database metrics

The suffix is `db.<dbName>.*`

These metrics contains statistics on crud operations and queries and are recorded for each database in the server.

### Server Metrics

The suffix is `server.*`

These metrics contains information on the status and health of the server such as

- Memory metrics
- Disk metrics
- Disk Cache 
- CPU stats
- GC activity
- Threads
- Network requests
- Active sessions
- ....

### Cluster metrics

The suffix is `distributed.*`

These metrics contains information on the status of nodes in the cluster and latencies

### Reporters

The profiler supports different outputs that can  be configured in the reporters section:

- CSV
- JMX
- Console
- Prometheus


The profiler also expose custom HTTP api to server users with right permissions

## HTTP APIs

### Retrieve profiler metrics via HTTP

GET | Basic Auth

```
http://<server>[<:port>]/metrics
```

Retrieve stats recorded by the profiler



### Prometheus endpoint

If it is enabled as reporter

GET | Basic Auth

```
http://<server>[<:port>]/metrics/prometheus
```

Retrieve stats recorded by the profiler with prometheus format


### Retrieve profiler configuration

GET | Basic Auth

```
http://<server>[<:port>]/metrics/config
```

### Change profiler configuration

POST | Basic Auth

```
http://<server>[<:port>]/metrics/config
```

with configuration as JSON body


### Get the list of available metrics with description

GET | Basic Auth

```
http://<server>[<:port>]/metrics/list
```

