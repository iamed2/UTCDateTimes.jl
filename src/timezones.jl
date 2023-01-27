function TimeZones.ZonedDateTime(
    utcdt::UTCDateTime, tz::TimeZone=tz"UTC"; from_utc::Bool=true
)
    if from_utc !== true
        throw(ArgumentError("`from_utc` must be true when passing UTCDateTimes"))
    end
    return ZonedDateTime(utcdt.dt, tz; from_utc=true)
end

TimeZones.astimezone(utcdt::UTCDateTime, tz::TimeZone) = ZonedDateTime(utcdt, tz)
TimeZones.timezone(utcdt::UTCDateTime) = tz"UTC"

# comparisons
Base.:(==)(utcdt::UTCDateTime, zdt::ZonedDateTime) = utcdt.dt == DateTime(zdt, Dates.UTC)
Base.:(==)(zdt::ZonedDateTime, utcdt::UTCDateTime) = utcdt == zdt
function Base.isless(utcdt::UTCDateTime, zdt::ZonedDateTime)
    return isless(utcdt.dt, DateTime(zdt, Dates.UTC))
end
function Base.isless(zdt::ZonedDateTime, utcdt::UTCDateTime)
    return isless(DateTime(zdt, Dates.UTC), utcdt.dt)
end

"""
    hash(::UTCDateTime, h)

Compute an integer hash code for a UTCDateTime by hashing the `dt` field.
`hash(:utc_instant, h)` is used to intentionally hash equivalent
`UTCDateTimes` and `ZonedDateTimes` to the same value.
"""
function Base.hash(utcdt::UTCDateTime, h::UInt)
    h = hash(:utc_instant, h)
    h = hash(utcdt.dt, h)
    return h
end

# arithmetic
Base.:(-)(utcdt::UTCDateTime, zdt::ZonedDateTime) = utcdt.dt - DateTime(zdt, Dates.UTC)
Base.:(-)(zdt::ZonedDateTime, utcdt::UTCDateTime) = DateTime(zdt, Dates.UTC) - utcdt.dt

# Conversions between zdt and utcdt
Base.convert(::Type{ZonedDateTime}, utcdt::UTCDateTime) = ZonedDateTime(utcdt)
Base.convert(::Type{UTCDateTime}, zdt::ZonedDateTime) = UTCDateTime(zdt)

function TimeZones.zdt2unix(utcdt::UTCDateTime)
    TimeZones.datetime2unix(utcdt.dt)
end

function TimeZones.zdt2unix(::Type{T}, utcdt::UTCDateTime) where T<:Integer
    floor(T, datetime2unix(utcdt.dt))
end

function TimeZones.zdt2unix(::Type{T}, utcdt::UTCDateTime) where T<:Real
    convert(T, datetime2unix(utcdt.dt))
end
