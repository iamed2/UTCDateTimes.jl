module UTCDateTimes

export UTCDateTime

using Dates
using TimeZones

function __init__()
    # same as DateTime minus AMPM
    Dates.CONVERSION_TRANSLATIONS[UTCDateTime] = (
        Year, Month, Day, Hour, Minute, Second, Millisecond
    )
end

struct UTCDateTime <: Dates.AbstractDateTime
    dt::DateTime
end

UTCDateTime(y::Integer, args::Integer...) = UTCDateTime(DateTime(y, args...))
UTCDateTime(period::Period, periods::Period...) = UTCDateTime(DateTime(period, periods...))
UTCDateTime(d::Date, t::Time) = UTCDateTime(DateTime(d, t))

UTCDateTime(zdt::ZonedDateTime) = UTCDateTime(DateTime(zdt, Dates.UTC))

include("dates.jl")
include("timezones.jl")
include("io.jl")

end
