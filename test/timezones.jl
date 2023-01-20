@testset "TimeZones.jl" begin
    # these all represent the same time
    utc_zdt = ZonedDateTime(2022, 3, 1, tz"UTC")
    fixed_zdt = astimezone(utc_zdt, tz"UTC+1")
    variable_zdt = astimezone(utc_zdt, tz"America/Winnipeg")
    utcdt = UTCDateTime(DateTime(2022, 3, 1))

    @testset "Create from ZonedDateTime" begin
        @test UTCDateTime(utc_zdt) === utcdt
        @test UTCDateTime(fixed_zdt) === utcdt
        @test UTCDateTime(variable_zdt) === utcdt
        @test convert(UTCDateTime, utc_zdt) == utcdt
        @test convert(UTCDateTime, fixed_zdt) === utcdt
        @test convert(UTCDateTime, variable_zdt) === utcdt
    end

    @testset "Convert to ZonedDateTime" begin
        new_utc_zdt1 = ZonedDateTime(utcdt)
        new_utc_zdt2 = ZonedDateTime(utcdt, tz"UTC")
        new_utc_zdt3 = ZonedDateTime(utcdt, tz"UTC"; from_utc=true)
        new_fixed_zdt = ZonedDateTime(utcdt, tz"UTC+1")
        new_variable_zdt = ZonedDateTime(utcdt, tz"America/Winnipeg")

        @test new_utc_zdt1 === utc_zdt
        @test new_utc_zdt2 === utc_zdt
        @test new_utc_zdt3 === utc_zdt
        @test new_fixed_zdt === fixed_zdt
        @test new_variable_zdt === variable_zdt
        @test convert(ZonedDateTime, utcdt) === utc_zdt

        @test_throws ArgumentError ZonedDateTime(utcdt, tz"UTC"; from_utc=false)
    end

    @testset "TimeZones.jl accessors" begin
        @test timezone(utcdt) == tz"UTC"
    end

    @testset "Interoperation" begin
        # this is unfortunate but idk the best way to handle this
        @test astimezone(utcdt, tz"UTC") === utc_zdt

        @test astimezone(utcdt, tz"UTC+1") === fixed_zdt
        @test astimezone(utcdt, tz"America/Winnipeg") === variable_zdt

        @test utcdt == utc_zdt
        @test utcdt == fixed_zdt
        @test utcdt == variable_zdt
        @test variable_zdt == utcdt

        @test utc_zdt - utcdt == Millisecond(0)
        @test utcdt - utc_zdt == Millisecond(0)
        @test utcdt - fixed_zdt == Millisecond(0)
        @test utcdt - variable_zdt == Millisecond(0)
        @test !(utc_zdt < utcdt)
        @test !(utcdt < utc_zdt)
        @test !(utcdt < fixed_zdt)
        @test !(utcdt < variable_zdt)
        @test utcdt < variable_zdt + Second(1)
    end

    @testset "zdt2unix" begin
        @test TimeZones.zdt2unix(utcdt) == 1.6460928e9
        @test UTCDateTimes.zdt2unix(Integer, utcdt) == 1646092800
        @test UTCDateTimes.zdt2unix(Real, utcdt) == 1.6460928e9
    end
end
