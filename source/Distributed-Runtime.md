# Distributed runtime
_NOTE: available only in Enteprise Edition_

## Node status

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

### Queues
_NOTE: available only in Enteprise Edition_

OrientDB uses distributed queues to exchange messages between OrientDB servers. To have metrics about queues, execute a HTTP GET operation against the URL `http://<server>:<port>/distributed/queue/<queue-name>`. Use `*` as queue name to return stats for all he queues. Example:

    curl -u root:root "http://localhost:2480/distributed/queue/*"


