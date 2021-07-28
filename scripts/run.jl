current = read(joinpath(@__DIR__, "current"), String) |> strip
include(joinpath(pwd(), "src", current, "main.jl"))