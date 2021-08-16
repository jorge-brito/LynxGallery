mutable struct Food
    x::Real
    y::Real
    color::String
    Food() = new(0, 0)
end

function spawn!(food::Food)
    food.x = rand(0:w - 1)
    food.y = rand(0:h - 1)
    food.color = rand(["orange", "yellow", "yellowgreen", "indigo"])
end

function draw(food::Food)
    sethue(food.color)
    rect(food.x, food.y, 1, 1, :fill)
end