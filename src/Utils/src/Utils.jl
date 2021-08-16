module Utils

using Lynx
using Luxor
using MacroTools

export triangle
export Mouse
export Map
export @init
export @setup
export @var

mutable struct Mouse
    x::Real
    y::Real
    dx::Real
    dy::Real
    zoom::Real
    Mouse() = new()
end

function Mouse(canvas::Canvas)
    this = Mouse()
    this.zoom = 1
    onmousemove(canvas) do event
        if isdefined(this, :x)
            this.dx = event.x - this.x
            this.dy = event.y - this.y
        end
        this.x = event.x
        this.y = event.y
    end
    onscroll(canvas) do event
        dir = event.direction
        this.zoom += 0.1 * dir
    end
    return this
end

macro var(expr)
    if @capture(expr, name_(args__) = block_)
        var = Symbol("@$name")
        return esc( :( $(var)(source::LineNumberNode, ::Module, $(args...)) = $(block) ) )
    end
end

macro init(expr)
    if @capture(expr, function Name_(args__) body__ end)
        return quote
            function $(Name)($(args...))
                this = new()
                $(body...)
                return this
            end
        end |> esc
    elseif Meta.isexpr(expr, :block)
        return quote
            this = new()
            $(expr.args...)
            return this
        end |> esc
    end
end

macro setup(block)
    globals = Symbol[:width, :height]
    res = Expr[
        :(width = Lynx.@width),
        :(height = Lynx.@height)
    ]
    if @capture(block, function() body__ end | begin body__ end)
        foreach(body) do expr
            if @capture(expr, var_ = x_)
                push!(globals, var)
            end
            push!(res, expr)
        end
    end
    return esc(:(
        $(map(x -> :( $x = nothing ), globals)...);
        function setup()
            global $(globals...);
            $(res...) 
        end
    ))
end

triangle(x::Real, y::Real, d::Real) = Point[
    Point(x, y - d),
    Point(x - d, y + d),
    Point(x + d, y + d),
]

triangle(center::Point, d::Real) = triangle(center.x, center.y, d)

function triangle(x::Real, y::Real, d::Real, action::Symbol)
    vertices = triangle(x, y, d)
    poly(vertices, action, close = true)
end

end # Utils
