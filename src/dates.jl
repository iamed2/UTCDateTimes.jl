DateTime(utcdt::UTCDateTime) = utcdt.dt

const delegated = [
    :days,
    :hour,
    :minute,
    :second,
    :millisecond,
    :Year,
    :Quarter,
    :Month,
    :Week,
    :Day,
    :Hour,
    :Minute,
    :Second,
    :Millisecond,
    :Date,
    :Time,
]

for f in delegated
    @eval Dates.$f(utcdt::UTCDateTime) = Dates.$f(utcdt.dt)
end

const wrapped_delegated = [
    :firstdayofweek,
    :lastdayofweek,
    :firstdayofmonth,
    :lastdayofmonth,
    :firstdayofyear,
    :lastdayofyear,
    :firstdayofquarter,
    :lastdayofquarter,
]

for f in wrapped_delegated
    @eval Dates.$f(utcdt::UTCDateTime) = UTCDateTime(Dates.$f(utcdt.dt))
end

# comparison
Base.:(==)(a::UTCDateTime, b::UTCDateTime) = a.dt == b.dt
Base.isless(a::UTCDateTime, b::UTCDateTime) = isless(a.dt, b.dt)

# arithmetic
Base.:(-)(a::UTCDateTime, b::UTCDateTime) = a.dt - b.dt
Base.:(+)(a::UTCDateTime, p::Period) = UTCDateTime(a.dt + p)
Base.:(-)(a::UTCDateTime, p::Period) = UTCDateTime(a.dt - p)

# Conversions
Base.convert(::Type{DateTime}, utcdt::UTCDateTime) = utcdt.dt
Base.convert(::Type{UTCDateTime}, dt::DateTime) = UTCDateTime(dt)

# ranges
## I don't like this but it appears to be the best way to get length of ranges to work
## See https://github.com/JuliaLang/julia/blob/75e2402f3353cfaa5fa71336c7350714cb61c538/stdlib/Dates/src/ranges.jl#L10
Dates.guess(a::UTCDateTime, b::UTCDateTime, c) = Dates.guess(a.dt, b.dt, c)

# rounding
Base.trunc(utcdt::UTCDateTime, t::Type{<:Period}) = UTCDateTime(trunc(utcdt.dt, t))
Base.floor(utcdt::UTCDateTime, p::Period) = UTCDateTime(floor(utcdt.dt, p))

# parsing/formatting
Dates.default_format(::Type{UTCDateTime}) = Dates.default_format(DateTime)
# Note: The `validargs` function is as part of the Dates parsing interface.
Dates.validargs(::Type{UTCDateTime}, args...) = Dates.validargs(DateTime, args...)
