# This example was adapted from: Coding Challenge #115: Snake Game Redux
# by Daniel Shiffman
#
# https://thecodingtrain.com/CodingChallenges/115-snake-game-redux.html

module SnakeGame

using Lynx
using Luxor
using Utils

include("config.jl")
include("food.jl")
include("snake.jl")
include("main.jl")

run!(update, setup, await=true)

end # SnakeGame
