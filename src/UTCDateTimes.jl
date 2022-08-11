module UTCDateTimes

export UTCDateTime

using Dates
using TimeZones

struct UTCDateTime <: Dates.AbstractDateTime
    dt::DateTime
end

UTCDateTime(y::Integer, args::Integer...) = UTCDateTime(DateTime(y, args...))
UTCDateTime(period::Period, periods::Period...) = UTCDateTime(DateTime(period, periods...))
UTCDateTime(d::Date, t::Time) = UTCDateTime(DateTime(d, t))

UTCDateTime(zdt::ZonedDateTime) = UTCDateTime(DateTime(zdt, Dates.UTC))

include("dates.jl")
include("timezones.jl")

end
