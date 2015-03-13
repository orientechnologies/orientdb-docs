# Hooks (Triggers)

Hook works like a trigger. Hook lets to the user application to intercept internal events before and after each CRUD operation against records. You can use to write custom validation rules, to enforce security or even to orchestrate external events like the replication against a Relational DBMS.

OrientDB supports two main kinds of Hooks:
- [Dynamic Hooks](Dynamic-Hooks.md), defined at schema and/or document level
- Native [Java Hooks](Java-Hooks.md), defined as Java classes

### What use? Pros/Cons?
Depends by your goal: Java Hooks are the fastest hooks. Write a Java Hook if you need the best performance on execution. Dynamic Hooks are more flexible, can be changed at run-time and can run per document if needed, but are slower than Java Hooks.
