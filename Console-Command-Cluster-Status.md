<!-- proofread 2015-01-07 SAM -->

# Console - `CLUSTER STATUS`

Displays the status of the cluster in distributed configuration.

**Syntax:**

```
CLUSTER STATUS
```

**Example:**

- Display the status of the cluster:

  <pre>
  orientdb> <code class="lang-sql userinput">CLUSTER STATUS</code>
  <code class="lang-json">
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
  }</code>
  </pre>

>For more information on other commands, see [Console Commands](Console-Commands.md).
