# Console - CLUSTERS STATUS

Displays the status of distributed configuration.

## Syntax

```
CLUSTERS STATUS
```

## Example

```sql
orientdb> CLUSTER STATUS

{
    "localName": "_hzInstance_1_orientdb",
    "localId": "3735e690-9a7b-44d2-b4bc-27089da065e2",
    "members": [
        {
            "id": "3735e690-9a7b-44d2-b4bc-27089da065e2",
            "name": "node1",
            "startedOn": "2015-05-14 17:06:40:418",
            "listeners": [
                {
                    "protocol": "ONetworkProtocolBinary",
                    "listen": "10.3.15.55:2424"
                },
                {
                    "protocol": "ONetworkProtocolHttpDb",
                    "listen": "10.3.15.55:2480"
                }
            ],
            "databases": []
        }
    ]
}
```


This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
