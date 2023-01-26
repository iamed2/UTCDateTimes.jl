@testset "io" begin
    format = Dates.default_format(UTCDateTime)

    rt_tests = [
        ("2022-11-12T01:02:03.987", UTCDateTime(2022, 11, 12, 1, 2, 3, 987)),
        ("2022-11-12T01:02:03", UTCDateTime(2022, 11, 12, 1, 2, 3)),
    ]

    parse_tests = [
        rt_tests...,
        ("2022-11-12T01:02", UTCDateTime(2022, 11, 12, 1, 2)),
        ("2022-11-12T01", UTCDateTime(2022, 11, 12, 1)),
        ("2022-11-12", UTCDateTime(2022, 11, 12)),
        ("2022-11", UTCDateTime(2022, 11)),
        ("2022", UTCDateTime(2022)),
    ]

    format_tests = [
        ("2022-11-12T01:02:03.987", UTCDateTime(2022, 11, 12, 1, 2, 3, 987)),
        ("2022-11-12T01:02:03.0", UTCDateTime(2022, 11, 12, 1, 2, 3)),
        ("2022-11-12T01:02:00.0", UTCDateTime(2022, 11, 12, 1, 2)),
        ("2022-11-12T01:00:00.0", UTCDateTime(2022, 11, 12, 1)),
        ("2022-11-12T00:00:00.0", UTCDateTime(2022, 11, 12)),
        ("2022-11-01T00:00:00.0", UTCDateTime(2022, 11)),
        ("2022-01-01T00:00:00.0", UTCDateTime(2022)),
    ]

    @testset "parsing" begin
        @testset for (str, utcdt) in parse_tests
            @test parse(UTCDateTime, str) == utcdt
        end

        @testset for (str, utcdt) in parse_tests
            @test parse(UTCDateTime, str, format) == utcdt
        end
    end

    @testset "printing" begin
        @testset for (str, utcdt) in rt_tests
            @test sprint(print, utcdt) == str
        end

        @testset for (str, utcdt) in format_tests
            @test Dates.format(utcdt, format) == str
        end
    end
end
