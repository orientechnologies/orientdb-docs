# Run the server

After you have downloaded the binary distribution of OrientDB and unpacked it, you are now able to start the server. This is done by executing `server.sh` (or `server.bat` on Windows) located in `bin` directory:

``` console
$ cd bin
$ ./server.sh
```

You should now see the following output:

               .
              .`        `
              ,      `:.
             `,`    ,:`
             .,.   :,,
             .,,  ,,,
        .    .,.:::::  ````
        ,`   .::,,,,::.,,,,,,`;;                      .:
        `,.  ::,,,,,,,:.,,.`  `                       .:
         ,,:,:,,,,,,,,::.   `        `         ``     .:
          ,,:.,,,,,,,,,: `::, ,,   ::,::`   : :,::`  ::::
           ,:,,,,,,,,,,::,:   ,,  :.    :   ::    :   .:
            :,,,,,,,,,,:,::   ,,  :      :  :     :   .:
      `     :,,,,,,,,,,:,::,  ,, .::::::::  :     :   .:
      `,...,,:,,,,,,,,,: .:,. ,, ,,         :     :   .:
        .,,,,::,,,,,,,:  `: , ,,  :     `   :     :   .:
          ...,::,,,,::.. `:  .,,  :,    :   :     :   .:
               ,::::,,,. `:   ,,   :::::    :     :   .:
               ,,:` `,,.
              ,,,    .,`
             ,,.     `,                      S E R V E R
           ``        `.
                     ``
                     `

    2012-12-28 01:25:46:319 INFO Loading configuration from: config/orientdb-server-config.xml... [OServerConfigurationLoaderXml]
    2012-12-28 01:25:46:625 INFO OrientDB Server v1.6 is starting up... [OServer]
    2012-12-28 01:25:47:142 INFO -> Loaded memory database 'temp' [OServer]
    2012-12-28 01:25:47:289 INFO Listening binary connections on 0.0.0.0:2424 [OServerNetworkListener]
    2012-12-28 01:25:47:290 INFO Listening http connections on 0.0.0.0:2480 [OServerNetworkListener]
    2012-12-28 01:25:47:317 INFO OrientDB Server v1.6 is active. [OServer]


The log messages explain what happens when the server starts:

1. The server configuration is loaded from `config/orientdb-server-config.xml` file. To know more about this step, look into [OrientDB Server](DB-Server.md)

1. By default, a "temp" database is always loaded into memory. This is a volatile database that can be used to store temporary data

1. Binary connections are listening on port 2424 for all configured networks (0.0.0.0). If you want to change this configuration edit the `config/orientdb-server-config.xml` file and modify port/ip settings

1. HTTP connections are listening on port 2480 for all configured networks (0.0.0.0). If you want to change this configuration edit the `config/orientdb-server-config.xml` file and modify port/ip settings

OrientDB server listens on 2 different ports by default. Each port is dedicated to binary and HTTP connections respectively:
- **binary** port is used by the console and clients/drivers that support the [network binary protocol](Network-Binary-Protocol.md)
- **HTTP** port is used by [OrientDB Studio web tool](http://www.orientechnologies.com/docs/last/orientdb-studio.wiki/Home-page.html) and clients/drivers that support the [HTTP/REST protocol](OrientDB-REST.md) or tools like [CURL](http://en.wikipedia.org/wiki/CURL)

