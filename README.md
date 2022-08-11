# UTCDateTimes

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://invenia.github.io/UTCDateTimes.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://invenia.github.io/UTCDateTimes.jl/dev/)
[![Build Status](https://github.com/invenia/UTCDateTimes.jl/actions/workflows/JuliaNightly.yml/badge.svg?branch=main)](https://github.com/invenia/UTCDateTimes.jl/actions/workflows/JuliaNightly.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/invenia/UTCDateTimes.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/invenia/UTCDateTimes.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

`UTCDateTime` is a very simple time zone aware datetime representation that is always in the UTC time zone.
It implements (WIP) the same public API as `DateTime` and `ZonedDateTime`, and provides time zone aware interoperation with `ZonedDateTime`.
It provides substantial performance benefits over [`ZonedDateTime`](https://github.com/JuliaTime/TimeZones.jl) if you only need the UTC time zone.

It is implemented as a thin wrapper around `DateTime`:

```julia
struct UTCDateTime <: Dates.AbstractDateTime
    dt::DateTime
end
```

## Performance Comparison

```julia
julia> using UTCDateTimes, TimeZones, Dates, BenchmarkTools

julia> mathing(dt) = dt + Hour(3) - Day(1)
mathing (generic function with 1 method)

julia> utcdt = UTCDateTime(2022); zdt = ZonedDateTime(2022, tz"UTC"); dt = DateTime(2022);

julia> @benchmark mathing($zdt)
BenchmarkTools.Trial: 10000 samples with 998 evaluations.
 Range (min … max):  16.727 ns … 150.349 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     16.889 ns               ┊ GC (median):    0.00%
 Time  (mean ± σ):   20.212 ns ±   7.517 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

  █▁        ▁▁▁▁▂▂▃▂▂▁  ▁▂                                     ▁
  █████████████████████████▆▇▇▇▆▇▆██▇▇▆▆▆▆▆▆▆▆▅▅▅▆▅▅▄▄▁▆▄▅▄▅▄▄ █
  16.7 ns       Histogram: log(frequency) by time      51.5 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.

julia> @benchmark mathing($dt)
BenchmarkTools.Trial: 10000 samples with 1000 evaluations.
 Range (min … max):  1.134 ns … 26.450 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.143 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.206 ns ±  0.703 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

  █▆▁▁                                                       ▁
  █████▆▆▆▄▅▃▅▃▄▃▃▃▁▁▁▃▁▁▁▄▄▃▁▁▃▃▁▃▁▅▃▄▁▁▃▁▄▁▄▃▁▃▁▃▅▇█████▇▇ █
  1.13 ns      Histogram: log(frequency) by time     1.79 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.

julia> @benchmark mathing($utcdt)
BenchmarkTools.Trial: 10000 samples with 1000 evaluations.
 Range (min … max):  1.134 ns … 46.650 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.144 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.222 ns ±  0.828 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

  █▇▁ ▂▁                                          ▁▁▁▁▁▁     ▁
  ██████▇▆▆▄▅▇█▆▄▄▃▃▃▁▃▁▄▁▁▄▁▁▁▃▃▄▁▁▁▃▁▁▁▁▁▁▁▁▁▁▃▇█████████▇ █
  1.13 ns      Histogram: log(frequency) by time     1.82 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.
```
