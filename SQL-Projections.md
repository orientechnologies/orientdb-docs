## SQL Projections

A projection is a value that is returned by a query statement (SELECT, MATCH).

Eg. the following query

```sql
SELECT name as firstName, age * 12 as ageInMonths, out("Friend") from Person where surname = 'Smith'
```

has three projections:

- `name as firstName`
- `age * 12 as ageInMonths`
- `out("Friend")`

### Syntax

**A projection** has the following syntax:

`<expression> [ AS <alias> ]`

- `<expression>` is an expression (see [SQL Syntax](SQL-Syntax.md)) that represents the way to calculate the value of the single projection
- `<alias>` is the Identifier (see [SQL Syntax](SQL-Syntax.md)) representing the field name used to return the value in the result set

A projection block has the following syntax:

`[DISTINCT] <projection> [, <projection> ]*`

- `DISTINCT`: removes duplicates from the result-set





