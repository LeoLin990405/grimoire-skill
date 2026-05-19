---
name: lubridate
description: R lubridate package for date-time manipulation. Use for parsing, extracting, and arithmetic with dates and times.
---

# lubridate

Date-time manipulation.

## Parsing

```r
library(lubridate)

# Parse dates
ymd("2024-01-15")
mdy("01/15/2024")
dmy("15-01-2024")
ymd_hms("2024-01-15 10:30:00")
mdy_hm("01/15/2024 10:30")

# Parse with timezone
ymd_hms("2024-01-15 10:30:00", tz = "America/New_York")

# Parse multiple formats
parse_date_time(x, orders = c("ymd", "mdy", "dmy"))
```

## Extract Components

```r
dt <- ymd_hms("2024-01-15 10:30:45")

year(dt)      # 2024
month(dt)     # 1
day(dt)       # 15
hour(dt)      # 10
minute(dt)    # 30
second(dt)    # 45

wday(dt)      # Day of week (1-7)
wday(dt, label = TRUE)  # "Mon"
yday(dt)      # Day of year
week(dt)      # Week of year
quarter(dt)   # Quarter

# Set components
year(dt) <- 2025
month(dt) <- 6
```

## Rounding

```r
# Round
round_date(dt, "hour")
round_date(dt, "day")
round_date(dt, "month")

# Floor/ceiling
floor_date(dt, "week")
ceiling_date(dt, "month")
```

## Arithmetic

```r
# Add/subtract
dt + days(5)
dt - weeks(2)
dt + months(3)
dt + years(1)
dt + hours(6) + minutes(30)

# Durations (exact)
dt + ddays(5)
dt + dweeks(2)
dt + dhours(48)

# Periods (calendar)
dt + period(months = 1, days = 15)

# Intervals
interval(start, end)
int <- ymd("2024-01-01") %--% ymd("2024-12-31")
int_start(int)
int_end(int)
int_length(int)  # Seconds
dt %within% int
```

## Timezones

```r
# Get/set timezone
tz(dt)
with_tz(dt, "Europe/London")  # Convert display
force_tz(dt, "Europe/London")  # Change timezone

# List timezones
OlsonNames()
```

## Helpers

```r
# Current time
now()
today()

# Check
is.Date(x)
is.POSIXt(x)
leap_year(2024)

# Formatting
stamp("March 1, 1999")(dt)
stamp("3/1/99")(dt)
```
