abstract type GameObject end

function edges(this::GameObject)
    pos = this.pos
    if pos[1] > this.r + @width
        pos[1] = -this.r
    elseif this.pos[1] < -this.r
        pos[1] = this.r + @width
    end

    if pos[2] > this.r + @height
        pos[2] = -this.r
    elseif this.pos[2] < -this.r
        pos[2] = this.r + @height
    end
end