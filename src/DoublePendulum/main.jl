using Lynx
using Luxor

App("DoublePendulum", 900, 700)

var"@width"(args...) = :( width(@window) )
var"@height"(args...) = :( height(@window) )

const parameters = (
    # The length of each rod
    L₁ = 200, L₂ = 200,
    # The mass of each pendulum
    m₁ = 40, m₂ = 40,
    # Start angle of each rod
    θ₁ = π/2, θ₂ = π/6
)

function DoublePendulum()
    @unpack L₁, L₂, m₁, m₂, θ₁, θ₂ = parameters

    θ₁′, θ₂′ = 0, 0

    g = 1
    points = Point[]

    function drawPendulum(x1, y1, x2, y2)
        line(O, Point(x1, y1), :stroke)
        ellipse(x1, y1, m₁, m₁, :fill)

        line(Point(x1, y1), Point(x2, y2), :stroke)
        ellipse(x2, y2, m₂, m₂, :fill)
    end

    function update(dt)
        num1 =
            -g * (2m₁ + m₂) * sin(θ₁) -
             m₂ * g * sin(θ₁ - 2θ₂) -
             2sin(θ₁ - θ₂) * m₂ * ((θ₂′^2) * L₂ + (θ₁′^2) * L₁ * cos(θ₁ - θ₂))

        num2 = 2sin(θ₁ - θ₂) * (
            (θ₁′^2) * L₁ * (m₁ + m₂) + 
            g * (m₁ + m₂) * cos(θ₁) + 
            (θ₂′^2) * L₂ * m₂ * cos(θ₁ - θ₂)
        )

        den = 2m₁ + m₂ - m₂ * cos(2θ₁ - 2θ₂)
        θ₁″ = num1 / (L₁ * den)
        θ₂″ = num2 / (L₂ * den)

        origin(0, 0)
        background("#fefefe")
        sethue("#111")
        setline(2)
        origin(@width() / 2, 280)

        x1, y1 = L₁ * sin(θ₁), L₁ * cos(θ₁)
        x2, y2 = x1 + L₂ * sin(θ₂), y1 + L₂ * cos(θ₂)

        drawPendulum(x1, y1, x2, y2)

        θ₁′ += θ₁″
        θ₂′ += θ₂″
        θ₁ += θ₁′
        θ₂ += θ₂′
        
        !isempty(points) && poly(points, :stroke)
        
        length(points) > 1000 && splice!(points, 1)

        push!(points, Point(x2, y2))
    end
end

run!(DoublePendulum(); await = true)
