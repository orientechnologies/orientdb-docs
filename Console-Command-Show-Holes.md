# Displays the free holes in databases.

# Introduction

OrientDB keep the free space as "holes". To remove the holes you have to compact the database using the [compact database](SQLCompactDatabase.md) command.

# Syntax

```java
show holes
```

Example:

```java
orientdb> show holes

Found 20 holes in database demo:
+----------------------+----------------------+
| Position             | Size (in bytes)      |
+----------------------+----------------------+
|                49907 |                   87 |
|               181183 |                   71 |
|               272858 |                  150 |
|               623022 |                  137 |
|               198122 |                   85 |
|               519971 |                  108 |
|              2267766 |                  160 |
|               369795 |                   82 |
|              1017483 |                  128 |
|               736590 |                   92 |
|              1052774 |                  117 |
|               934513 |                   71 |
|              1180103 |                   91 |
|              1137256 |                   75 |
|              1242670 |                   81 |
|              1685483 |                  124 |
|                46420 |                  107 |
|                46143 |                   66 |
|               815670 |                   88 |
|                24839 |                   79 |
+----------------------+----------------------+
|      Total hole size |               1,95Kb |
+----------------------+----------------------+
```

This is a command of the Orient console. To know all the commands go to [Console-Commands](Console-Commands.md).
