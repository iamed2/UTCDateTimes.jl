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

# arithmetic
Base.:(-)(utcdt::UTCDateTime, zdt::ZonedDateTime) = utcdt.dt - DateTime(zdt, Dates.UTC)
Base.:(-)(zdt::ZonedDateTime, utcdt::UTCDateTime) = DateTime(zdt, Dates.UTC) - utcdt.dt

function TimeZones.zdt2unix(utcdt::UTCDateTime)
    TimeZones.datetime2unix(utcdt.dt)
end

function zdt2unix(::Type{T}, utcdt::UTCDateTime) where T<:Integer
    floor(T, datetime2unix(utcdt.dt))
end

function zdt2unix(::Type{T}, utcdt::UTCDateTime) where T<:Real
    convert(T, datetime2unix(utcdt.dt))
end
