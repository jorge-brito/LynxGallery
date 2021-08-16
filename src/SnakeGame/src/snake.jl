mutable struct Snake
    body::Vector
    dir::Vector
    @init function Snake()
        this.body = [[w/2, h/2]]
        this.dir = [1, 0]
    end
end

setdir!(this::Snake, dir::Vector) = (this.dir = dir;)

function update!(this::Snake)
    head = [0., 0.]
    copy!(head, last(this.body))
    popfirst!(this.body)
    head += this.dir
    push!(this.body, head)
end

function draw(this::Snake)
    sethue(colors.snake)
    foreach(this.body) do pos
        rect(pos..., 1, 1, :fill)
    end
end

function eat(this::Snake, food::Food)
    x, y = last(this.body)
    return x == food.x && y == food.y
end

function grow(this::Snake)
    head = [0., 0.]
    copy!(head, last(this.body))
    push!(this.body, head)
end

function endgame(this::Snake)
    x, y = last(this.body)
    
    if x < 0 || x > w - 1 || y < 0 || y > h - 1
        return true
    end
    
    for pos in this.body[1:end-1]
        if pos == [x, y]
            return true
        end
    end

    return false
end