module Asteroids

using Lynx
using Luxor
using Colors

using Sounds
using Utils
using LinearAlgebra

@info "Running 'Asteroids'"

Lynx.init("Asteroids", 800, 600)

macro asset_str(expr)
    :( joinpath(@__DIR__, "..", "assets", $(esc(expr))) )
end

random(a::Real, b::Real) = rand() * (b - a) + a
random(range::AbstractRange) = random(first(range), last(range))

include("game.jl")
include("asteroid.jl")
include("laser.jl")
include("ship.jl")
include("main.jl")

run!(update, setup, await=true)

end # Asteroids
