function NewApp(name::String)
    mkdir(joinpath("src", name))
    write(joinpath("src", name, "main.jl"), """
    using Lynx
    using Luxor

    App("$name", 800, 600)

    function $name()
        # setup code here

        function update(dt)
            background("black")
            # drawing code here
        end
    end

    run!($name(); await = true)
    """)
end

NewApp(ARGS[1])