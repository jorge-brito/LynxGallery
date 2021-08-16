@setup function()
    local len = 50
    tentacle = Segment(width/2, height, len, 0, 0)
    local current = tentacle
    local t = 0.0
    for i in 1:20
        t += 0.1
        len *= 0.75
        next = Segment(current, 20, 0, t)
        current.child = next
        current = next
    end

    xoff = 0
end

function update(dt)
    background("#111")

    next = tentacle
    while !isnothing(next)
        wiggle!(next)
        update!(next)
        draw(next)
        next = next.child
    end
end