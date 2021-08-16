mutable struct Asteroid <: GameObject
    r::Real
    pos::Vector
    total::Int
    offset::Vector
    vel::Vector{<:Real}
    @init function Asteroid(pos = nothing, r = rand(15:50))
        rpos = randompoint(0, 0, @width, @height)
        this.pos = isnothing(pos) ? [rpos.x, rpos.y] : pos
        this.r = r
        this.total = rand(5:15)
        this.offset = [random(-r, r) for i in 1:this.total]
        θ = random(0, 2π)
        this.vel = rand(1:5) .* [cos(θ), sin(θ)]
    end
end

function render(this::Asteroid)
    @layer begin
        sethue("white")
        translate(this.pos...)

        vertices = map(1:this.total) do i
            θ = mapr(i, 1, this.total, 0, 2π)
            r = this.r + this.offset[i]
            x = r * cos(θ)
            y = r * sin(θ)
            return Point(x, y)
        end
        
        poly(vertices, close = true, :stroke)
    end
end

function update!(this::Asteroid)
    this.pos += this.vel
end

function breakup!(this::Asteroid)
    if this.r >= 20
        return Asteroid[
            Asteroid(this.pos, this.r * .65),
            Asteroid(this.pos, this.r * .65)
        ]
    else
        return Asteroid[]
    end
end