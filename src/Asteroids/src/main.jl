const sounds = (
    fire        = Sound(asset"fire.wav",      volume = 20),
    explosion   = Sound(asset"explosion.wav", volume = 20),
    gameover    = Sound(asset"game-over.wav", volume = 50)
)

@setup function()
    ship = Ship()
    asteroids = Asteroid[]
    lasers = Laser[]
    points = 0
    life = 100
    time = 0.0
    waiting = true
    wave = 0
    paused = false
end

onkeypress(@window) do event
    key = keyname(event) |> uppercase
    if key == "D"
        setrotation!(ship, 0.1)
    elseif key == "A"
        setrotation!(ship, -0.1)
    elseif key == "W"
        boosting!(ship, true)
    elseif key == "ESCAPE"
        global paused = !paused
    end
end

onmousedown(@canvas) do event
    if !paused
        push!(lasers, Laser(ship.pos..., ship.heading))
        stop(sounds.fire)
        play(sounds.fire)
    end
end

onmouseup(@canvas) do event
    boosting!(ship, false)
end

onevent("key-release-event", @window) do args...
    setrotation!(ship, 0)
end

function update(dt)
    w, h = size(@canvas)
    @layer begin
        background("#111")
        renderhud()
        if paused
            sethue("yellow")
            fontsize(28)
            text("Game paused", w/2, h/2, halign = :center, valign = :center)
            return;
        end

        if life <= 0
            return endgame()
        end
        
        for asteroid in asteroids
            render(asteroid)
            update!(asteroid)
            edges(asteroid)

            if hits(ship, asteroid)
                global life -= 1
            end
        end

        for i in length(lasers):-1:1
            render(lasers[i])
            update!(lasers[i])
            for j in length(asteroids):-1:1
                if lasers[i] --> asteroids[j]
                    new = breakup!(asteroids[j])
                    !isempty(new) && append!(asteroids, new)

                    stop(sounds.explosion)
                    play(sounds.explosion)

                    splice!(asteroids, j)
                    splice!(lasers, i)

                    global points += 1
                    break
                end
            end
            cleanlasers(i)
        end

        render(ship)
        turn!(ship)
        update!(ship)
        edges(ship)

        if isempty(asteroids) && !waiting
            global waiting = true
            global time = 0
        end
        
        newwave()
        
        global time += dt
    end
end

function cleanlasers(i::Int)
    if !isempty(lasers) && i < length(lasers)
        x, y = lasers[i].pos
        if x < 0 || x > @width() || y < 0 || y > @height()
            splice!(lasers, i)
        end
    end
end

function renderhud()
    sethue("white")
    fontsize(16)
    text("Points: $points", 30, 30)
    text("Wave: $wave", 120, 30)

    enemies = length(asteroids)
    text("Enemies remaining: $enemies", 200, 30)


    lp = life / 100
    hue = mapr(lp, 0, 1, 0, 90)

    sethue(HSL(hue, .65, .6))
    barh = 10
    rect(0, @height() - barh, @width() * lp, barh, :fill)
    text("Life: $(floor(Int, 100 * lp))%", 10, @height() - 20)
end

function endgame()
    @layer begin
        background("red")
        origin()
        fontsize(28)
        sethue("#111")
        text("Game Over", O, halign = :center, valign = :middle)
    end
    renderhud()
    play(sounds.gameover)
    loop!(false)
end

function showtimer()
    t = floor(Int, time)
    @layer begin
        origin()
        fontsize(28)
        sethue("white")
        text("Wave starting at $(5 - t)s", 0, -120, halign = :center, valign = :middle)
    end
end

function newwave()
    global waiting, time, wave, life;
    if waiting
        if time >= 5
            waiting = false
            wave += 1
            time = 0
            if life < 100
                life += 20
            end
            append!(asteroids, [Asteroid() for i in 1:3wave])
            @info "Wave started!"
        else
            showtimer()
        end
    end
end

onevent(:destroy, @window) do args...
    for sound in sounds
        Sounds.destroy!(sound)
    end
end