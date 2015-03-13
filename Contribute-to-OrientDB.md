# Contribute to OrientDB

In order to contribute issues and pull requests, please sign OrientDB's [Contributor License Agreement](https://www.clahub.com/agreements/orientechnologies/orientdb). The purpose of this agreement is to protect users of this codebase by ensuring that all code is free to use under the stipulations of the [Apache2 license](http://www.apache.org/licenses/LICENSE-2.0.html).

## Pushing into main repository
If you'd like to contribute to OrientDB with a patch follow the following steps:
* apply your changes,
* test that Test Suite hasn't been broken. Execute both commands:
 * ant clean test
 * mvn clean test
* if all the tests pass then do a **Pull Request** (PR) against **"develop"** branch on GitHub and write a comment about the change. Don't sent PR to "master" because we use that only for releasing

## Code formatting
You can find eclipse java formatter config file here: [_base/ide/eclipse-formatter.xml](https://github.com/orientechnologies/orientdb/blob/master/_base/ide/eclipse-formatter.xml)

If you use IntelliJ IDEA you can install [this](http://plugins.jetbrains.com/plugin/?id=6546) plugin and use formatter profile mentioned above.

## Issue priorities

As soon as github issues does not provide way to manage issue prioritization, priorities of issues are defined as tags.

|Priority | Definition    |
|---------|---------------|
|Critical | The OrientDB server in Production doesn’t start up or the database is corrupted in anyway. Issues encountered in a test or development environment and enhancement requests should not be listed as Critical.|
|High     | The Issue has impact on OrientDB functionality in Production, but against a non critical component. OrientDB still works.|
|Medium   | The Issue hasn’t impact on the OrientDB operation and can be bypassed with a round trip.|
|Low      | Little or no impact on OrientDB. Cosmetic problem or minor enhancement.|
