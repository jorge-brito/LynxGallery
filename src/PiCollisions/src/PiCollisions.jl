module PiCollisions

using Lynx
using Luxor

@info "Running 'PiCollisions'"

Lynx.init("PiCollisions", 400, 400)

function update(dt)
    # draw here
    background("#111")
end

run!(update, await=true)

end # PiCollisions
