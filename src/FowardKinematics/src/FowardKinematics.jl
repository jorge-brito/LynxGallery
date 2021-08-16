module FowardKinematics

using Lynx
using Luxor
using Utils

Lynx.init("FowardKinematics", 800, 600)

include("segment.jl")
include("main.jl")

run!(update, setup, await=false)

end # FowardKinematics
