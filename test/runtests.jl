using UTCDateTimes
using Test

using Dates
using TimeZones

@testset "UTCDateTimes.jl" begin
    include("traits.jl")
    include("dates.jl")
    include("timezones.jl")
    include("io.jl")
end
