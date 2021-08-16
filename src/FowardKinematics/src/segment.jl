const Maybe{T} = Union{Nothing, T}

Base.copy(pt::Point) = Point(pt.x, pt.y)

mutable struct Segment
    a::Point
    b::Point
    t::Real
    len::Real
    angle::Real
    sangle::Real
    parent::Maybe{Segment}
    child::Maybe{Segment}
    @init function Segment(x::Real, y::Real, len::Real, angle::Real, t::Real)
        this.a = Point(x, y)
        this.len = len
        this.angle = angle
        this.sangle = angle
        this.parent = nothing
        this.child = nothing
        this.t = t
        calculateB!(this)
    end

    @init function Segment(parent::Segment, len::Real, angle::Real, t::Real)
        this.a = copy(parent.b)
        this.b = this.a + len * Point(cos(angle), sin(angle))
        this.len = len
        this.angle = angle
        this.sangle = angle
        this.parent = parent
        this.t = t   
        this.child = nothing
    end
end

function calculateB!(this::Segment)
    this.b = this.a + this.len * Point(
        cos(this.angle), 
        sin(this.angle)
    )
end


function draw(this::Segment)
    sethue("white")
    setline(4)
    arrow(this.a, this.b, arrowheadlength=12)
    line(this.a, this.b, :stroke)
end

function wiggle!(this::Segment)
    maxangle =  0.3
    minangle = -0.3
    this.sangle = mapr(noise(this.t), 0, 1, maxangle, minangle)
    this.t += 0.03
end

function update!(this::Segment)
    this.angle = this.sangle
    if !isnothing(this.parent)
        this.a = copy(this.parent.b)
        this.angle += this.parent.angle
    else
        this.angle += -π/2
    end
    calculateB!(this)
end