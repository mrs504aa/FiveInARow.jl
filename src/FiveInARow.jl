module FiveInARow

function __init__()
    ENV["QSG_RENDER_LOOP"] = "basic"
end

include("BoardFuncs.jl")

include("GtkUsingAndDefs.jl")
include("GtkWindowFuncs.jl")
include("GtkGameFuncs.jl")

include("QtUsingAndDefs.jl")
include("QtGameFuncs.jl")

export GtkStartGame, QtStartGame

end
