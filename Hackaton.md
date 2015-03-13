# Hackaton

Hackatons are the appointement where OrientDB old and new committers and contributors work together in few hours, on the same spot, or connected online.

## The draft rules are (please contribute to improve it):

1. Committers will support contributors and new users on Hackaton
1. A new Google Hangout will be created, so if you want to attendee please send me your gmail/gtalk account
1. We'll use the hangout to report to the committer issues to close, or any questions about issues
1. We'll start from current release (1.7) and then go further (2.0, 2.1, no-release-tag)
1. If the issue is pretty old (>4 months), comment it about trying the last 1.7-rc2. We could have some chance the issue has already been fixed
1. If the problem is with a SQL query, you could try to reproduce against the GratefulDeadConcerts database or even an empty database. If you succeed on reproduce it, please comment with additional information about the issue

## Contribution from Java Developers

1. If you're a Java developer and you can debug inside OrientDB code (that's would be great) you could include more useful information about the issue or even fix it
1. If you think the issue has been fixed with your patch, please run all the test cases with:
 - ant clean test
 - mvn clean test
1. If all tests pass, send us a Pull Request (see below)

## Contribution to the Documentation

1. We're aware to have not the best documentation of the planet, so if you can improve on this would be awesome
1. JavaDoc, open a Java class, and:
 1. add the JavaDoc at the top of the class. This is the most important documentation in code we can have. if it's pertinent
 1. add the JavaDoc for the public methods. It't better having a description about the method than the detail of all the parameters, exceptions, etc

## Send a Pull Request!

We use GitHub and it's fantastic to work in a team. In order to make our life easier, the best way to contribute is with a Pull Request:

1. Goto your GitHub account. if you don't have it, create it in 2 minutes: www.github.com
1. Fork this project: https://github.com/orientechnologies/orientdb, or any other projects you want to contribute
1. Commit locally against the "develop" branch
1. Push your changes to your forked repository on GitHub
1. Send us a Pull Request and wait for the merging

