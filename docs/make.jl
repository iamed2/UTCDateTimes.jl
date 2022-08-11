using UTCDateTimes
using Documenter

DocMeta.setdocmeta!(UTCDateTimes, :DocTestSetup, :(using UTCDateTimes); recursive=true)

makedocs(;
    modules=[UTCDateTimes],
    authors="Invenia Technical Computing Corporation",
    repo="https://github.com/invenia/UTCDateTimes.jl/blob/{commit}{path}#{line}",
    sitename="UTCDateTimes.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://invenia.github.io/UTCDateTimes.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
    checkdocs=:exports,
    strict=true,
)

deploydocs(;
    repo="github.com/invenia/UTCDateTimes.jl",
    devbranch="main",
)
