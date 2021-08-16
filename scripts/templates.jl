README(name) = """
# $name

This project was made with the `Lynx.jl` package.

## Preview

![Preview](preview.gif)

## License

This project is part of the [Lynx Gallery](https://github.com/jorge-brito/LynxGallery) repository
which is licensed under the [MIT license](https://github.com/jorge-brito/LynxGallery.jl/blob/master/LICENSE).
"""

ENTRY_POINT(name) = """
module $name

using Lynx
using Luxor

@info "Running '$name'"

Lynx.init("$name", 400, 400)

function update(dt)
    # draw here
    background("#111")
end

run!(update, await=true)

end # $name
"""

VSCODE_TASKS(name) = """
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Run project",
            "type": "shell",
            "command": "julia --project=.  -e 'push!(LOAD_PATH, joinpath(pwd(), \\"..\\")); include(\\"src/$name.jl\\")'",
            "problemMatcher": []
        }
    ],
}
"""