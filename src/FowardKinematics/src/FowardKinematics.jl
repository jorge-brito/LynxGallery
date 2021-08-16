# This example was adapted from: Coding Challenge #64.1 "Foward Kinematics"
# by Daniel Shiffman
#
# https://thecodingtrain.com/CodingChallenges/064.1-forward-kinematics.html

module FowardKinematics

using Lynx
using Luxor
using Utils

Lynx.init("FowardKinematics", 800, 600)

include("segment.jl")
include("main.jl")

run!(update, setup, await=true)

end # FowardKinematics
