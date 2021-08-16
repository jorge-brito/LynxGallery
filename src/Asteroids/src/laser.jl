mutable struct Laser <: GameObject
    pos::Vector{<:Real}
    vel::Vector{<:Real}
    @init function Laser(x::Real, y::Real, ϕ::Real)
        this.pos = [x, y]
        this.vel = 10 * [cos(ϕ), sin(ϕ)]
    end
end

function update!(this::Laser)
    this.pos += this.vel
end

function render(this::Laser)
    @layer begin
        sethue("white")
        circle(this.pos..., 4, :fill)
    end
end

function -->(this::Laser, asteroid::Asteroid)
    d = distance(Point(this.pos...), Point(asteroid.pos...))
    return d < asteroid.r
end