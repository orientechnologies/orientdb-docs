# Distributed runtime
_NOTE: available only in Enteprise Edition_

## Node status
To retrieve the distributed configuration of a OrientDB server, execute a HTTP GET operation against the URL `http://<server>:<port>/distributed/node`. Example:

    curl -u root:root "http://localhost:2480/distributed/node"

Result:

```json
{
    "localId": "9e20f766-5f8c-4a5c-a6a2-7308019db702",
    "localName": "_hzInstance_1_orientdb",
    "members": [
        {
            "databases": [],
            "id": "b7888b58-2b26-4098-bb4d-8e23a5050b68",
            "listeners": [
                {
                    "listen": "10.0.1.8:2425",
                    "protocol": "ONetworkProtocolBinary"
                },
                {
                    "listen": "10.0.1.8:2481",
                    "protocol": "ONetworkProtocolHttpDb"
                }
            ],
            "name": "node2",
            "startedOn": "2015-09-28 13:19:09:267"
        },
        {
            "databases": [],
            "id": "9e20f766-5f8c-4a5c-a6a2-7308019db702",
            "listeners": [
                {
                    "listen": "10.0.1.8:2424",
                    "protocol": "ONetworkProtocolBinary"
                },
                {
                    "listen": "10.0.1.8:2480",
                    "protocol": "ONetworkProtocolHttpDb"
                }
            ],
            "name": "node1",
            "startedOn": "2015-09-28 12:58:11:819"
        }
    ]
}
```

## Database configuration

To retrieve the distributed configuration for a database, execute a HTTP GET operation against the URL `http://<server>:<port>/distributed/database/<database-name>`. Example:

    curl -u root:root "http://localhost:2480/distributed/database/GratefulDeadConcerts"


Result:

```json
{
    "autoDeploy": true,
    "clusters": {
        "*": {
            "servers": [
                "node1",
                "node2",
                "<NEW_NODE>"
            ]
        },
        "v": {
            "servers": [
                "node2",
                "node1",
                "<NEW_NODE>"
            ]
        }
    },
    "executionMode": "undefined",
    "failureAvailableNodesLessQuorum": false,
    "hotAlignment": false,
    "readQuorum": 1,
    "readYourWrites": true,
    "servers": {
        "*": "master"
    },
    "version": 21,
    "writeQuorum": 2
}
```

### Queues

OrientDB uses distributed queues to exchange messages between OrientDB servers. To have metrics about queues, execute a HTTP GET operation against the URL `http://<server>:<port>/distributed/queue/<queue-name>`. Use `*` as queue name to return stats for all he queues. Example:

    curl -u root:root "http://localhost:2480/distributed/queue/*"


Result:

```json
{
    "queues": [
        {
            "avgAge": 0,
            "backupItemCount": 0,
            "emptyPollOperationCount": 0,
            "eventOperationCount": 0,
            "maxAge": 0,
            "minAge": 0,
            "name": "orientdb.node.node1.benchmark.insert.request",
            "nextMessages": [],
            "offerOperationCount": 0,
            "otherOperationsCount": 0,
            "ownedItemCount": 0,
            "partitionKey": "orientdb.node.node1.benchmark.insert.request",
            "pollOperationCount": 0,
            "rejectedOfferOperationCount": 0,
            "serviceName": "hz:impl:queueService",
            "size": 0
        },
        {
            "avgAge": 1,
            "backupItemCount": 0,
            "emptyPollOperationCount": 0,
            "eventOperationCount": 0,
            "maxAge": 1,
            "minAge": 1,
            "name": "orientdb.node.node2.response",
            "nextMessages": [],
            "offerOperationCount": 60,
            "otherOperationsCount": 12,
            "ownedItemCount": 0,
            "partitionKey": "orientdb.node.node2.response",
            "pollOperationCount": 60,
            "rejectedOfferOperationCount": 0,
            "serviceName": "hz:impl:queueService",
            "size": 0
        },
        {
            "avgAge": 0,
            "backupItemCount": 0,
            "emptyPollOperationCount": 0,
            "eventOperationCount": 0,
            "maxAge": 0,
            "minAge": 0,
            "name": "orientdb.node.node2.benchmark.request",
            "nextMessages": [],
            "offerOperationCount": 0,
            "otherOperationsCount": 0,
            "ownedItemCount": 0,
            "partitionKey": "orientdb.node.node2.benchmark.request",
            "pollOperationCount": 0,
            "rejectedOfferOperationCount": 0,
            "serviceName": "hz:impl:queueService",
            "size": 0
        },
        {
            "avgAge": 1,
            "backupItemCount": 0,
            "emptyPollOperationCount": 0,
            "eventOperationCount": 0,
            "maxAge": 1,
            "minAge": 1,
            "name": "orientdb.node.node1.GratefulDeadConcerts.request",
            "nextMessages": [],
            "offerOperationCount": 44,
            "otherOperationsCount": 53,
            "ownedItemCount": 0,
            "partitionKey": "orientdb.node.node1.GratefulDeadConcerts.request",
            "pollOperationCount": 44,
            "rejectedOfferOperationCount": 0,
            "serviceName": "hz:impl:queueService",
            "size": 0
        }
    ]
}
```
