Lynx.init("SnakeGame", 800, 600)

@setup function()
    time = 0
    points = 0

    colors = Settings.colors
    rez = Settings.resolution

    w = floor(Int, width / rez)
    h = floor(Int, height / rez)

    snake = Snake()
    food = Food()

    spawn!(food)
    framerate!(Settings.framerate)
end

onkeypress(@window) do event
    key = keyname(event) |> uppercase
    dir = nothing;
    if key in KeyMap.LEFT
        dir = Dir.LEFT
    elseif key in KeyMap.RIGHT
        dir = Dir.RIGHT
    elseif key in KeyMap.DOWN
        dir = Dir.DOWN
    elseif key in KeyMap.UP
        dir = Dir.UP
    end
    if !isnothing(dir) && dir != -snake.dir
        setdir!(snake, dir)
    end
end

function gameover!()
    background(colors.gameover)
    origin()
    fontsize(28)
    sethue("white")
    text("Game Over", halign = :center)
end

function gameinfo()
    origin(0, 0)
    fontsize(16)
    t = floor(Int, time)
    text("Time: $(t)s", 40, 40)
    text("Score: $points", 120, 40)
end

function update(dt::Real)
    background(colors.bg)
    origin(0, 0)
    gameinfo()
    scale(rez)

    update!(snake)
    draw(food)
    draw(snake)
    if endgame(snake)
        gameover!()
        gameinfo()
        @info "Game over"
        return loop!(false)
    end

    if eat(snake, food)
        grow(snake)
        spawn!(food)
        global points += 1
    end

    global time += dt
end