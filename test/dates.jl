@testset "Dates.jl stdlib" begin
    uyear = 2022
    umonth = 3
    uday = 2
    uhour = 13
    uminute = 30
    usecond = 45
    umillisecond = 8

    date = Date(uyear, umonth, uday)
    time = Time(uhour, uminute, usecond, umillisecond)
    utcdt = UTCDateTime(date, time)
    dt = DateTime(uyear, umonth, uday, uhour, uminute, usecond, umillisecond)
    expected = UTCDateTime(dt)

    @testset "Constructors and accessors" begin
        @test utcdt == expected
        @test Date(utcdt) == date
        @test Time(utcdt) == time
        @test DateTime(utcdt) == dt
        @test UTCDateTime(uyear, umonth, uday, uhour, uminute, usecond, umillisecond) ==
            expected
        @test Date(UTCDateTime(uyear, umonth, uday)) == date
        @test UTCDateTime(
                Year(uyear),
                Month(umonth),
                Day(uday),
                Hour(uhour),
                Minute(uminute),
                Second(usecond),
                Millisecond(umillisecond)
            ) == expected
        @test Date(
                UTCDateTime(
                    Year(uyear),
                    Month(umonth),
                    Day(uday)
                ),
            ) == date
        @test Time(
                UTCDateTime(
                    Hour(uhour),
                    Minute(uminute),
                    Second(usecond),
                    Millisecond(umillisecond)
                ),
            ) == time

        @test year(expected) == uyear
        @test quarterofyear(expected) == 1
        @test month(expected) == umonth
        @test day(expected) == uday
        @test hour(expected) == uhour
        @test minute(expected) == uminute
        @test second(expected) == usecond
        @test millisecond(expected) == umillisecond

        @test Year(expected) == Year(uyear)
        @test Quarter(expected) == Quarter(1)
        @test Month(expected) == Month(umonth)
        @test Week(expected) == Week(9)
        @test Day(expected) == Day(uday)
        @test Hour(expected) == Hour(uhour)
        @test Minute(expected) == Minute(uminute)
        @test Second(expected) == Second(usecond)
        @test Millisecond(expected) == Millisecond(umillisecond)

        @test yearmonth(expected) == (uyear, umonth)
        @test monthday(expected) == (umonth, uday)
        @test yearmonthday(expected) == (uyear, umonth, uday)
    end

    @testset "Conversions" begin
        @test convert(UTCDateTime, dt) == utcdt
        @test convert(DateTime, utcdt) == dt
    end

    @testset "Comparisons and arithmetic" begin
        @test utcdt - utcdt == Millisecond(0)
        @test utcdt + Day(1) ==
            UTCDateTime(uyear, umonth, uday + 1, uhour, uminute, usecond, umillisecond)
        @test utcdt - Day(1) ==
            UTCDateTime(uyear, umonth, uday - 1, uhour, uminute, usecond, umillisecond)
        @test utcdt + Dates.CompoundPeriod([Day(1), Second(2)]) ==
            UTCDateTime(uyear, umonth, uday + 1, uhour, uminute, usecond + 2, umillisecond)
        @test utcdt - Dates.CompoundPeriod([Day(1), Second(2)]) ==
            UTCDateTime(uyear, umonth, uday - 1, uhour, uminute, usecond - 2, umillisecond)

        days_worth = [UTCDateTime(uyear, umonth, uday, h) for h in 0:23]
        # test range behaviour
        @test collect(first(days_worth):Hour(1):last(days_worth)) == days_worth
    end

    @testset "Adjusters" begin
        @testset "of=$of" for of in (Month, Year)
            @test Dates.tofirst(utcdt, 3; of=of) ===
                UTCDateTime(Dates.tofirst(utcdt.dt, 3; of=of))
            @test Dates.tolast(utcdt, 3; of=of) ===
                UTCDateTime(Dates.tolast(utcdt.dt, 3; of=of))
        end

        @test Dates.tonext(utcdt, 3) === UTCDateTime(Dates.tonext(utcdt.dt, 3))
        @test Dates.toprev(utcdt, 3) === UTCDateTime(Dates.toprev(utcdt.dt, 3))
    end

    @testset "Rounding" begin
        uphour = UTCDateTime(uyear, umonth, uday, uhour + 1)
        downhour = UTCDateTime(uyear, umonth, uday, uhour)

        @test trunc(utcdt, Hour) === downhour

        @test round(utcdt, Hour) === uphour
        @test round(utcdt, Hour(1)) === uphour
        @test round(utcdt, Hour, RoundDown) === downhour
        @test round(utcdt, Hour(1), RoundDown) === downhour

        @test floor(utcdt, Hour) === downhour
        @test floor(utcdt, Hour(1)) === downhour

        @test ceil(utcdt, Hour) === uphour
        @test ceil(utcdt, Hour(1)) === uphour
    end
end
