import Pkg

include("templates.jl")

const LynxRepo = "https://github.com/jorge-brito/Lynx.jl"

function newapp(name::String, deps::Vector = [])
    path = joinpath(@__DIR__, "..", "src", name)
    cd(joinpath(@__DIR__, "..", "src"))
    Pkg.generate(name)
    @info "New app '$name' is located at $path"
    cd(path)

    write("README.md", README(name))
    write(joinpath("src", "$name.jl"), ENTRY_POINT(name))
    mkdir(".vscode")
    write(".vscode/tasks.json", VSCODE_TASKS(name))

    if !isempty(deps)
        Pkg.activate(".")
        for dep in deps
            @info "Adding dependency '$dep'"
            Pkg.add(dep)
        end
        Pkg.add(url=LynxRepo)
    end
end

if !isempty(ARGS)
    name = ARGS[1]
    deps = ARGS[2:end]
    if Meta.isidentifier(name)
        newapp(name, [deps..., "Luxor", "Colors"])
    else
        @error "The new app must have a valid name."
    end
else
    @error """No name argument specified

    Usage: 
    
        julia ./newapp.jl <name> [dependencies]

    Example:

        julia ./newapp.jl MyApp
        julia ./newapp.jl AnotherApp Dep1 Dep2 Dep3
        
    """
end