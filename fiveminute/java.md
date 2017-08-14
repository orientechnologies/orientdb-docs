# OrientDB for Java Developers in Five Minutes

If you are a Java Developer and it's the first time you approach OrientDB, then you are in the right place!

Ready? Let's start!

## Step 0/5 - Download and Install

Download OrientDB from the following URL:

[http://orientdb.com/download.php?file=orientdb-community-3.0.0m2.tar.gz](http://orientdb.com/download.php?file=orientdb-community-3.0.0m2.tar.gz)

(you can find all the other download options here, if needed http://orientdb.com/orientdb-labs/)

Unzip it on your FileSystem and open a shell in the directory.

Now type 

```
cd orientdb-community-3.0.0m2
cd bin
```

and then, if you are on Linux/OSX, you can start the server with

```
./server.sh
```

if you are on Windows, start the server with

```
server.bat
```

You will see OrientDB starting

```
          .`        `                                 
          ,      `:.                                  
         `,`    ,:`                                   
         .,.   :,,                                    
         .,,  ,,,                                     
    .    .,.:::::   `  `                                :::::::::     :::::::::   
    ,`   .::,,,,::.,,,,,,`;;                      .:    ::::::::::    :::    :::  
    `,.  ::,,,,,,,:.,,.`  `                       .:    :::      :::  :::     ::: 
     ,,:,:,,,,,,,,::.   `        `         ``     .:    :::      :::  :::     ::: 
      ,,:.,,,,,,,,,: `::, ,,   ::,::`   : :,::`  ::::   :::      :::  :::    :::  
       ,:,,,,,,,,,,::,:   ,,  :.    :   ::    :   .:    :::      :::  :::::::     
        :,,,,,,,,,,:,::   ,,  :      :  :     :   .:    :::      :::  :::::::::   
  `     :,,,,,,,,,,:,::,  ,, .::::::::  :     :   .:    :::      :::  :::     ::: 
  `,...,,:,,,,,,,,,: .:,. ,, ,,         :     :   .:    :::      :::  :::     ::: 
    .,,,,::,,,,,,,:  `: , ,,  :     `   :     :   .:    :::      :::  :::     ::: 
      ...,::,,,,::.. `:  .,,  :,    :   :     :   .:    :::::::::::   :::     ::: 
           ,::::,,,. `:   ,,   :::::    :     :   .:    :::::::::     ::::::::::  
           ,,:` `,,.                                  
          ,,,    .,`                                  
         ,,.     `,                                          GRAPH DATABASE  
       ``        `.                                                          
                 ``                                          orientdb.com
                 `                                    

2017-08-14 14:11:12:824 INFO  Loading configuration from: /Users/luigidellaquila/temp/orient/orientdb-community-3.0.0m2/config/orientdb-server-config.xml... [OServerConfigurationLoaderXml]
2017-08-14 14:11:12:932 INFO  OrientDB Server v3.0.0m2 (build 4abea780acc12595bad8cbdcc61ff96980725c3b) is starting up... [OServer]
2017-08-14 14:11:12:951 INFO  OrientDB auto-config DISKCACHE=12.373MB (heap=1.963MB direct=524.288MB os=16.384MB) [orientechnologies]
2017-08-14 14:11:12:994 INFO  Databases directory: /Users/luigidellaquila/temp/orient/orientdb-community-3.0.0m2/databases [OServer]
2017-08-14 14:11:13:017 INFO  Creating the system database 'OSystem' for current server [OSystemDatabase]
2017-08-14 14:11:14:457 INFO  Listening binary connections on 0.0.0.0:2424 (protocol v.37, socket=default) [OServerNetworkListener]
2017-08-14 14:11:14:459 INFO  Listening http connections on 0.0.0.0:2480 (protocol v.10, socket=default) [OServerNetworkListener]

+---------------------------------------------------------------+
|                WARNING: FIRST RUN CONFIGURATION               |
+---------------------------------------------------------------+
| This is the first time the server is running. Please type a   |
| password of your choice for the 'root' user or leave it blank |
| to auto-generate it.                                          |
|                                                               |
| To avoid this message set the environment variable or JVM     |
| setting ORIENTDB_ROOT_PASSWORD to the root password to use.   |
+---------------------------------------------------------------+

Root password [BLANK=auto generate it]: *
```

The first time you start the server, you will be asked to enter a root password (twice). You can choose the password you prefer, 
just make sure to remember it, you will need it alter.

Now you are ready for the [Next Step - Create a Database >>>](java-1.md)
