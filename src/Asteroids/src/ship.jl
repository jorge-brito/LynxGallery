mutable struct Ship <: GameObject
    r::Real
    heading::Real
    rotation::Real
    pos::Vector{<:Real}
    vel::Vector{<:Real}
    isboosting::Bool
    @init function Ship()
        this.pos = [@width() / 2, @height() / 2]
        this.r = 20
        this.heading = 0
        this.rotation = 0
        this.vel = [0, 0]
        this.isboosting = false
    end
end

boosting!(this::Ship, val::Bool) = setproperty!(this, :isboosting, val)

function update!(this::Ship)
    this.isboosting && boost!(this)
    this.pos += this.vel
    this.vel *= 0.95
end

function boost!(this::Ship)
    ϕ = this.heading
    force = [cos(ϕ), sin(ϕ)] * 0.3
    this.vel += force
end

function render(this::Ship)
    r = this.r
    x, y = this.pos
    @layer begin
        translate(x, y)
        rotate(this.heading + π/2)

        poly([Point(-r, r), Point(r, r), Point(0, -r)], :path, close=true)
        sethue("#111"); fillpreserve()
        sethue("white"); strokepath()
    end
end

function setrotation!(this::Ship, dθ::Real)
    this.rotation = dθ
end

function turn!(this::Ship)
    this.heading += this.rotation
end

function hits(this::Ship, asteroid::Asteroid)
    d = distance(Point(this.pos...), Point(asteroid.pos...))
    return d < this.r + asteroid.r
end