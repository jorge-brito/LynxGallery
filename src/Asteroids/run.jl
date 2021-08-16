push!(LOAD_PATH, joinpath(@__DIR__, ".."))

var"@run"(args...) = :( include(joinpath(@__DIR__, "src/Asteroids.jl")) )

@run