---
search:
   keywords: ['MarcoPolo', 'Marco Polo', 'Elixir', 'date']
---

# MarcoPolo - `Date`

This struct is defines date objects in your Elixir application.  It renders as a `java.util.Date` class in OrientDB.

## Working with Dates

```
%MarcoPolo.Date{
	:year <year>,
	:month <month>,
	:day <day>}
```

- **`<year>`** Defines the year in the date, a non-negative integer.  Defaults to 0.
- **`<month>`** Defines the month in the date, a non-negative integer between 1 and 12. Defaults to 1.
- **`<day>`** Defines the day in the date, a non-negative integer between 1 and 31.  Defaults to 1.

### Example

For instance, imagine you have an application that logs quarterly reports in OrientDB.  You might create a function to automatically generate fixed date objects for each quarter of the fiscal year, which in the United States runs from October 1 to September 30.

```elixir
@doc """ Generate Date for Fiscal Quarter """
def gen_date_quarter(quart, year) do

	# Determine Month of Fiscal Quarter
	case quart do
		1 -> month = 10
		2 -> month = 1
		3 -> month = 4
		4 -> month = 7
	end

	# Generate and Return Date
	%MarcoPolo.Date{
		:year year,
		:month month,
		:day 1}
end
```
