import Pkg

function runapp(name::AbstractString)
    folder = joinpath(@__DIR__, "src", name)
    if isdir(folder)
        @info "Running $name"
        Pkg.activate(folder)
        push!(LOAD_PATH, joinpath(@__DIR__, "src"))
        include( joinpath(folder, "src", "$name.jl") )
        return true
    end
    return false
end

if !isempty(ARGS)
    name = ARGS[1]
    if !runapp(name)
        @error "App '$name' does not exist" 
    end
else
    @error """No name argument provided

    Usage: julia run.jl <appname>
    Example: julia run.jl Asteroids
    
    """
end