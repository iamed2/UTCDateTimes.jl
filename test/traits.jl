@testset "UTCDateTime traits" begin
    utcdt = UTCDateTime(DateTime(2022, 3, 1))
    @test isbits(utcdt)
    @test utcdt === deepcopy(utcdt)
    @test utcdt isa UTCDateTime
    @test utcdt isa Dates.AbstractDateTime
end
