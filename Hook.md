# Hooks (Triggers)

Hooks work like triggers and enables the user's application to intercept internal events before and after each CRUD operation against records. You can use them to write custom validation rules, to enforce security, or even to orchestrate external events like replicating against a Relational DBMS.

OrientDB supports two kinds of Hooks:
- [Dynamic Hooks](Dynamic-Hooks.md), defined at the schema and/or document level
- Native [Java Hooks](Java-Hooks.md), defined as Java classes

### What use? Pros/Cons?

Depends on your goal: Java Hooks are faster. Write a Java Hook if you need the best performance on execution. Dynamic Hooks are more flexible, can be changed at run-time, and can run per document if needed, but are slower than Java Hooks.
