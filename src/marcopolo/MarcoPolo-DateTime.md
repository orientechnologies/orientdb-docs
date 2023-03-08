
# MarcoPolo - `DateTime`

This struct defines datetime objects in your Elixir application.  It renders as a `java.util.Date` class in OrientDB.

## Working with DateTimes

```
%MarcoPolo.DateTime{
   :year <year>,
   :month <month>,
   :day <day>,
   :hour <hour>,
   :min <minute>,
   :sec <sec>,
   :msec <msec>}
```

- **`<year>`** Defines the year in the date, a non-negative integer.  Defaults to 0.w
- **`<month>`** Defines the month in the date, a non-negative integer between 1 and 12.  Defaults to 1.
- **`<day>`** Defines the day in the date, a non-negative integer between 1 and 31.  Defaults to 1.
- **`<hour>`** Defines the hour in the time, a non-negative integer between 0 and 23.  Defaults to 0.
- **`<minute>`** Defines the minute of the time, a non-negative integer between 0 and 59. Defaults to 0.
- **`<sec>`** Defines the second of the time, a non-negative integer between 0 and 59.  Defaults to 0.
- **`<msec>`** Defines the microseconds of the time, a non-negative integer between 0 and 999.  Defaults to 0.

### Example

Imagine a case where you run a particular operation at set times each day.  Rather than defining DateTime objects every time you need to timestamp this operation, you might want a function to set the relevant data for you:

```elixir
@doc """ Generate Date for Fiscal Quarter """
def gen_datetime(year, month, day, count) do

	# Determine Month of Fiscal Quarter
	case count do
		1 -> hour = 6
		2 -> hour = 12
		3 -> hour = 18
		4 -> hour = 0
	end

	# Generate and Return Date
	%MarcoPolo.Date{
		:year year,
		:month month,
		:day day,
		:hour hour}
end
```
