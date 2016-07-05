# Data Centers

Starting from OrientDB Enterprise Edition v2.2.4, you can define how your servers are deployed in multiple **Data Centers**. All you need is using the tag `"dataCenters"` in your [`default-distributed-config.json`](Distributed-Configuration.html#default-distributed-db-configjson) configuration file. This is the format:

```json
  "dataCenters": {
    "<data-center1-name>": {
      "writeQuorum": "<data-center1-quorum>",
      "servers": [ "<data-center1-server1>", "<data-center1-server2>", "<data-center1-serverN>" ]
    },
    "<data-center2-name>": {
      "writeQuorum": "<data-center2-quorum>",
      "servers": [ "<data-center2-server1>", "<data-center2-server2>", "<data-center2-serverN>" ]
    },
  },
```


NOTE: _This _.

Example about the configuration of 2 data centers, "rome" and "austin", with rispectively 3 and 2 servers.

```json
{
  "autoDeploy": true,
  "readQuorum": 1,
  "writeQuorum": "localDataCenter",
  "readYourWrites": true,
  "dataCenters": {
    "rome": {
      "writeQuorum": "majority",
      "servers": [ "europe-0", "europe-1", "europe-2" ]
    },
    "austin": {
      "writeQuorum": "majority",
      "servers": [ "usa-0", "usa-1" ]
    }
  },
  "servers": {
    "*": "master"
  },
  "clusters": {
    "internal": {},
    "*": {
      "servers": [ "<NEW_NODE>" ]
    }
  }
}
```

