# This example was adapted from the orignal:
# "Coding Challenge #114: Bubble Sort Visualization"
# By Daniel Shiffman
# https://thecodingtrain.com/CodingChallenges/114-bubble-sort.html 

using Colors
using Lynx
using Luxor
using Random

App("BubbleSort", 800, 600)

@info "Running BubbleSort visualization"
@info "Click and drag with the mouse along the x-axis to change the length of the array."
@info "Right-click to shuffle the array and restart the algorithm"

const Pt = Point

function swap!(array::Array, a::Int, b::Int)
    record = array[a]
    array[a] = array[b]
    array[b] = record
end

function BubbleSort()
    N = 600
    values = collect(1:N)
    shuffle!(values)

    i = 1

    onmousedown(@canvas) do event
        if event.button == 3
            shuffle!(values)
            i = 1
        end
    end

    onmousedrag(@canvas) do event
        i = 1
        N = floor(Int, event.x)
        values = collect(1:N)
        shuffle!(values)
    end

    function update(dt)
        w, h = size(@canvas)
        background("#111")
        sethue("white")
        fontsize(14)
        text("Sorting array of $N numbers.", w / 2, 50, halign = :center)
        if !paused
            if i <= N
                for j in 1:N - i
                    a = values[j]
                    b = values[j + 1]
                    a > b && swap!(values, j, j + 1)
                end
                i += 1
            else
                @info "Finished"
                loop!(false)
            end
        end

        barw = w / N
        for (i, value) in pairs(values)
            x = (i - 1) * barw
            y = mapr(value, 1:N, 0:h)
            hue = mapr(i, 1:N, 0:360)
            sethue(HSL(hue, .85, .65))
            rect(x, h - y, barw, y, :fill)
        end
    end
end

run!(BubbleSort(); await = true)
